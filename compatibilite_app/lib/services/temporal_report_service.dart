import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_manager.dart';

/// Settings for temporal bonuses included with base report
class TemporalBonusSettings {
  final bool enabled;
  final bool yearEnabled;
  final bool monthEnabled;
  final bool dayEnabled;

  const TemporalBonusSettings({
    this.enabled = true,
    this.yearEnabled = true,
    this.monthEnabled = true,
    this.dayEnabled = true,
  });

  /// Default settings with all bonuses enabled
  factory TemporalBonusSettings.defaults() => const TemporalBonusSettings();

  /// Check if any bonus is enabled
  bool get hasAnyBonus => enabled && (yearEnabled || monthEnabled || dayEnabled);
}

/// Model class representing a generated temporal report
class TemporalReport {
  final String id;
  final String periode; // 'jour', 'mois', 'annee'
  final DateTime dateReference;
  final int? numeroPeriode; // The vibration number for this period
  final String? etatRelationnel; // 'harmonieux', 'neutre', 'tendu'
  
  // Bloc 0 - Canon PDF
  final String? bloc0Titre;
  final String? bloc0Contenu;
  
  // Blocs 1-3 - Briques personnalisées
  final String? bloc1Contenu;
  final String? bloc2Contenu;
  final String? bloc3Contenu;
  
  final Map<String, dynamic>? contexte;

  TemporalReport({
    required this.id,
    required this.periode,
    required this.dateReference,
    this.numeroPeriode,
    this.etatRelationnel,
    this.bloc0Titre,
    this.bloc0Contenu,
    this.bloc1Contenu,
    this.bloc2Contenu,
    this.bloc3Contenu,
    this.contexte,
  });

  factory TemporalReport.fromJson(Map<String, dynamic> json) {
    // Parse contexte to get numbers
    final contexte = json['contexte'] as Map<String, dynamic>?;
    final numeros = contexte?['numeros'] as Map<String, dynamic>?;
    
    int? numeroPeriode;
    final periode = json['periode'] as String?;
    if (numeros != null && periode != null) {
      switch (periode) {
        case 'jour':
          numeroPeriode = numeros['jour'] as int?;
          break;
        case 'mois':
          numeroPeriode = numeros['mois'] as int?;
          break;
        case 'annee':
          numeroPeriode = numeros['annee'] as int?;
          break;
      }
    }
    
    return TemporalReport(
      id: json['id'] as String,
      periode: periode ?? '',
      dateReference: DateTime.parse(json['date_reference'] as String),
      numeroPeriode: numeroPeriode,
      etatRelationnel: json['etat_rel'] as String?,
      bloc0Titre: json['bloc0_titre'] as String?,
      bloc0Contenu: json['bloc0_contenu_md'] as String?,
      bloc1Contenu: json['bloc1_contenu'] as String?,
      bloc2Contenu: json['bloc2_contenu'] as String?,
      bloc3Contenu: json['bloc3_contenu'] as String?,
      contexte: contexte,
    );
  }

  /// Get all content blocks combined for display
  String get fullContent {
    final parts = <String>[];
    if (bloc0Contenu != null && bloc0Contenu!.isNotEmpty) {
      parts.add(bloc0Contenu!);
    }
    if (bloc1Contenu != null && bloc1Contenu!.isNotEmpty) {
      parts.add(bloc1Contenu!);
    }
    if (bloc2Contenu != null && bloc2Contenu!.isNotEmpty) {
      parts.add(bloc2Contenu!);
    }
    if (bloc3Contenu != null && bloc3Contenu!.isNotEmpty) {
      parts.add(bloc3Contenu!);
    }
    return parts.join('\n\n');
  }
  
  /// Get French label for the period
  String get periodeLabel {
    switch (periode) {
      case 'jour':
        return 'Jour';
      case 'mois':
        return 'Mois';
      case 'annee':
        return 'Année';
      default:
        return periode;
    }
  }
  
  /// Get French label for the relational state
  String get etatLabel {
    switch (etatRelationnel) {
      case 'harmonieux':
        return 'Harmonieux';
      case 'neutre':
        return 'Neutre';
      case 'tendu':
        return 'Tendu';
      default:
        return etatRelationnel ?? '';
    }
  }
}

/// Service for generating and fetching temporal reports from Supabase
class TemporalReportService {
  TemporalReportService._();
  static final TemporalReportService instance = TemporalReportService._();

  SupabaseClient? get _client => SupabaseManager.isReady ? SupabaseManager.client : null;

  // Cache for bonus settings
  TemporalBonusSettings? _cachedBonusSettings;
  DateTime? _settingsLastFetched;

  /// Get temporal bonus settings from app_settings table
  /// Returns settings indicating which bonuses are enabled
  Future<TemporalBonusSettings> getTemporalBonusSettings({bool forceRefresh = false}) async {
    // Return cached settings if fresh (less than 5 minutes old)
    if (!forceRefresh && 
        _cachedBonusSettings != null && 
        _settingsLastFetched != null &&
        DateTime.now().difference(_settingsLastFetched!).inMinutes < 5) {
      return _cachedBonusSettings!;
    }

    final client = _client;
    if (client == null) {
      debugPrint('TemporalReportService: Supabase client not ready, using defaults');
      return TemporalBonusSettings.defaults();
    }

    try {
      // Note: The database uses French key 'bonus_temporels' with French property names
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'bonus_temporels')
          .maybeSingle();

      if (response == null || response['value'] == null) {
        debugPrint('TemporalReportService: No bonus settings found (key: bonus_temporels), using defaults');
        return TemporalBonusSettings.defaults();
      }

      final value = response['value'] as Map<String, dynamic>;
      // Map French keys to English properties
      _cachedBonusSettings = TemporalBonusSettings(
        enabled: value['activé'] as bool? ?? value['enabled'] as bool? ?? true,
        yearEnabled: value['année'] as bool? ?? value['year'] as bool? ?? true,
        monthEnabled: value['mois'] as bool? ?? value['month'] as bool? ?? true,
        dayEnabled: value['jour'] as bool? ?? value['day'] as bool? ?? true,
      );
      _settingsLastFetched = DateTime.now();
      
      debugPrint('TemporalReportService: Loaded bonus settings - enabled: ${_cachedBonusSettings!.enabled}, year: ${_cachedBonusSettings!.yearEnabled}, month: ${_cachedBonusSettings!.monthEnabled}, day: ${_cachedBonusSettings!.dayEnabled}');
      
      return _cachedBonusSettings!;
    } catch (e) {
      debugPrint('TemporalReportService: Error fetching bonus settings: $e');
      return TemporalBonusSettings.defaults();
    }
  }

  /// Get all bonus reports based on current settings
  /// Only returns reports for enabled bonuses
  /// userId parameter supports custom auth systems
  Future<Map<String, TemporalReport?>> getBonusReports({DateTime? date, String? userId}) async {
    debugPrint('>>> getBonusReports called with userId: $userId, date: $date');
    final settings = await getTemporalBonusSettings();
    debugPrint('>>> getBonusReports settings - enabled: ${settings.enabled}, year: ${settings.yearEnabled}, month: ${settings.monthEnabled}, day: ${settings.dayEnabled}');
    
    if (!settings.enabled) {
      debugPrint('TemporalReportService: Bonuses are disabled');
      return {'annee': null, 'mois': null, 'jour': null};
    }

    final targetDate = date ?? DateTime.now();
    debugPrint('>>> getBonusReports targetDate: $targetDate');
    final futures = <String, Future<TemporalReport?>>{};

    if (settings.yearEnabled) {
      futures['annee'] = getYearReport(date: targetDate, userId: userId);
    }
    if (settings.monthEnabled) {
      futures['mois'] = getMonthReport(date: targetDate, userId: userId);
    }
    if (settings.dayEnabled) {
      futures['jour'] = getDayReport(date: targetDate, userId: userId);
    }

    final results = <String, TemporalReport?>{
      'annee': null,
      'mois': null,
      'jour': null,
    };

    // Fetch enabled reports in parallel
    await Future.wait(futures.entries.map((entry) async {
      results[entry.key] = await entry.value;
    }));

    return results;
  }

  /// Generate or fetch a cached report for the given period and date
  /// Calls the RPC function rpc_generer_rapport
  /// If userId is provided, it will be passed to the RPC (for custom auth systems)
  Future<TemporalReport?> generateReport({
    required String periode, // 'jour', 'mois', 'annee'
    DateTime? date,
    String? userId, // Optional: pass for custom auth systems
  }) async {
    final client = _client;
    if (client == null) {
      debugPrint('TemporalReportService: Supabase client not ready');
      return null;
    }

    try {
      final params = <String, dynamic>{
        'p_periode': periode,
      };
      
      if (date != null) {
        params['p_date'] = date.toIso8601String().split('T').first; // YYYY-MM-DD format
      }
      
      // Pass user ID for custom auth systems
      if (userId != null) {
        params['p_user_id'] = userId;
      }

      debugPrint('>>> generateReport calling RPC with params: $params');
      final response = await client.rpc('rpc_generer_rapport', params: params);
      debugPrint('>>> generateReport RPC response: $response');
      
      if (response == null) {
        debugPrint('TemporalReportService: No response from RPC');
        return null;
      }

      final report = TemporalReport.fromJson(response as Map<String, dynamic>);
      debugPrint('>>> generateReport parsed report ID: ${report.id}, periode: ${report.periode}');
      return report;
    } catch (e, stackTrace) {
      debugPrint('TemporalReportService: Error generating report: $e');
      debugPrint('TemporalReportService: Stack trace: $stackTrace');
      return null;
    }
  }

  /// Get the year report for the current year
  Future<TemporalReport?> getYearReport({DateTime? date, String? userId}) async {
    return generateReport(periode: 'annee', date: date ?? DateTime.now(), userId: userId);
  }

  /// Get the month report for the current month
  Future<TemporalReport?> getMonthReport({DateTime? date, String? userId}) async {
    return generateReport(periode: 'mois', date: date ?? DateTime.now(), userId: userId);
  }

  /// Get the day report for today
  Future<TemporalReport?> getDayReport({DateTime? date, String? userId}) async {
    return generateReport(periode: 'jour', date: date ?? DateTime.now(), userId: userId);
  }

  /// Get all three temporal reports (year, month, day) for a given date
  /// Returns a map with keys 'annee', 'mois', 'jour'
  Future<Map<String, TemporalReport?>> getAllReports({DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    
    // Fetch all three in parallel
    final results = await Future.wait([
      getYearReport(date: targetDate),
      getMonthReport(date: targetDate),
      getDayReport(date: targetDate),
    ]);

    return {
      'annee': results[0],
      'mois': results[1],
      'jour': results[2],
    };
  }

  /// Check if the user has a couple profile (required for report generation)
  Future<bool> hasCoupleProfile() async {
    final client = _client;
    if (client == null) return false;

    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await client
          .from('couple_profiles')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      debugPrint('TemporalReportService: Error checking profile: $e');
      return false;
    }
  }

  /// Create a couple profile for the current user
  /// This is required before generating reports
  /// userId parameter supports custom auth systems (like the custom users table)
  Future<bool> createCoupleProfile({
    required String userFirstname,
    required DateTime userBirthdate,
    required String userGender,
    required String partnerFirstname,
    required DateTime partnerBirthdate,
    required String partnerGender,
    String? userId, // Optional: pass for custom auth systems
  }) async {
    final client = _client;
    if (client == null) return false;

    try {
      // Use provided userId or fall back to Supabase auth
      final effectiveUserId = userId ?? client.auth.currentUser?.id;
      if (effectiveUserId == null) {
        debugPrint('TemporalReportService: No authenticated user (userId not provided and supabase.auth.currentUser is null)');
        return false;
      }
      
      debugPrint('TemporalReportService: Creating couple profile for user: $effectiveUserId');

      // Convert gender strings to enum values
      String mapGender(String gender) {
        switch (gender.toLowerCase()) {
          case 'homme':
            return 'homme';
          case 'femme':
            return 'femme';
          case 'autre':
          case 'non_binaire':
            return 'non_binaire';
          default:
            return 'non_precise';
        }
      }

      await client.from('couple_profiles').upsert({
        'user_id': effectiveUserId,
        'user_firstname': userFirstname,
        'user_birthdate': userBirthdate.toIso8601String().split('T').first,
        'user_gender': mapGender(userGender),
        'partner_firstname': partnerFirstname,
        'partner_birthdate': partnerBirthdate.toIso8601String().split('T').first,
        'partner_gender': mapGender(partnerGender),
      }, onConflict: 'user_id');

      debugPrint('TemporalReportService: Couple profile created successfully');
      return true;
    } catch (e) {
      debugPrint('TemporalReportService: Error creating profile: $e');
      return false;
    }
  }
}
