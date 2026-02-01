import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'supabase_manager.dart';

/// Modèle de période business
class BusinessPeriod {
  final String id;
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final String focusStrategique;
  final String energieBusiness;
  final Map<String, dynamic> fenetreStrategique;
  final List<String> actionsRecommandees;
  final List<String> risquesEviter;
  final List<Map<String, dynamic>> indicateursCles;
  final List<String> decisionsFavorables;
  final List<String> decisionsDefavorables;
  final String astuceStrategique;

  BusinessPeriod({
    required this.id,
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.focusStrategique,
    required this.energieBusiness,
    required this.fenetreStrategique,
    required this.actionsRecommandees,
    required this.risquesEviter,
    required this.indicateursCles,
    required this.decisionsFavorables,
    required this.decisionsDefavorables,
    required this.astuceStrategique,
  });

  factory BusinessPeriod.fromJson(Map<String, dynamic> json) {
    return BusinessPeriod(
      id: json['id'] ?? '',
      periodNumber: json['period_number'] ?? 0,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      focusStrategique: json['focus_strategique'] ?? '',
      energieBusiness: json['energie_business'] ?? '',
      fenetreStrategique: json['fenetre_strategique'] is Map
          ? Map<String, dynamic>.from(json['fenetre_strategique'])
          : {'points': []},
      actionsRecommandees: json['actions_recommandees'] is List
          ? List<String>.from(json['actions_recommandees'])
          : [],
      risquesEviter: json['risques_eviter'] is List
          ? List<String>.from(json['risques_eviter'])
          : [],
      indicateursCles: json['indicateurs_cles'] is List
          ? List<Map<String, dynamic>>.from(
              (json['indicateurs_cles'] as List).map((e) => Map<String, dynamic>.from(e)))
          : [],
      decisionsFavorables: json['decisions_favorables'] is List
          ? List<String>.from(json['decisions_favorables'])
          : [],
      decisionsDefavorables: json['decisions_defavorables'] is List
          ? List<String>.from(json['decisions_defavorables'])
          : [],
      astuceStrategique: json['astuce_strategique'] ?? '',
    );
  }

  List<String> get fenetrePoints {
    final points = fenetreStrategique['points'];
    if (points is List) {
      return List<String>.from(points);
    }
    return [];
  }
}

/// Info période actuelle avec calculs
class CurrentBusinessPeriodInfo {
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final int dayInPeriod;
  final int daysRemaining;
  final DateTime periodStartDate;
  final DateTime periodEndDate;
  final String focusStrategique;
  final String energieBusiness;
  final Map<String, dynamic> fenetreStrategique;
  final List<String> actionsRecommandees;
  final List<String> risquesEviter;
  final List<Map<String, dynamic>> indicateursCles;
  final List<String> decisionsFavorables;
  final List<String> decisionsDefavorables;
  final String astuceStrategique;

  CurrentBusinessPeriodInfo({
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.dayInPeriod,
    required this.daysRemaining,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.focusStrategique,
    required this.energieBusiness,
    required this.fenetreStrategique,
    required this.actionsRecommandees,
    required this.risquesEviter,
    required this.indicateursCles,
    required this.decisionsFavorables,
    required this.decisionsDefavorables,
    required this.astuceStrategique,
  });

  factory CurrentBusinessPeriodInfo.fromJson(Map<String, dynamic> json) {
    return CurrentBusinessPeriodInfo(
      periodNumber: json['period_number'] ?? 0,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      dayInPeriod: json['day_in_period'] ?? 0,
      daysRemaining: json['days_remaining'] ?? 0,
      periodStartDate: DateTime.tryParse(json['period_start_date'] ?? '') ?? DateTime.now(),
      periodEndDate: DateTime.tryParse(json['period_end_date'] ?? '') ?? DateTime.now(),
      focusStrategique: json['focus_strategique'] ?? '',
      energieBusiness: json['energie_business'] ?? '',
      fenetreStrategique: json['fenetre_strategique'] is Map
          ? Map<String, dynamic>.from(json['fenetre_strategique'])
          : {'points': []},
      actionsRecommandees: json['actions_recommandees'] is List
          ? List<String>.from(json['actions_recommandees'])
          : [],
      risquesEviter: json['risques_eviter'] is List
          ? List<String>.from(json['risques_eviter'])
          : [],
      indicateursCles: json['indicateurs_cles'] is List
          ? List<Map<String, dynamic>>.from(
              (json['indicateurs_cles'] as List).map((e) => Map<String, dynamic>.from(e)))
          : [],
      decisionsFavorables: json['decisions_favorables'] is List
          ? List<String>.from(json['decisions_favorables'])
          : [],
      decisionsDefavorables: json['decisions_defavorables'] is List
          ? List<String>.from(json['decisions_defavorables'])
          : [],
      astuceStrategique: json['astuce_strategique'] ?? '',
    );
  }

  List<String> get fenetrePoints {
    final points = fenetreStrategique['points'];
    if (points is List) {
      return List<String>.from(points);
    }
    return [];
  }
}

/// Entrée calendrier business
class BusinessCalendarEntry {
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;

  BusinessCalendarEntry({
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });

  factory BusinessCalendarEntry.fromJson(Map<String, dynamic> json) {
    return BusinessCalendarEntry(
      periodNumber: json['period_number'] ?? 0,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      isCurrent: json['is_current'] ?? false,
    );
  }
}

/// Calendrier annuel business
class BusinessYearCalendar {
  final DateTime referenceDate;
  final DateTime cycleStart;
  final DateTime cycleEnd;
  final int currentPeriod;
  final List<BusinessCalendarEntry> periods;

  BusinessYearCalendar({
    required this.referenceDate,
    required this.cycleStart,
    required this.cycleEnd,
    required this.currentPeriod,
    required this.periods,
  });

  factory BusinessYearCalendar.fromJson(Map<String, dynamic> json) {
    return BusinessYearCalendar(
      referenceDate: DateTime.tryParse(json['reference_date'] ?? '') ?? DateTime.now(),
      cycleStart: DateTime.tryParse(json['cycle_start'] ?? '') ?? DateTime.now(),
      cycleEnd: DateTime.tryParse(json['cycle_end'] ?? '') ?? DateTime.now(),
      currentPeriod: json['current_period'] ?? 1,
      periods: (json['periods'] as List?)
          ?.map((e) => BusinessCalendarEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? [],
    );
  }
}

/// Abonnement business
class BusinessSubscription {
  final String id;
  final String userId;
  final String companyName;
  final DateTime referenceDate;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  BusinessSubscription({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.referenceDate,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory BusinessSubscription.fromJson(Map<String, dynamic> json) {
    return BusinessSubscription(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      companyName: json['company_name'] ?? '',
      referenceDate: DateTime.tryParse(json['reference_date'] ?? '') ?? DateTime.now(),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'inactive',
    );
  }

  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now());
}

/// Service pour le Cycle Business
class BusinessCycleService {
  BusinessCycleService._();
  static final BusinessCycleService instance = BusinessCycleService._();

  SupabaseClient get _client => SupabaseManager.client;

  /// Récupérer toutes les périodes
  Future<List<BusinessPeriod>> getPeriods() async {
    try {
      final response = await _client
          .from('business_cycle_periods')
          .select()
          .eq('is_active', true)
          .order('period_number');
      
      return (response as List)
          .map((e) => BusinessPeriod.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('BusinessCycleService.getPeriods error: $e');
      return [];
    }
  }

  /// Récupérer la période actuelle via RPC
  Future<CurrentBusinessPeriodInfo?> getCurrentPeriod(DateTime referenceDate) async {
    try {
      final response = await _client.rpc(
        'fn_get_current_business_period',
        params: {
          'p_reference_date': referenceDate.toIso8601String().split('T')[0],
        },
      );
      
      if (response != null) {
        return CurrentBusinessPeriodInfo.fromJson(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (e) {
      debugPrint('BusinessCycleService.getCurrentPeriod error: $e');
      return null;
    }
  }

  /// Récupérer le calendrier annuel
  Future<BusinessYearCalendar?> getYearCalendar(DateTime referenceDate) async {
    try {
      final response = await _client.rpc(
        'fn_get_business_year_calendar',
        params: {
          'p_reference_date': referenceDate.toIso8601String().split('T')[0],
        },
      );
      
      if (response != null) {
        return BusinessYearCalendar.fromJson(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (e) {
      debugPrint('BusinessCycleService.getYearCalendar error: $e');
      return null;
    }
  }

  /// Récupérer l'abonnement actif
  Future<BusinessSubscription?> getActiveSubscription(String userId) async {
    try {
      final response = await _client
          .from('business_cycle_subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .gte('end_date', DateTime.now().toIso8601String().split('T')[0])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      
      if (response != null) {
        return BusinessSubscription.fromJson(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (e) {
      debugPrint('BusinessCycleService.getActiveSubscription error: $e');
      return null;
    }
  }

  /// Créer un abonnement après paiement
  Future<String?> createSubscription({
    required String userId,
    required String companyName,
    required DateTime referenceDate,
    required String paymentId,
  }) async {
    try {
      final response = await _client.rpc(
        'fn_create_business_cycle_subscription',
        params: {
          'p_user_id': userId,
          'p_company_name': companyName,
          'p_reference_date': referenceDate.toIso8601String().split('T')[0],
          'p_payment_id': paymentId,
        },
      );
      
      return response?.toString();
    } catch (e) {
      debugPrint('BusinessCycleService.createSubscription error: $e');
      return null;
    }
  }

  /// Vérifier si l'utilisateur a accès
  Future<bool> hasAccess(String userId) async {
    try {
      final response = await _client.rpc(
        'fn_check_business_cycle_access',
        params: {'p_user_id': userId},
      );
      return response == true;
    } catch (e) {
      debugPrint('BusinessCycleService.hasAccess error: $e');
      return false;
    }
  }
}
