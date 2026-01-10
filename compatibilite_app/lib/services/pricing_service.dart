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
    this.description,
    this.durationDays,
    this.isActive = true,
  });

  final String id;
  final String planType; // 'consultation' or 'subscription'
  final String name;
  final String? description;
  final int priceFcfa;
  final int? durationDays;
  final bool isActive;

  factory PricingPlan.fromJson(Map<String, dynamic> json) {
    return PricingPlan(
      id: json['id'] as String,
      planType: json['plan_type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      priceFcfa: json['price_fcfa'] as int,
      durationDays: json['duration_days'] as int?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_type': planType,
        'name': name,
        'description': description,
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

  /// Default plans - fallback ONLY if Supabase fails
  /// Real prices come from the database (pricing_plans table)
  static final List<PricingPlan> defaultPlans = [
    PricingPlan(
      id: 'default-consultation',
      planType: 'consultation',
      name: 'Rapport de base compatibilité',
      priceFcfa: 700, // Test price - real price comes from Supabase
    ),
    PricingPlan(
      id: 'default-subscription',
      planType: 'subscription',
      name: 'Abonnement mensuel',
      priceFcfa: 15000, // Test price - real price comes from Supabase
      durationDays: 30,
    ),
  ];

  /// Get the consultation plan
  /// Throws if plans not loaded
  PricingPlan get consultationPlan {
    if (_cachedPlans.isEmpty) {
      throw Exception('Les plans de tarification n\'ont pas été chargés. Veuillez vérifier votre connexion.');
    }
    return _cachedPlans.firstWhere(
      (p) => p.isConsultation && p.isActive,
      orElse: () => throw Exception('Aucun plan consultation actif trouvé'),
    );
  }

  /// Get the subscription plan
  /// Throws if plans not loaded
  PricingPlan get subscriptionPlan {
    if (_cachedPlans.isEmpty) {
      throw Exception('Les plans de tarification n\'ont pas été chargés. Veuillez vérifier votre connexion.');
    }
    return _cachedPlans.firstWhere(
      (p) => p.isSubscription && p.isActive,
      orElse: () => throw Exception('Aucun plan abonnement actif trouvé'),
    );
  }
  
  /// Check if plans are loaded
  bool get hasPlans => _cachedPlans.isNotEmpty;
  
  /// Last error message (if any)
  String? _lastError;
  String? get lastError => _lastError;

  /// Fetch all pricing plans from Supabase
  /// Throws exception if Supabase is not available or fails
  Future<List<PricingPlan>> fetchPlans() async {
    _lastError = null;
    
    if (_client == null) {
      _lastError = 'Connexion au serveur impossible. Veuillez vérifier votre connexion internet.';
      debugPrint('PricingService: Supabase not initialized');
      throw Exception(_lastError);
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
        _lastError = 'Aucun plan de tarification n\'est configuré. Contactez le support.';
        debugPrint('PricingService: No active plans found');
        throw Exception(_lastError);
      }

      debugPrint('PricingService: Loaded ${_cachedPlans.length} plans');
      return _cachedPlans;
    } catch (e) {
      _lastError = 'Erreur de chargement des tarifs: ${e.toString()}';
      debugPrint('PricingService fetchPlans error: $e');
      rethrow;
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
