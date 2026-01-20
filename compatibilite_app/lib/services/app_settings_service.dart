import 'package:flutter/foundation.dart';
import '../models/report_section.dart';
import 'supabase_manager.dart';

/// Service for loading application-wide settings from Supabase
class AppSettingsService {
  static final AppSettingsService instance = AppSettingsService._();
  AppSettingsService._();

  // Cached settings
  String _primaryService = 'compatibilite';
  String _contactEmail = 'growpeak.agence@gmail.com';
  String _contactWhatsApp = '+22654255584';
  Map<String, bool> _paymentMethods = {'kkiapay': true, 'fedapay': true};
  bool _settingsLoaded = false;
  
  // Report sections cache
  List<ReportSection> _reportSections = [];
  bool _sectionsLoaded = false;

  /// Available primary service options
  static const List<String> serviceOptions = [
    'compatibilite',
    'prevision_jour',
    'prevision_mois',
    'prevision_annee',
  ];

  /// Get the primary service setting
  String get primaryService => _primaryService;

  /// Get the contact email
  String get contactEmail => _contactEmail;

  /// Get the contact WhatsApp number
  String get contactWhatsApp => _contactWhatsApp;

  /// Check if a payment method is enabled
  bool isPaymentMethodEnabled(String method) => _paymentMethods[method.toLowerCase()] ?? true;

  /// Check if settings have been loaded
  bool get isLoaded => _settingsLoaded;
  
  /// Get loaded report sections
  List<ReportSection> get reportSections => 
      _sectionsLoaded ? _reportSections : ReportSection.defaults;

  /// Fetch settings from Supabase
  Future<void> fetchSettings({bool force = false}) async {
    if (_settingsLoaded && !force) return;

    if (!SupabaseManager.isReady) {
      debugPrint('AppSettingsService: Supabase not ready, using defaults');
      _settingsLoaded = true;
      return;
    }

    try {
      final client = SupabaseManager.client;
      
      // Fetch primary service setting
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'service_principal')
          .maybeSingle();

      if (response != null && response['value'] != null) {
        final value = response['value'] as Map<String, dynamic>;
        final service = value['service'] as String?;
        if (service != null && serviceOptions.contains(service)) {
          _primaryService = service;
        }
      }

      // Fetch contact details
      final contactResponse = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'contact_details')
          .maybeSingle();

      if (contactResponse != null && contactResponse['value'] != null) {
        final value = contactResponse['value'] as Map<String, dynamic>;
        _contactEmail = value['email'] ?? 'growpeak.agence@gmail.com';
        _contactWhatsApp = value['whatsapp'] ?? '+22654255584';
      }

      // Fetch payment methods configuration
      final paymentResponse = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'modes_paiement')
          .maybeSingle();

      if (paymentResponse != null && paymentResponse['value'] != null) {
        final value = paymentResponse['value'] as Map<String, dynamic>;
        _paymentMethods = {
          'kkiapay': value['kkiapay'] ?? true,
          'fedapay': value['fedapay'] ?? true,
        };
      }

      debugPrint('AppSettingsService: Primary service = $_primaryService');
      debugPrint('AppSettingsService: Contact = $_contactEmail, WhatsApp = $_contactWhatsApp');
      _settingsLoaded = true;
      
      // Also fetch report sections
      await fetchReportSections(force: force);
    } catch (e) {
      debugPrint('AppSettingsService: Error fetching settings: $e');
      _settingsLoaded = true; // Mark as loaded even on error (use defaults)
    }
  }
  
  /// Fetch report sections from Supabase
  Future<void> fetchReportSections({bool force = false}) async {
    if (_sectionsLoaded && !force) return;
    
    if (!SupabaseManager.isReady) {
      debugPrint('AppSettingsService: Supabase not ready, using default sections');
      _reportSections = List.from(ReportSection.defaults);
      _sectionsLoaded = true;
      return;
    }
    
    try {
      final client = SupabaseManager.client;
      debugPrint('AppSettingsService: Fetching report_sections...');
      final response = await client
          .from('report_sections')
          .select('*')
          .order('display_order', ascending: true);
      
      debugPrint('AppSettingsService: Received response for report_sections');
      if (response != null && response is List && response.isNotEmpty) {
        _reportSections = response
            .map((json) => ReportSection.fromJson(json as Map<String, dynamic>))
            .toList();
        debugPrint('AppSettingsService: Loaded ${_reportSections.length} report sections');
      } else {
        _reportSections = List.from(ReportSection.defaults);
        debugPrint('AppSettingsService: No sections found in DB, using defaults');
      }
      _sectionsLoaded = true;
    } catch (e) {
      debugPrint('AppSettingsService: CRITICAL Error fetching report sections: $e');
      _reportSections = List.from(ReportSection.defaults);
      _sectionsLoaded = true;
    }
  }
  
  /// Check if a specific section is active
  bool isSectionActive(String code) {
    final section = _reportSections.firstWhere(
      (s) => s.code == code,
      orElse: () => ReportSection(
        code: code,
        labelFr: code,
        isActive: true, // Default to active if not found
        displayOrder: 99,
        periode: 'toutes',
        description: '',
      ),
    );
    return section.isActive;
  }
  
  /// Get the display label for a section
  String getSectionLabel(String code, {String fallback = ''}) {
    final section = _reportSections.firstWhere(
      (s) => s.code == code,
      orElse: () => ReportSection(
        code: code,
        labelFr: fallback,
        isActive: true,
        displayOrder: 99,
        periode: 'toutes',
        description: '',
      ),
    );
    return section.labelFr.isNotEmpty ? section.labelFr : fallback;
  }

  /// Check if the primary service is a temporal prediction
  bool get isTemporalPrimary => _primaryService.startsWith('prevision_');

  /// Get the temporal period if primary is a temporal service
  String? get temporalPeriod {
    switch (_primaryService) {
      case 'prevision_jour':
        return 'jour';
      case 'prevision_mois':
        return 'mois';
      case 'prevision_annee':
        return 'annee';
      default:
        return null;
    }
  }
}
