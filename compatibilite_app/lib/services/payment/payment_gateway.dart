/// Payment Gateway abstract interface
/// All payment providers must implement this interface
library;

import 'package:flutter/material.dart';

/// Result of a payment attempt
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final Map<String, dynamic>? rawResponse;
  
  const PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    this.rawResponse,
  });
  
  factory PaymentResult.success(String transactionId, [Map<String, dynamic>? rawResponse]) {
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      rawResponse: rawResponse,
    );
  }
  
  factory PaymentResult.failure(String errorMessage, [Map<String, dynamic>? rawResponse]) {
    return PaymentResult(
      success: false,
      errorMessage: errorMessage,
      rawResponse: rawResponse,
    );
  }
}

/// Payment status for verification
enum PaymentVerificationStatus {
  pending,
  completed,
  failed,
  cancelled,
  unknown,
}

/// Callback type for payment events
typedef PaymentCallback = void Function(PaymentResult result);

/// Abstract payment gateway interface
/// All payment providers (Kkiapay, FedaPay) must implement this
abstract class PaymentGateway {
  /// Provider identifier
  String get providerName;
  
  /// Provider display name for UI
  String get displayName;
  
  /// Provider logo asset path
  String get logoAsset;
  
  /// Check if the provider is properly configured
  bool get isConfigured;
  
  /// Check if running in sandbox mode
  bool get isSandbox;
  
  /// Initiate a payment
  /// [context] is required for showing payment UI
  /// [amountFcfa] is the amount in CFA Francs
  /// [reason] is the payment description
  /// [customerEmail] is the customer's email
  /// [customerPhone] is optional phone number
  /// [customerName] is optional customer name
  /// [callback] is called when payment completes or fails
  Future<void> initiatePayment({
    required BuildContext context,
    required int amountFcfa,
    required String reason,
    required String customerEmail,
    String? customerPhone,
    String? customerName,
    required PaymentCallback callback,
  });
  
  /// Verify a payment status
  Future<PaymentVerificationStatus> verifyPayment(String transactionId);
}
