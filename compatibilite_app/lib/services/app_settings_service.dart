import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Types of primary services that can be displayed on app launch
enum PrimaryService {
  compatibilite,
  previsionJour,
  previsionMois,
  previsionAnnee,
}

/// Service to manage app-wide settings from Supabase
class AppSettingsService {
  AppSettingsService._();
  static final AppSettingsService instance = AppSettingsService._();

  PrimaryService _primaryService = PrimaryService.compatibilite;
  bool _settingsLoaded = false;

  PrimaryService get primaryService => _primaryService;
  bool get isLoaded => _settingsLoaded;

  /// Load settings from Supabase app_settings table
  Future<void> loadSettings() async {
    if (!SupabaseManager.isReady) {
      debugPrint('AppSettingsService: Supabase not ready, using defaults');
      _settingsLoaded = true;
      return;
    }

    try {
      final response = await SupabaseManager.client
          .from('app_settings')
          .select('value')
          .eq('key', 'service_principal')
          .maybeSingle();

      if (response != null && response['value'] != null) {
        final value = response['value'] as Map<String, dynamic>;
        final type = value['type'] as String?;
        
        if (type != null) {
          _primaryService = _parseServiceType(type);
          debugPrint('AppSettingsService: Primary service set to: $_primaryService');
        }
      } else {
        debugPrint('AppSettingsService: No service_principal setting found, using default');
      }
    } catch (e) {
      debugPrint('AppSettingsService: Error loading settings: $e');
    }
    
    _settingsLoaded = true;
  }

  PrimaryService _parseServiceType(String type) {
    switch (type) {
      case 'prevision_jour':
        return PrimaryService.previsionJour;
      case 'prevision_mois':
        return PrimaryService.previsionMois;
      case 'prevision_annee':
        return PrimaryService.previsionAnnee;
      case 'compatibilite':
      default:
        return PrimaryService.compatibilite;
    }
  }
}
