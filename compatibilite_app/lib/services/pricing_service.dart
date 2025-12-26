import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_manager.dart';

/// Represents a pricing plan
class PricingPlan {
  PricingPlan({
    required this.id,
    required this.planType,
    required this.name,
    required this.priceFcfa,
    this.durationDays,
    this.isActive = true,
  });

  final String id;
  final String planType; // 'consultation' or 'subscription'
  final String name;
  final int priceFcfa;
  final int? durationDays;
  final bool isActive;

  factory PricingPlan.fromJson(Map<String, dynamic> json) {
    return PricingPlan(
      id: json['id'] as String,
      planType: json['plan_type'] as String,
      name: json['name'] as String,
      priceFcfa: json['price_fcfa'] as int,
      durationDays: json['duration_days'] as int?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_type': planType,
        'name': name,
        'price_fcfa': priceFcfa,
        'duration_days': durationDays,
        'is_active': isActive,
      };

  bool get isConsultation => planType == 'consultation';
  bool get isSubscription => planType == 'subscription';
}

/// Service to manage pricing plans
class PricingService {
  PricingService._();
  static final PricingService instance = PricingService._();

  static const _tablePricingPlans = 'pricing_plans';

  SupabaseClient? get _client =>
      SupabaseManager.isReady ? SupabaseManager.client : null;

  List<PricingPlan> _cachedPlans = [];
  List<PricingPlan> get plans => _cachedPlans;

  /// Default plans - NO HARDCODED PRICES
  /// Prices must come from Supabase database
  static final List<PricingPlan> defaultPlans = [];

  /// Get the consultation plan
  PricingPlan get consultationPlan {
    return _cachedPlans.firstWhere(
      (p) => p.isConsultation && p.isActive,
      orElse: () => defaultPlans.first,
    );
  }

  /// Get the subscription plan
  PricingPlan get subscriptionPlan {
    return _cachedPlans.firstWhere(
      (p) => p.isSubscription && p.isActive,
      orElse: () => defaultPlans.last,
    );
  }

  /// Fetch all pricing plans from Supabase
  Future<List<PricingPlan>> fetchPlans() async {
    if (_client == null) {
      debugPrint('PricingService: Supabase not initialized, using defaults');
      _cachedPlans = defaultPlans;
      return _cachedPlans;
    }

    try {
      final result = await _client!
          .from(_tablePricingPlans)
          .select()
          .eq('is_active', true)
          .order('plan_type');

      _cachedPlans = (result as List)
          .map((json) => PricingPlan.fromJson(json))
          .toList();

      if (_cachedPlans.isEmpty) {
        _cachedPlans = defaultPlans;
      }

      return _cachedPlans;
    } catch (e) {
      debugPrint('PricingService fetchPlans error: $e');
      _cachedPlans = defaultPlans;
      return _cachedPlans;
    }
  }

  /// Update a pricing plan (admin only)
  Future<void> updatePlan({
    required String planId,
    String? name,
    int? priceFcfa,
    int? durationDays,
    bool? isActive,
  }) async {
    if (_client == null) {
      throw Exception('Supabase non initialisé');
    }

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (priceFcfa != null) updates['price_fcfa'] = priceFcfa;
    if (durationDays != null) updates['duration_days'] = durationDays;
    if (isActive != null) updates['is_active'] = isActive;

    if (updates.isEmpty) return;

    try {
      await _client!
          .from(_tablePricingPlans)
          .update(updates)
          .eq('id', planId);
      
      // Refresh cache
      await fetchPlans();
    } catch (e) {
      debugPrint('PricingService updatePlan error: $e');
      rethrow;
    }
  }

  /// Create a new pricing plan (admin only)
  Future<PricingPlan> createPlan({
    required String planType,
    required String name,
    required int priceFcfa,
    int? durationDays,
  }) async {
    if (_client == null) {
      throw Exception('Supabase non initialisé');
    }

    try {
      final result = await _client!.from(_tablePricingPlans).insert({
        'plan_type': planType,
        'name': name,
        'price_fcfa': priceFcfa,
        'duration_days': durationDays,
        'is_active': true,
      }).select().single();

      final plan = PricingPlan.fromJson(result);
      await fetchPlans();
      return plan;
    } catch (e) {
      debugPrint('PricingService createPlan error: $e');
      rethrow;
    }
  }
}
