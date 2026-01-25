import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';
import 'temporal_report_service.dart';

/// Types of purchases that can trigger bonuses
enum PurchaseType {
  compatibilityBasic,  // Base compatibility report
  yearForecast,        // Annual prediction
  monthForecast,       // Monthly prediction
  dayForecast,         // Daily prediction
}

/// Calculated bonus result for a purchase
class BonusResult {
  final bool includeYear;
  final bool includeMonth;
  final bool includeDay;
  final String? bonusMonthForDays;  // Month ID if 15+ days bought gives monthly bonus
  
  const BonusResult({
    this.includeYear = false,
    this.includeMonth = false,
    this.includeDay = false,
    this.bonusMonthForDays,
  });
  
  bool get hasAnyBonus => includeYear || includeMonth || includeDay || bonusMonthForDays != null;
  
  @override
  String toString() => 'BonusResult(year: $includeYear, month: $includeMonth, day: $includeDay, bonusMonth: $bonusMonthForDays)';
}

/// Configuration for purchase bonus rules (loaded from admin)
class BonusRulesConfig {
  final bool enabled;
  final int minDaysForMonthBonus;  // Minimum days to buy for same-month bonus (default: 15)
  
  // Compatibility purchase bonuses
  final bool compatibilityGivesYear;
  final bool compatibilityGivesMonth;
  final bool compatibilityGivesDay;
  
  // Year purchase bonuses
  final bool yearGivesMonth;
  final bool yearGivesDay;
  
  // Month purchase bonuses
  final bool monthGivesDay;
  
  const BonusRulesConfig({
    this.enabled = true,
    this.minDaysForMonthBonus = 15,
    this.compatibilityGivesYear = true,
    this.compatibilityGivesMonth = true,
    this.compatibilityGivesDay = true,
    this.yearGivesMonth = true,
    this.yearGivesDay = true,
    this.monthGivesDay = true,
  });
  
  factory BonusRulesConfig.defaults() => const BonusRulesConfig();
  
  factory BonusRulesConfig.fromJson(Map<String, dynamic> json) {
    return BonusRulesConfig(
      enabled: json['enabled'] as bool? ?? true,
      minDaysForMonthBonus: json['min_days_for_month_bonus'] as int? ?? 15,
      compatibilityGivesYear: json['compatibility_gives_year'] as bool? ?? true,
      compatibilityGivesMonth: json['compatibility_gives_month'] as bool? ?? true,
      compatibilityGivesDay: json['compatibility_gives_day'] as bool? ?? true,
      yearGivesMonth: json['year_gives_month'] as bool? ?? true,
      yearGivesDay: json['year_gives_day'] as bool? ?? true,
      monthGivesDay: json['month_gives_day'] as bool? ?? true,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'min_days_for_month_bonus': minDaysForMonthBonus,
    'compatibility_gives_year': compatibilityGivesYear,
    'compatibility_gives_month': compatibilityGivesMonth,
    'compatibility_gives_day': compatibilityGivesDay,
    'year_gives_month': yearGivesMonth,
    'year_gives_day': yearGivesDay,
    'month_gives_day': monthGivesDay,
  };
}

/// Service for managing purchase bonuses
class BonusService {
  BonusService._();
  static final BonusService instance = BonusService._();
  
  BonusRulesConfig? _cachedConfig;
  DateTime? _lastFetched;
  
  /// Load bonus rules configuration from app_settings
  Future<BonusRulesConfig> getBonusRulesConfig({bool forceRefresh = false}) async {
    // Return cached if fresh (< 5 minutes)
    if (!forceRefresh &&
        _cachedConfig != null &&
        _lastFetched != null &&
        DateTime.now().difference(_lastFetched!).inMinutes < 5) {
      return _cachedConfig!;
    }
    
    final client = SupabaseManager.isReady ? SupabaseManager.client : null;
    if (client == null) {
      debugPrint('BonusService: Supabase not ready, using defaults');
      return BonusRulesConfig.defaults();
    }
    
    try {
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'bonus_rules')
          .maybeSingle();
      
      if (response == null || response['value'] == null) {
        debugPrint('BonusService: No config found, using defaults');
        _cachedConfig = BonusRulesConfig.defaults();
      } else {
        _cachedConfig = BonusRulesConfig.fromJson(response['value'] as Map<String, dynamic>);
      }
      
      _lastFetched = DateTime.now();
      debugPrint('BonusService: Loaded config - enabled: ${_cachedConfig!.enabled}');
      return _cachedConfig!;
    } catch (e) {
      debugPrint('BonusService: Error loading config: $e');
      return BonusRulesConfig.defaults();
    }
  }
  
  /// Calculate which bonuses apply for a given purchase
  /// 
  /// Rules:
  /// - Compatibility basic → Year + Month + Day (all current)
  /// - Year forecast → Month (current) + Day (today)
  /// - Month forecast → Day (today)
  /// - Day forecast → No bonus, UNLESS 15+ days in same month → Month bonus for that month
  Future<BonusResult> calculateBonuses({
    required PurchaseType purchaseType,
    int? dayCount,           // Number of days if buying day forecasts
    int? targetMonth,        // Target month if checking for 15+ day bonus
    int? targetYear,         // Target year for context
  }) async {
    final config = await getBonusRulesConfig();
    
    if (!config.enabled) {
      debugPrint('BonusService: Bonuses disabled');
      return const BonusResult();
    }
    
    switch (purchaseType) {
      case PurchaseType.compatibilityBasic:
        // Compatibility gives all current bonuses
        return BonusResult(
          includeYear: config.compatibilityGivesYear,
          includeMonth: config.compatibilityGivesMonth,
          includeDay: config.compatibilityGivesDay,
        );
        
      case PurchaseType.yearForecast:
        // Year gives month + day
        return BonusResult(
          includeMonth: config.yearGivesMonth,
          includeDay: config.yearGivesDay,
        );
        
      case PurchaseType.monthForecast:
        // Month gives day only
        return BonusResult(
          includeDay: config.monthGivesDay,
        );
        
      case PurchaseType.dayForecast:
        // Day gives nothing, UNLESS 15+ days in same month
        if (dayCount != null && 
            dayCount >= config.minDaysForMonthBonus &&
            targetMonth != null) {
          // Format: YYYY-MM for the bonus month
          final year = targetYear ?? DateTime.now().year;
          final monthStr = targetMonth.toString().padLeft(2, '0');
          return BonusResult(
            bonusMonthForDays: '$year-$monthStr',
          );
        }
        return const BonusResult();
    }
  }
  
  /// Generate bonus reports based on calculated bonuses
  Future<Map<String, TemporalReport?>> generateBonusReports({
    required BonusResult bonusResult,
    required String userId,
    DateTime? referenceDate,
  }) async {
    final results = <String, TemporalReport?>{
      'annee': null,
      'mois': null,
      'jour': null,
    };
    
    if (!bonusResult.hasAnyBonus) {
      debugPrint('BonusService: No bonuses to generate');
      return results;
    }
    
    final now = referenceDate ?? DateTime.now();
    final service = TemporalReportService.instance;
    
    // Generate year bonus
    if (bonusResult.includeYear) {
      debugPrint('BonusService: Generating year bonus');
      results['annee'] = await service.generateReport(
        periode: 'annee',
        date: now,
        userId: userId,
      );
    }
    
    // Generate month bonus (current or specific)
    if (bonusResult.includeMonth) {
      debugPrint('BonusService: Generating month bonus (current)');
      results['mois'] = await service.generateReport(
        periode: 'mois',
        date: now,
        userId: userId,
      );
    } else if (bonusResult.bonusMonthForDays != null) {
      // Specific month bonus from 15+ day purchase
      debugPrint('BonusService: Generating month bonus for ${bonusResult.bonusMonthForDays}');
      final parts = bonusResult.bonusMonthForDays!.split('-');
      if (parts.length == 2) {
        final year = int.tryParse(parts[0]) ?? now.year;
        final month = int.tryParse(parts[1]) ?? now.month;
        results['mois'] = await service.generateReport(
          periode: 'mois',
          date: DateTime(year, month, 1),
          userId: userId,
        );
      }
    }
    
    // Generate day bonus (today)
    if (bonusResult.includeDay) {
      debugPrint('BonusService: Generating day bonus (today)');
      results['jour'] = await service.generateReport(
        periode: 'jour',
        date: now,
        userId: userId,
      );
    }
    
    debugPrint('BonusService: Generated ${results.values.where((r) => r != null).length} bonus reports');
    return results;
  }
  
  /// Clear cached config
  void clearCache() {
    _cachedConfig = null;
    _lastFetched = null;
  }
}
