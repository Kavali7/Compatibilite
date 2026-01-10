/// Purchase model for tracking all purchases
library;

import 'product_model.dart';

/// Purchase status
enum PurchaseStatus {
  pending,
  success,
  failed,
  refunded,
}

extension PurchaseStatusExtension on PurchaseStatus {
  String get value {
    switch (this) {
      case PurchaseStatus.pending:
        return 'pending';
      case PurchaseStatus.success:
        return 'success';
      case PurchaseStatus.failed:
        return 'failed';
      case PurchaseStatus.refunded:
        return 'refunded';
    }
  }
  
  static PurchaseStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'success':
        return PurchaseStatus.success;
      case 'failed':
        return PurchaseStatus.failed;
      case 'refunded':
        return PurchaseStatus.refunded;
      default:
        return PurchaseStatus.pending;
    }
  }
}

/// Payment provider
enum PaymentProvider {
  kkiapay,
  fedapay,
}

extension PaymentProviderExtension on PaymentProvider {
  String get value {
    switch (this) {
      case PaymentProvider.kkiapay:
        return 'kkiapay';
      case PaymentProvider.fedapay:
        return 'fedapay';
    }
  }
  
  String get displayName {
    switch (this) {
      case PaymentProvider.kkiapay:
        return 'Kkiapay';
      case PaymentProvider.fedapay:
        return 'FedaPay';
    }
  }
  
  String get iconAsset {
    switch (this) {
      case PaymentProvider.kkiapay:
        return 'assets/images/kkiapay_logo.png';
      case PaymentProvider.fedapay:
        return 'assets/images/fedapay_logo.png';
    }
  }
  
  static PaymentProvider fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'fedapay':
        return PaymentProvider.fedapay;
      default:
        return PaymentProvider.kkiapay;
    }
  }
}

/// Purchase record model
class Purchase {
  final String id;
  final String userId;
  final ProductType productType;
  final DateTime? periodDate;
  final PaymentProvider provider;
  final String transactionId;
  final int amountFcfa;
  final PurchaseStatus status;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  
  const Purchase({
    required this.id,
    required this.userId,
    required this.productType,
    this.periodDate,
    required this.provider,
    required this.transactionId,
    required this.amountFcfa,
    required this.status,
    this.metadata,
    required this.createdAt,
  });
  
  /// Create from Supabase JSON
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productType: _parseProductType(json['product_type'] as String?),
      periodDate: json['period_date'] != null 
          ? DateTime.parse(json['period_date'] as String)
          : null,
      provider: PaymentProviderExtension.fromString(json['payment_provider'] as String?),
      transactionId: json['transaction_id'] as String,
      amountFcfa: json['amount_fcfa'] as int,
      status: PurchaseStatusExtension.fromString(json['status'] as String?),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_type': productType.periodType,
      'period_date': periodDate?.toIso8601String().split('T').first,
      'payment_provider': provider.value,
      'transaction_id': transactionId,
      'amount_fcfa': amountFcfa,
      'status': status.value,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  /// For inserting new purchase
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'product_type': productType.periodType,
      'period_date': periodDate?.toIso8601String().split('T').first,
      'payment_provider': provider.value,
      'transaction_id': transactionId,
      'amount_fcfa': amountFcfa,
      'status': status.value,
      'metadata': metadata ?? {},
    };
  }
  
  static ProductType _parseProductType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'basic_report':
      case 'base':
        return ProductType.basicReport;
      case 'annee':
        return ProductType.yearPrediction;
      case 'mois':
        return ProductType.monthPrediction;
      case 'jour':
        return ProductType.dayPrediction;
      case 'bundle':
        return ProductType.fullBundle;
      case 'subscription':
        return ProductType.subscription30;
      default:
        return ProductType.basicReport;
    }
  }
  
  @override
  String toString() => 'Purchase($id, $productType, $status)';
}
