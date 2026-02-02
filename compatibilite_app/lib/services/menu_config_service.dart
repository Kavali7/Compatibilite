import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Configuration for a single menu item
class MenuItemConfig {
  final String id;
  final String label;
  final bool enabled;
  final int order;

  const MenuItemConfig({
    required this.id,
    required this.label,
    this.enabled = true,
    this.order = 0,
  });

  factory MenuItemConfig.fromJson(String id, Map<String, dynamic> json) {
    return MenuItemConfig(
      id: id,
      label: json['label'] as String? ?? id,
      enabled: json['enabled'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
    );
  }
}

/// Service to manage menu visibility configuration from admin panel
class MenuConfigService {
  MenuConfigService._();
  static final MenuConfigService instance = MenuConfigService._();

  Map<String, MenuItemConfig>? _cachedConfig;
  DateTime? _lastFetched;

  /// Default menu configuration
  static const Map<String, Map<String, dynamic>> _defaultConfig = {
    'mes_achats': {'label': 'Mes achats', 'enabled': true, 'order': 1},
    'se_connecter': {'label': 'Se connecter', 'enabled': true, 'order': 2},
    'creer_compte': {'label': 'Créer un compte', 'enabled': true, 'order': 3},
    'se_deconnecter': {'label': 'Se déconnecter', 'enabled': true, 'order': 4},
    'contacter': {'label': 'Contacter Growpeak Agence', 'enabled': true, 'order': 5},
    'whatsapp': {'label': 'WhatsApp Growpeak Agence', 'enabled': true, 'order': 6},
    'appeler': {'label': 'Appeler Growpeak Agence', 'enabled': true, 'order': 7},
    'previsions_temporelles': {'label': 'Prévisions Temporelles', 'enabled': true, 'order': 8},
    'compatibilite': {'label': 'Test de Compatibilité', 'enabled': true, 'order': 9},
    'cycles_vie': {'label': 'Cycles de Vie', 'enabled': true, 'order': 10},
    'portrait_ame': {'label': 'Portrait de l\'Âme', 'enabled': true, 'order': 11},
    'cycle_personnel': {'label': 'Cycle Personnel', 'enabled': true, 'order': 12},
    'cycle_business': {'label': 'Cycle Business', 'enabled': true, 'order': 13},
    'sante': {'label': 'Cycle Santé', 'enabled': true, 'order': 14},
    'guide_horaire': {'label': 'Guide Horaire', 'enabled': true, 'order': 15},
    'eclairage_decision': {'label': 'Éclairage Décision', 'enabled': true, 'order': 16},
    'phases_vie': {'label': 'Phases de Vie', 'enabled': true, 'order': 17},
    'timing_lunaire': {'label': 'Timing Lunaire', 'enabled': true, 'order': 18},
  };

  /// Load menu configuration from app_settings
  Future<Map<String, MenuItemConfig>> getMenuConfig({bool forceRefresh = false}) async {
    // Return cached config if fresh (less than 5 minutes)
    if (!forceRefresh &&
        _cachedConfig != null &&
        _lastFetched != null &&
        DateTime.now().difference(_lastFetched!).inMinutes < 5) {
      return _cachedConfig!;
    }

    final client = SupabaseManager.isReady ? SupabaseManager.client : null;
    if (client == null) {
      debugPrint('MenuConfigService: Supabase not ready, using defaults');
      return _getDefaultConfig();
    }

    try {
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'menu_config')
          .maybeSingle();

      if (response == null || response['value'] == null) {
        debugPrint('MenuConfigService: No config found, using defaults');
        return _getDefaultConfig();
      }

      final value = response['value'] as Map<String, dynamic>;
      _cachedConfig = {};
      
      value.forEach((key, data) {
        if (data is Map<String, dynamic>) {
          _cachedConfig![key] = MenuItemConfig.fromJson(key, data);
        }
      });

      // Merge with defaults for any missing items
      _defaultConfig.forEach((key, defaultData) {
        if (!_cachedConfig!.containsKey(key)) {
          _cachedConfig![key] = MenuItemConfig.fromJson(key, defaultData);
        }
      });

      _lastFetched = DateTime.now();
      debugPrint('MenuConfigService: Loaded ${_cachedConfig!.length} menu items');
      return _cachedConfig!;
    } catch (e) {
      debugPrint('MenuConfigService: Error loading config: $e');
      return _getDefaultConfig();
    }
  }

  Map<String, MenuItemConfig> _getDefaultConfig() {
    _cachedConfig = {};
    _defaultConfig.forEach((key, data) {
      _cachedConfig![key] = MenuItemConfig.fromJson(key, data);
    });
    _lastFetched = DateTime.now();
    return _cachedConfig!;
  }

  /// Check if a specific menu item is enabled
  Future<bool> isMenuEnabled(String menuId) async {
    final config = await getMenuConfig();
    return config[menuId]?.enabled ?? true;
  }

  /// Get a specific menu item's label (allows admin to customize labels)
  Future<String?> getMenuLabel(String menuId) async {
    final config = await getMenuConfig();
    return config[menuId]?.label;
  }

  /// Clear cache to force refresh on next call
  void clearCache() {
    _cachedConfig = null;
    _lastFetched = null;
  }
}
