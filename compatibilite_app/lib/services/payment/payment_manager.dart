/// Payment Manager - Orchestrates payment providers
library;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../supabase_manager.dart';
import 'payment_gateway.dart';
import 'kkiapay_gateway.dart';

/// Payment Manager - Central orchestrator for all payment providers
class PaymentManager {
  PaymentManager._();
  static final PaymentManager instance = PaymentManager._();
  
  /// List of available payment gateways
  List<PaymentGateway> get availableGateways {
    final gateways = <PaymentGateway>[];
    
    // Add Kkiapay if configured
    if (KkiapayGateway.instance.isConfigured) {
      gateways.add(KkiapayGateway.instance);
    }
    
    // FedaPay will be added here when implemented
    // if (FedapayGateway.instance.isConfigured) {
    //   gateways.add(FedapayGateway.instance);
    // }
    
    return gateways;
  }
  
  /// Get a specific gateway by name
  PaymentGateway? getGateway(String providerName) {
    try {
      return availableGateways.firstWhere((g) => g.providerName == providerName);
    } catch (_) {
      return null;
    }
  }
  
  /// Process a purchase with the selected payment provider
  Future<Purchase?> processPurchase({
    required BuildContext context,
    required String userId,
    required Product product,
    required PaymentProvider provider,
    required String customerEmail,
    String? customerPhone,
    String? customerName,
    DateTime? periodDate,
  }) async {
    final gateway = getGateway(provider.value);
    if (gateway == null) {
      debugPrint('PaymentManager: Gateway ${provider.value} not available');
      return null;
    }
    
    Purchase? completedPurchase;
    
    await gateway.initiatePayment(
      context: context,
      amountFcfa: product.priceFcfa,
      reason: product.name,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      customerName: customerName,
      callback: (result) async {
        if (result.success && result.transactionId != null) {
          // Record the purchase
          completedPurchase = await _recordPurchase(
            userId: userId,
            product: product,
            provider: provider,
            transactionId: result.transactionId!,
            periodDate: periodDate,
          );
        }
      },
    );
    
    return completedPurchase;
  }
  
  /// Process purchase with callback (for async UI updates)
  void processPurchaseWithCallback({
    required BuildContext context,
    required String userId,
    required Product product,
    required PaymentProvider provider,
    required String customerEmail,
    String? customerPhone,
    String? customerName,
    DateTime? periodDate,
    required void Function(bool success, Purchase? purchase, String? error) callback,
  }) {
    final gateway = getGateway(provider.value);
    if (gateway == null) {
      callback(false, null, 'Moyen de paiement non disponible');
      return;
    }
    
    gateway.initiatePayment(
      context: context,
      amountFcfa: product.priceFcfa,
      reason: product.name,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      customerName: customerName,
      callback: (result) async {
        if (result.success && result.transactionId != null) {
          try {
            final purchase = await _recordPurchase(
              userId: userId,
              product: product,
              provider: provider,
              transactionId: result.transactionId!,
              periodDate: periodDate,
            );
            callback(true, purchase, null);
          } catch (e) {
            debugPrint('PaymentManager: Error recording purchase: $e');
            // Payment succeeded but record failed - still return success
            // but with a warning
            callback(true, null, 'Paiement réussi mais erreur d\'enregistrement');
          }
        } else {
          callback(false, null, result.errorMessage ?? 'Paiement échoué');
        }
      },
    );
  }
  
  /// Record a purchase in the database
  Future<Purchase?> _recordPurchase({
    required String userId,
    required Product product,
    required PaymentProvider provider,
    required String transactionId,
    DateTime? periodDate,
  }) async {
    if (!SupabaseManager.isReady) {
      debugPrint('PaymentManager: Supabase not ready');
      return null;
    }
    
    try {
      final purchase = Purchase(
        id: const Uuid().v4(),
        userId: userId,
        productType: product.type,
        periodDate: periodDate ?? (product.type.isTemporal ? DateTime.now() : null),
        provider: provider,
        transactionId: transactionId,
        amountFcfa: product.priceFcfa,
        status: PurchaseStatus.success,
        createdAt: DateTime.now(),
      );
      
      final client = Supabase.instance.client;
      await client
          .from('purchases')
          .insert(purchase.toInsertJson());
      
      debugPrint('PaymentManager: Purchase recorded: ${purchase.id}');
      return purchase;
    } catch (e) {
      debugPrint('PaymentManager: Error recording purchase: $e');
      return null;
    }
  }
  
  /// Get user's purchase history
  Future<List<Purchase>> getUserPurchases(String userId) async {
    if (!SupabaseManager.isReady) {
      return [];
    }
    
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('purchases')
          .select()
          .eq('user_id', userId)
          .eq('status', 'success')
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Purchase.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('PaymentManager: Error fetching purchases: $e');
      return [];
    }
  }
  
  /// Check if user has purchased a specific product type
  Future<bool> hasPurchased(String userId, ProductType productType, {DateTime? date}) async {
    if (!SupabaseManager.isReady) {
      return false;
    }
    
    try {
      final client = Supabase.instance.client;
      var query = client
          .from('purchases')
          .select('id')
          .eq('user_id', userId)
          .eq('product_type', productType.periodType)
          .eq('status', 'success');
      
      if (date != null && productType.isTemporal) {
        query = query.eq('period_date', date.toIso8601String().split('T').first);
      }
      
      final response = await query.limit(1);
      return (response as List).isNotEmpty;
    } catch (e) {
      debugPrint('PaymentManager: Error checking purchase: $e');
      return false;
    }
  }
}
