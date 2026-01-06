import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Service for loading application-wide settings from Supabase
class AppSettingsService {
  static final AppSettingsService instance = AppSettingsService._();
  AppSettingsService._();

  // Cached settings
  String _primaryService = 'compatibilite';
  bool _settingsLoaded = false;

  /// Available primary service options
  static const List<String> serviceOptions = [
    'compatibilite',
    'prevision_jour',
    'prevision_mois',
    'prevision_annee',
  ];

  /// Get the primary service setting
  String get primaryService => _primaryService;

  /// Check if settings have been loaded
  bool get isLoaded => _settingsLoaded;

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

      debugPrint('AppSettingsService: Primary service = $_primaryService');
      _settingsLoaded = true;
    } catch (e) {
      debugPrint('AppSettingsService: Error fetching settings: $e');
      _settingsLoaded = true; // Mark as loaded even on error (use defaults)
    }
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
