import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service pour gérer les crédits de décision des utilisateurs
class DecisionCreditService {
  static final DecisionCreditService _instance = DecisionCreditService._internal();
  factory DecisionCreditService() => _instance;
  DecisionCreditService._internal();

  static DecisionCreditService get instance => _instance;

  SupabaseClient get _client => Supabase.instance.client;
  String? get _currentUserId => _client.auth.currentUser?.id;

  /// Récupère le solde de crédits pour l'utilisateur connecté (simplifié)
  Future<CreditBalance> getCreditBalance() async {
    final userId = _currentUserId;
    if (userId == null) {
      return CreditBalance.unlimited(); // Grace mode si pas connecté
    }

    try {
      final response = await _client.rpc('fn_get_decision_credits', params: {
        'p_user_id': userId,
        'p_purchase_id': null, // Récupère tous les crédits
      });

      if (response != null && response is List && response.isNotEmpty) {
        final data = response[0];
        return CreditBalance(
          totalCredits: data['total_credits'] ?? 0,
          usedCredits: data['used_credits'] ?? 0,
          remainingCredits: data['remaining_credits'] ?? 0,
          isUnlimited: data['is_unlimited'] ?? false,
          expiresSoonest: data['expires_soonest'] != null
              ? DateTime.parse(data['expires_soonest'])
              : null,
        );
      }

      // Si aucun crédit trouvé, permettre l'accès en mode "grace"
      return CreditBalance.unlimited();
    } catch (e) {
      debugPrint('Erreur getCreditBalance: $e');
      // En cas d'erreur, mode gracieux
      return CreditBalance.unlimited();
    }
  }

  /// Récupère le solde de crédits disponibles pour un achat spécifique
  Future<CreditBalance> getCreditsForPurchase({
    required String userId,
    required String purchaseId,
  }) async {
    try {
      final response = await _client.rpc('fn_get_decision_credits', params: {
        'p_user_id': userId,
        'p_purchase_id': purchaseId,
      });

      if (response != null && response is List && response.isNotEmpty) {
        final data = response[0];
        return CreditBalance(
          totalCredits: data['total_credits'] ?? 0,
          usedCredits: data['used_credits'] ?? 0,
          remainingCredits: data['remaining_credits'] ?? 0,
          isUnlimited: data['is_unlimited'] ?? false,
          expiresSoonest: data['expires_soonest'] != null
              ? DateTime.parse(data['expires_soonest'])
              : null,
        );
      }

      return CreditBalance.empty();
    } catch (e) {
      debugPrint('Erreur getCreditsForPurchase: $e');
      return CreditBalance.empty();
    }
  }

  /// Vérifie si un type de décision est déjà débloqué pour un achat
  Future<bool> isDecisionTypeUnlocked({
    required String userId,
    required String purchaseId,
    required String decisionTypeId,
  }) async {
    try {
      final response = await _client
          .from('user_decision_usage')
          .select('id')
          .eq('user_id', userId)
          .eq('cycle_vie_purchase_id', purchaseId)
          .eq('decision_type_id', decisionTypeId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Erreur isDecisionTypeUnlocked: $e');
      return false;
    }
  }

  /// Consomme un crédit pour analyser un nouveau type de décision
  Future<ConsumeResult> consumeCredit({
    required String userId,
    required String purchaseId,
    required String decisionTypeId,
    required String cycleType,
    required int periodNumber,
    required DateTime targetDate,
  }) async {
    try {
      final response = await _client.rpc('fn_consume_decision_credit', params: {
        'p_user_id': userId,
        'p_purchase_id': purchaseId,
        'p_decision_type_id': decisionTypeId,
        'p_cycle_type': cycleType,
        'p_period_number': periodNumber,
        'p_target_date': targetDate.toIso8601String().split('T')[0],
      });

      if (response != null && response is Map) {
        return ConsumeResult(
          success: response['success'] ?? false,
          message: response['message'] ?? '',
          creditConsumed: response['credit_consumed'] ?? false,
        );
      }

      return ConsumeResult(
        success: false,
        message: 'Réponse invalide du serveur',
        creditConsumed: false,
      );
    } catch (e) {
      debugPrint('Erreur consumeCredit: $e');
      return ConsumeResult(
        success: false,
        message: 'Erreur: $e',
        creditConsumed: false,
      );
    }
  }

  /// Récupère l'historique des types de décision utilisés pour un achat
  Future<List<DecisionUsage>> getUsageHistory({
    String? userId,
    String? purchaseId,
    int? limit,
  }) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return [];

    try {
      var query = _client
          .from('user_decision_usage')
          .select('''
            id,
            decision_type_id,
            cycle_type,
            period_number,
            target_date,
            created_at,
            cycle_vie_decision_types(label, icon_name)
          ''')
          .eq('user_id', uid);
      
      // Filtrer par achat si fourni
      if (purchaseId != null) {
        query = query.eq('cycle_vie_purchase_id', purchaseId);
      }
      
      // Ordonner et limiter
      var orderedQuery = query.order('created_at', ascending: false);
      
      final response = limit != null 
          ? await orderedQuery.limit(limit)
          : await orderedQuery;

      return (response as List).map((item) {
        return DecisionUsage(
          id: item['id'] ?? '',
          decisionTypeId: item['decision_type_id'] ?? '',
          decisionTypeLabel: item['cycle_vie_decision_types']?['label'] ?? 'Inconnu',
          decisionTypeIcon: item['cycle_vie_decision_types']?['icon_name'],
          cycleType: item['cycle_type'] ?? '',
          periodNumber: item['period_number'] ?? 0,
          targetDate: DateTime.parse(item['target_date']),
          createdAt: DateTime.parse(item['created_at']),
        );
      }).toList();
    } catch (e) {
      debugPrint('Erreur getUsageHistory: $e');
      return [];
    }
  }

  /// Récupère les packs de crédits disponibles à l'achat
  Future<List<CreditPack>> getAvailablePacks() async {
    try {
      final response = await _client
          .from('decision_credit_packs')
          .select()
          .eq('is_active', true)
          .order('display_order');

      return (response as List).map((item) {
        return CreditPack(
          id: item['id'] ?? '',
          name: item['name'] ?? '',
          description: item['description'],
          creditsCount: item['credits_count'] ?? 0,
          priceFcfa: item['price_fcfa'] ?? 0,
          discountPercent: item['discount_percent'] ?? 0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Erreur getAvailablePacks: $e');
      return [];
    }
  }

  /// Attribue des crédits lors d'un achat de service
  Future<int> grantCreditsForPurchase({
    required String userId,
    required String purchaseId,
    required String planType,
  }) async {
    try {
      final response = await _client.rpc('fn_grant_decision_credits', params: {
        'p_user_id': userId,
        'p_purchase_id': purchaseId,
        'p_plan_type': planType,
      });

      return response ?? 0;
    } catch (e) {
      debugPrint('Erreur grantCreditsForPurchase: $e');
      return 0;
    }
  }
}

/// Modèle pour le solde de crédits
class CreditBalance {
  final int totalCredits;
  final int usedCredits;
  final int remainingCredits;
  final bool isUnlimited;
  final DateTime? expiresSoonest;

  CreditBalance({
    required this.totalCredits,
    required this.usedCredits,
    required this.remainingCredits,
    required this.isUnlimited,
    this.expiresSoonest,
  });

  factory CreditBalance.empty() => CreditBalance(
    totalCredits: 0,
    usedCredits: 0,
    remainingCredits: 0,
    isUnlimited: false,
  );

  /// Crédits illimités (mode gracieux ou abonnement premium)
  factory CreditBalance.unlimited() => CreditBalance(
    totalCredits: -1,
    usedCredits: 0,
    remainingCredits: -1,
    isUnlimited: true,
  );

  bool get hasCredits => isUnlimited || remainingCredits > 0;

  int? get daysUntilExpiry {
    if (expiresSoonest == null) return null;
    return expiresSoonest!.difference(DateTime.now()).inDays;
  }
}

/// Modèle pour le résultat de consommation de crédit
class ConsumeResult {
  final bool success;
  final String message;
  final bool creditConsumed;
  final CreditBalance? balance;

  ConsumeResult({
    required this.success,
    required this.message,
    required this.creditConsumed,
    this.balance,
  });
}

/// Modèle pour l'historique d'utilisation
class DecisionUsage {
  final String id;
  final String decisionTypeId;
  final String decisionTypeLabel;
  final String? decisionTypeIcon;
  final String cycleType;
  final int periodNumber;
  final DateTime targetDate;
  final DateTime createdAt;

  DecisionUsage({
    required this.id,
    required this.decisionTypeId,
    required this.decisionTypeLabel,
    this.decisionTypeIcon,
    required this.cycleType,
    required this.periodNumber,
    required this.targetDate,
    required this.createdAt,
  });
}

/// Modèle pour les packs de crédits
class CreditPack {
  final String id;
  final String name;
  final String? description;
  final int creditsCount;
  final int priceFcfa;
  final int discountPercent;

  CreditPack({
    required this.id,
    required this.name,
    this.description,
    required this.creditsCount,
    required this.priceFcfa,
    required this.discountPercent,
  });

  /// Prix par crédit
  int get pricePerCredit => (priceFcfa / creditsCount).round();
}
