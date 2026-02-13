import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Configuration model for a social proof entry
class SocialProofEntry {
  final String id;
  final String proofType;    // 'toast', 'badge', 'testimonial'
  final String targetScreen; // 'wizard', 'catalog', 'welcome'
  final bool enabled;
  final int displayOrder;
  final String region;       // 'all', 'africa', 'europe'
  final String? serviceKey;  // optional: links badge to a specific service

  // Toast fields
  final List<String> firstNames;
  final List<String> lastInitials;
  final List<String> messageTemplates;
  final List<String> timeLabels;
  final int showDurationMs;
  final int pauseMinMs;
  final int pauseMaxMs;

  // Badge fields
  final String? badgeText;
  final int? badgeCounter;
  final String? badgeCounterLabel;

  // Testimonial fields
  final String? testimonialName;
  final String? testimonialText;
  final int? testimonialRating;
  final String? testimonialPhotoUrl;

  SocialProofEntry({
    required this.id,
    required this.proofType,
    required this.targetScreen,
    required this.enabled,
    required this.displayOrder,
    required this.region,
    this.firstNames = const [],
    this.lastInitials = const [],
    this.messageTemplates = const [],
    this.timeLabels = const [],
    this.showDurationMs = 4000,
    this.pauseMinMs = 6000,
    this.pauseMaxMs = 12000,
    this.badgeText,
    this.badgeCounter,
    this.badgeCounterLabel,
    this.testimonialName,
    this.testimonialText,
    this.testimonialRating,
    this.testimonialPhotoUrl,
    this.serviceKey,
  });

  factory SocialProofEntry.fromJson(Map<String, dynamic> json) {
    return SocialProofEntry(
      id: json['id'] as String,
      proofType: json['proof_type'] as String,
      targetScreen: json['target_screen'] as String,
      enabled: json['enabled'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      region: json['region'] as String? ?? 'all',
      firstNames: _toStringList(json['first_names']),
      lastInitials: _toStringList(json['last_initials']),
      messageTemplates: _toStringList(json['message_templates']),
      timeLabels: _toStringList(json['time_labels']),
      showDurationMs: json['show_duration_ms'] as int? ?? 4000,
      pauseMinMs: json['pause_min_ms'] as int? ?? 6000,
      pauseMaxMs: json['pause_max_ms'] as int? ?? 12000,
      badgeText: json['badge_text'] as String?,
      badgeCounter: json['badge_counter'] as int?,
      badgeCounterLabel: json['badge_counter_label'] as String?,
      testimonialName: json['testimonial_name'] as String?,
      testimonialText: json['testimonial_text'] as String?,
      testimonialRating: json['testimonial_rating'] as int?,
      testimonialPhotoUrl: json['testimonial_photo_url'] as String?,
      serviceKey: json['service_key'] as String?,
    );
  }

  static List<String> _toStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.cast<String>();
    return [];
  }
}

/// Service singleton that loads social proof config from Supabase with caching.
class SocialProofService {
  SocialProofService._();
  static final SocialProofService instance = SocialProofService._();

  List<SocialProofEntry> _entries = [];
  DateTime? _lastFetch;
  bool _isLoading = false;
  static const Duration _cacheExpiry = Duration(minutes: 30);

  /// Detect user region based on device locale
  String get _detectedRegion {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      final country = locale.countryCode?.toUpperCase() ?? '';
      
      // African country codes
      const africanCountries = {
        'BJ', 'BF', 'CI', 'GH', 'GN', 'ML', 'NE', 'NG', 'SN', 'TG',
        'CM', 'TD', 'CF', 'CG', 'CD', 'GA', 'GQ', 'KE', 'TZ', 'UG',
        'RW', 'BI', 'ET', 'MG', 'MZ', 'ZA', 'MA', 'DZ', 'TN', 'EG',
        'LY', 'SD', 'SS', 'SO', 'DJ', 'ER', 'MW', 'ZM', 'ZW', 'BW',
        'NA', 'SZ', 'LS', 'MR', 'SL', 'LR', 'GM', 'GW', 'CV', 'ST',
      };
      
      if (africanCountries.contains(country)) return 'africa';
      return 'europe'; // Default to Europe for non-African countries
    } catch (_) {
      return 'all';
    }
  }

  /// Load all entries from Supabase (with cache)
  Future<void> fetchEntries() async {
    if (_entries.isNotEmpty &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < _cacheExpiry) {
      return;
    }

    if (_isLoading) return;
    _isLoading = true;

    try {
      final response = await SupabaseManager.client
          .from('social_proof_config')
          .select()
          .eq('enabled', true)
          .order('display_order', ascending: true);

      if (response is List && response.isNotEmpty) {
        _entries = response
            .map((item) => SocialProofEntry.fromJson(item as Map<String, dynamic>))
            .toList();
        _lastFetch = DateTime.now();
        debugPrint('SocialProofService: Loaded ${_entries.length} entries');
      }
    } catch (e) {
      debugPrint('SocialProofService: Error loading: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Force refresh
  Future<void> refresh() async {
    _entries = [];
    _lastFetch = null;
    await fetchEntries();
  }

  /// Filter entries by type, screen, and region
  List<SocialProofEntry> _filtered(String proofType, String targetScreen) {
    final region = _detectedRegion;
    return _entries.where((e) =>
        e.proofType == proofType &&
        e.targetScreen == targetScreen &&
        (e.region == 'all' || e.region == region)
    ).toList();
  }

  /// Get toast config for the wizard (merges names from all matching entries)
  SocialProofEntry? get toastConfig {
    final toasts = _filtered('toast', 'wizard');
    if (toasts.isEmpty) return null;
    
    // If single entry, return it directly
    if (toasts.length == 1) return toasts.first;
    
    // Merge multiple toast configs (e.g. region 'all' + region-specific)
    final allNames = <String>[];
    final allInitials = <String>[];
    final allTemplates = <String>[];
    final allTimeLabels = <String>[];
    
    for (final t in toasts) {
      allNames.addAll(t.firstNames);
      allInitials.addAll(t.lastInitials);
      allTemplates.addAll(t.messageTemplates);
      allTimeLabels.addAll(t.timeLabels);
    }
    
    return SocialProofEntry(
      id: toasts.first.id,
      proofType: 'toast',
      targetScreen: 'wizard',
      enabled: true,
      displayOrder: 0,
      region: 'all',
      firstNames: allNames.toSet().toList(),
      lastInitials: allInitials.toSet().toList(),
      messageTemplates: allTemplates.toSet().toList(),
      timeLabels: allTimeLabels.toSet().toList(),
      showDurationMs: toasts.first.showDurationMs,
      pauseMinMs: toasts.first.pauseMinMs,
      pauseMaxMs: toasts.first.pauseMaxMs,
    );
  }

  /// Get badge configs for the catalog  
  List<SocialProofEntry> get badgeConfigs => _filtered('badge', 'catalog');

  /// Get badge for a specific service (by service_key)
  SocialProofEntry? badgeForService(String serviceId) {
    final badges = badgeConfigs;
    try {
      return badges.firstWhere((b) => b.serviceKey == serviceId);
    } catch (_) {
      return null;
    }
  }

  /// Sum all per-service badge counters for the total banner
  int get totalBadgeCounter {
    int total = 0;
    for (final b in badgeConfigs) {
      if (b.serviceKey != null && b.badgeCounter != null) {
        total += b.badgeCounter!;
      }
    }
    return total;
  }

  /// Get the global badge (no service_key) or build one from totals
  SocialProofEntry? get globalBadge {
    final badges = badgeConfigs;
    // First try to find a badge without service_key (global badge)
    try {
      return badges.firstWhere((b) => b.serviceKey == null || b.serviceKey!.isEmpty);
    } catch (_) {
      return null;
    }
  }

  /// Get testimonials for the welcome screen
  List<SocialProofEntry> get testimonialConfigs => _filtered('testimonial', 'welcome');

  /// Generate a random toast message from the config
  String? generateToastMessage() {
    final config = toastConfig;
    if (config == null || config.firstNames.isEmpty || config.messageTemplates.isEmpty) {
      return null;
    }

    final random = Random();
    final name = '${config.firstNames[random.nextInt(config.firstNames.length)]} '
        '${config.lastInitials.isNotEmpty ? config.lastInitials[random.nextInt(config.lastInitials.length)] : ''}';
    final template = config.messageTemplates[random.nextInt(config.messageTemplates.length)];
    final time = config.timeLabels.isNotEmpty
        ? config.timeLabels[random.nextInt(config.timeLabels.length)]
        : 'il y a quelques minutes';
    return '${template.replaceAll('{name}', name.trim())}, $time';
  }
}
