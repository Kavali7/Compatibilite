/// Kkiapay implementation of PaymentGateway
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';

import 'payment_gateway.dart';

/// Kkiapay payment gateway implementation
class KkiapayGateway implements PaymentGateway {
  KkiapayGateway._();
  static final KkiapayGateway instance = KkiapayGateway._();
  
  @override
  String get providerName => 'kkiapay';
  
  @override
  String get displayName => 'Kkiapay';
  
  @override
  String get logoAsset => 'assets/images/kkiapay_logo.png';
  
  @override
  bool get isConfigured {
    final key = dotenv.env['KKIAPAY_PUBLIC_KEY'];
    return key != null && key.isNotEmpty;
  }
  
  @override
  bool get isSandbox {
    final sandbox = dotenv.env['KKIAPAY_SANDBOX'];
    return sandbox?.toLowerCase() == 'true';
  }
  
  String? get _publicKey => dotenv.env['KKIAPAY_PUBLIC_KEY'];
  
  @override
  Future<void> initiatePayment({
    required BuildContext context,
    required int amountFcfa,
    required String reason,
    required String customerEmail,
    String? customerPhone,
    String? customerName,
    required PaymentCallback callback,
  }) async {
    if (!isConfigured) {
      callback(PaymentResult.failure('Kkiapay n\'est pas configuré'));
      return;
    }
    
    debugPrint('=== KKIAPAY GATEWAY ===');
    debugPrint('Amount: $amountFcfa FCFA');
    debugPrint('Reason: $reason');
    debugPrint('Email: $customerEmail');
    debugPrint('Sandbox: $isSandbox');
    
    final widget = KKiaPay(
      amount: amountFcfa,
      countries: const ['BJ', 'CI', 'SN', 'TG'],
      phone: customerPhone ?? '',
      name: customerName ?? '',
      email: customerEmail,
      reason: reason,
      sandbox: isSandbox,
      apikey: _publicKey!,
      callback: (response, _) {
        _handleCallback(response, context, callback);
      },
      theme: '#14D5C2', // Primary color
      paymentMethods: const ['momo', 'card'],
    );
    
    // Navigate to payment screen
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => widget),
      );
    }
  }
  
  void _handleCallback(
    Map<String, dynamic> response,
    BuildContext context,
    PaymentCallback callback,
  ) {
    debugPrint('=== KKIAPAY CALLBACK ===');
    debugPrint('Response: $response');
    
    // Pop the payment screen
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    final status = response['status'] as String?;
    final transactionId = response['transactionId']?.toString();
    
    if (status == 'SUCCESS' && transactionId != null) {
      callback(PaymentResult.success(transactionId, response));
    } else if (status == 'CANCELLED') {
      callback(PaymentResult.failure('Paiement annulé', response));
    } else {
      final failureMessage = response['failureMessage'] as String?;
      callback(PaymentResult.failure(
        failureMessage ?? 'Paiement échoué',
        response,
      ));
    }
  }
  
  @override
  Future<PaymentVerificationStatus> verifyPayment(String transactionId) async {
    // Kkiapay doesn't have a simple verification API
    // The callback is the source of truth
    // For now, return unknown
    debugPrint('Kkiapay verify payment: $transactionId');
    return PaymentVerificationStatus.unknown;
  }
}
