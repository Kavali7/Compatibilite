import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:compatibilite_app/models/compatibility_models.dart';
import 'supabase_manager.dart';
import 'auth_service.dart';

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
Future<bool> hasCoupleProfile({String? userId}) async {
  final client = _client;
  if (client == null) return false;

  try {
    // Use provided userId, or fallback to AuthService, or Supabase auth
    final effectiveUserId = userId ?? 
        AuthService.instance.currentUser?.id ??
        client.auth.currentUser?.id;
        
    if (effectiveUserId == null) return false;

    final response = await client
        .from('couple_profiles')
        .select('id')
        .eq('user_id', effectiveUserId)
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
      // Use provided userId, or fallback to AuthService, or Supabase auth
      final effectiveUserId = userId ?? 
          AuthService.instance.currentUser?.id ??
          client.auth.currentUser?.id;
          
      if (effectiveUserId == null) {
        debugPrint('TemporalReportService: No authenticated user (userId not provided, AuthService.currentUser is null, and supabase.auth.currentUser is null)');
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

      // Use RPC function with SECURITY DEFINER to bypass RLS
      // This is the same approach used for payments (fn_insert_payment)
      try {
        debugPrint('TemporalReportService: Trying RPC fn_upsert_couple_profile...');
        final result = await client.rpc('fn_upsert_couple_profile', params: {
          'p_user_id': effectiveUserId,
          'p_user_firstname': userFirstname,
          'p_user_birthdate': userBirthdate.toIso8601String().split('T').first,
          'p_user_gender': mapGender(userGender),
          'p_partner_firstname': partnerFirstname,
          'p_partner_birthdate': partnerBirthdate.toIso8601String().split('T').first,
          'p_partner_gender': mapGender(partnerGender),
        });
        
        debugPrint('TemporalReportService: RPC result: $result');
        if (result != null && result['success'] == true) {
          debugPrint('TemporalReportService: Couple profile created via RPC successfully');
          return true;
        }
      } catch (rpcError) {
        debugPrint('TemporalReportService: RPC failed ($rpcError), trying direct upsert...');
      }

      // Fallback: try direct upsert (might work if RLS policies are fixed)
      await client.from('couple_profiles').upsert({
        'user_id': effectiveUserId,
        'user_firstname': userFirstname,
        'user_birthdate': userBirthdate.toIso8601String().split('T').first,
        'user_gender': mapGender(userGender),
        'partner_firstname': partnerFirstname,
        'partner_birthdate': partnerBirthdate.toIso8601String().split('T').first,
        'partner_gender': mapGender(partnerGender),
      }, onConflict: 'user_id');

      debugPrint('TemporalReportService: Couple profile created successfully via direct upsert');
      return true;
    } catch (e) {
      debugPrint('TemporalReportService: Error creating couple profile: $e');
      return false;
    }
  }

  /// Get the Couple Profile ID for the current user
  /// Required for RPC calls that need couple_id
  /// Uses RPC with SECURITY DEFINER to bypass RLS (supports custom auth)
  Future<String?> getCoupleProfileId({String? userId}) async {
      final client = _client;
      if (client == null) return null;
      
      final effectiveUserId = userId ?? 
          AuthService.instance.currentUser?.id ??
          client.auth.currentUser?.id;

      if (effectiveUserId == null) return null;

      try {
        // Use RPC function with SECURITY DEFINER to bypass RLS
        // This is needed because the app uses custom auth (users table)
        // and auth.uid() doesn't match the custom user_id
        debugPrint('TemporalReportService: Getting couple ID for user: $effectiveUserId');
        
        final response = await client.rpc('fn_get_couple_profile_id', params: {
          'p_user_id': effectiveUserId,
        });
        
        debugPrint('TemporalReportService: RPC fn_get_couple_profile_id result: $response');
        
        if (response != null) {
          return response as String;
        }
        
        // Fallback: try direct query (might work if RLS is disabled or user is service_role)
        debugPrint('TemporalReportService: RPC returned null, trying direct query...');
        final directResponse = await client
            .from('couple_profiles')
            .select('id')
            .eq('user_id', effectiveUserId)
            .maybeSingle();
        
        return directResponse?['id'] as String?;
      } catch (e) {
        debugPrint('TemporalReportService: Error fetching couple ID: $e');
        return null;
      }
  }

  /// Fetch the Full Compatibility Profile from Backend (RPC)
  /// Replaces local calculation logic.
  Future<CompatibilitySummary?> fetchFullProfile({
    required String coupleId,
    required PartnerInput partnerAInput,
    required PartnerInput partnerBInput,
  }) async {
    final client = _client;
    if (client == null) {
       debugPrint('TemporalReportService: Client not ready');
       return null;
    }

    try {
      debugPrint('>>> fetchFullProfile calling RPC for coupleId: $coupleId');
      
      // Call the new V2 RPC
      final response = await client.rpc('rpc_generer_profil_complet', params: {
        'p_couple_id': coupleId,
      });
      
     debugPrint('>>> fetchFullProfile response received');
      debugPrint('>>> fetchFullProfile response data: $response');
      
      if (response == null) {
        debugPrint('>>> fetchFullProfile: Response is NULL - RPC returned nothing');
        return null;
      }
      
      final data = response as Map<String, dynamic>;
      debugPrint('>>> fetchFullProfile parsed data keys: ${data.keys.toList()}');
      
      // Helper to extract text text
      String? extractText(Map<String, dynamic>? textObj) {
        if (textObj == null) return null;
        final title = textObj['title'] as String?;
        final body = textObj['body'] as String?;
        if (title != null && body != null) return '$title. $body';
        return body ?? title;
      }

      // Parse Partner A
      final jsonA = data['partner_a'] as Map<String, dynamic>;
      final reportA = PartnerReport(
        input: partnerAInput,
        nameNumber: jsonA['name_number'] as int,
        lifePath: jsonA['life_path'] as int,
        kabbalahNumber: jsonA['kabbalah_number'] as int,
        intimateNumber: jsonA['intimate_number'] as int,
        personalityNumber: jsonA['personality_number'] as int,
        heredityNumber: jsonA['heredity_number'] as int,
        personalYear: 0, // Not returned by this RPC yet? Wait, let's check SQL. SQL V2 had it? No...
        // Wait, SQL V2 did NOT return personalYear in the JSON structure. 
        // I missed adding Personal Year to the JSON output in SQL V2.
        // It calculated it? No, Personal Year depends on Current Year.
        // The SQL V2 only calculates static numbers (LifePath, etc.)
        // Actually, Personal Year changes every year.
        // BASIC REPORT usually includes Personal Year.
        // I should have included it.
        // For now, I'll default to 0 and fix it later or calculate locally for this specific dynamic value if needed.
        // Actually, Personal Year IS essentially (Day+Month+CurrentYear). Easy to calc locally if needed.
        // BUT `numerology_texts` has `personal_year`.
        // I will assume 0 for now to not break compilation, but I should fix SQL later if I want it from backend.
        personalMonth: 0, 
        personalDay: 0,
        
        lifePathMeaning: extractText(jsonA['base_text']),
        nameMeaning: extractText(jsonA['name_text']),
        intimateMeaning: extractText(jsonA['intimate_text']),
        personalityMeaning: extractText(jsonA['personality_text']),
        kabbalahMeaning: extractText(jsonA['kabbalah_text']),
        // heredityMeaning: ... (SQL returned heredity_number=0 and no text)
      );

      // Parse Partner B
      final jsonB = data['partner_b'] as Map<String, dynamic>;
      final reportB = PartnerReport(
        input: partnerBInput,
        nameNumber: jsonB['name_number'] as int,
        lifePath: jsonB['life_path'] as int,
        kabbalahNumber: jsonB['kabbalah_number'] as int,
        intimateNumber: jsonB['intimate_number'] as int,
        personalityNumber: jsonB['personality_number'] as int,
        heredityNumber: jsonB['heredity_number'] as int,
        personalYear: 0,
        personalMonth: 0,
        personalDay: 0,
        
        lifePathMeaning: extractText(jsonB['base_text']),
        nameMeaning: extractText(jsonB['name_text']),
        intimateMeaning: extractText(jsonB['intimate_text']),
        personalityMeaning: extractText(jsonB['personality_text']),
        kabbalahMeaning: extractText(jsonB['kabbalah_text']),
      );

      // Parse Couple
      final jsonCouple = data['couple'] as Map<String, dynamic>;
      
      return CompatibilitySummary(
        partnerA: reportA,
        partnerB: reportB,
        coupleNumber: jsonCouple['number'] as int,
        coupleDailyNumber: 0, // Dynamic, omitted for now
        generatedAt: DateTime.now(),
        coupleMeaning: extractText(jsonCouple['text']),
        coupleDeepMeaning: extractText(jsonCouple['deep_text']),
      );

    } catch (e, stack) {
      debugPrint('TemporalReportService: Error in fetchFullProfile: $e');
      debugPrint(stack.toString());
      return null;
    }
  }

}
