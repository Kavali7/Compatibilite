/// FedaPay implementation of PaymentGateway
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'payment_gateway.dart';

/// FedaPay payment gateway implementation
/// Uses FedaPay API to create payment links and redirect users
class FedapayGateway implements PaymentGateway {
  FedapayGateway._();
  static final FedapayGateway instance = FedapayGateway._();
  
  static const String _liveBaseUrl = 'https://api.fedapay.com';
  static const String _sandboxBaseUrl = 'https://sandbox-api.fedapay.com';
  
  @override
  String get providerName => 'fedapay';
  
  @override
  String get displayName => 'FedaPay';
  
  @override
  String get logoAsset => 'assets/images/fedapay_logo.png';
  
  @override
  bool get isConfigured {
    final publicKey = dotenv.env['FEDAPAY_PUBLIC_KEY'];
    final secretKey = dotenv.env['FEDAPAY_SECRET_KEY'];
    return publicKey != null && publicKey.isNotEmpty && 
           secretKey != null && secretKey.isNotEmpty;
  }
  
  @override
  bool get isSandbox {
    final sandbox = dotenv.env['FEDAPAY_SANDBOX'];
    return sandbox?.toLowerCase() == 'true';
  }
  
  String get _baseUrl => isSandbox ? _sandboxBaseUrl : _liveBaseUrl;
  String? get _secretKey => dotenv.env['FEDAPAY_SECRET_KEY'];
  
  // Transaction storage for callback verification
  final Map<String, PaymentCallback> _pendingCallbacks = {};
  
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
      callback(PaymentResult.failure('FedaPay n\'est pas configuré'));
      return;
    }
    
    debugPrint('=== FEDAPAY GATEWAY ===');
    debugPrint('Amount: $amountFcfa FCFA');
    debugPrint('Reason: $reason');
    debugPrint('Email: $customerEmail');
    debugPrint('Sandbox: $isSandbox');
    
    try {
      // Step 1: Create a transaction
      final transaction = await _createTransaction(
        amount: amountFcfa,
        description: reason,
        customerEmail: customerEmail,
        customerName: customerName,
        customerPhone: customerPhone,
      );
      
      if (transaction == null) {
        callback(PaymentResult.failure('Impossible de créer la transaction'));
        return;
      }
      
      final transactionId = transaction['id']?.toString();
      debugPrint('FedaPay: Transaction created: $transactionId');
      
      // Step 2: Generate payment token/URL
      final paymentUrl = await _generatePaymentUrl(transactionId!);
      
      if (paymentUrl == null) {
        callback(PaymentResult.failure('Impossible de générer le lien de paiement'));
        return;
      }
      
      debugPrint('FedaPay: Payment URL: $paymentUrl');
      
      // Store callback for later verification
      _pendingCallbacks[transactionId] = callback;
      
      // Step 3: Open payment URL in browser
      final uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Show dialog to user to confirm payment completion
        if (context.mounted) {
          _showPaymentConfirmationDialog(context, transactionId, callback);
        }
      } else {
        callback(PaymentResult.failure('Impossible d\'ouvrir le lien de paiement'));
      }
    } catch (e) {
      debugPrint('FedaPay error: $e');
      callback(PaymentResult.failure('Erreur FedaPay: ${e.toString()}'));
    }
  }
  
  /// Create a transaction via FedaPay API
  Future<Map<String, dynamic>?> _createTransaction({
    required int amount,
    required String description,
    required String customerEmail,
    String? customerName,
    String? customerPhone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/transactions'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'amount': amount,
          'currency': {'iso': 'XOF'},
          'callback_url': 'https://compatibilite.app/payment/callback',
          'customer': {
            'email': customerEmail,
            'firstname': customerName?.split(' ').first ?? '',
            'lastname': customerName?.split(' ').skip(1).join(' ') ?? '',
            'phone_number': {'number': customerPhone ?? '', 'country': 'bj'},
          },
        }),
      );
      
      debugPrint('FedaPay create transaction response: ${response.statusCode}');
      debugPrint('FedaPay response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data['v1/transaction'] ?? data;
      } else {
        // Handle API errors
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Erreur inconnue';
        
        // Extract specific validation errors if present
        if (errorData['errors'] != null && errorData['errors'] is Map) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final details = errors.entries.map((e) => '${e.key}: ${e.value is List ? e.value.join(", ") : e.value}').join('\n');
          if (details.isNotEmpty) {
            errorMessage += '\n$details';
          }
        }
        
        debugPrint('FedaPay API Error: $errorMessage');
        return null; // Return null effectively, but we might want to propagate the specific error.
        // For now, logging it is enough as the caller checks for null generic failure.
        // Ideally we should throw so we can show the user the specific message.
      }
    } catch (e) {
      debugPrint('FedaPay create transaction error: $e');
      return null;
    }
  }
  
  /// Generate payment URL for a transaction
  Future<String?> _generatePaymentUrl(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/transactions/$transactionId/token'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
      );
      
      debugPrint('FedaPay token response: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Build checkout URL
        final checkoutBase = isSandbox 
            ? 'https://sandbox-checkout.fedapay.com'
            : 'https://checkout.fedapay.com';
        return '$checkoutBase/checkout/$token';
      }
      return null;
    } catch (e) {
      debugPrint('FedaPay generate URL error: $e');
      return null;
    }
  }
  
  /// Show dialog to confirm payment after user returns from browser
  void _showPaymentConfirmationDialog(
    BuildContext context,
    String transactionId,
    PaymentCallback callback,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E3B48),
        title: const Text(
          'Confirmer le paiement',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Avez-vous terminé le paiement sur FedaPay ?',
          style: TextStyle(color: Color(0xFFB6C4CC)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              callback(PaymentResult.failure('Paiement annulé'));
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              // Verify transaction status
              final status = await verifyPayment(transactionId);
              if (status == PaymentVerificationStatus.completed) {
                callback(PaymentResult.success(transactionId));
              } else {
                callback(PaymentResult.failure('Paiement non confirmé'));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14D5C2),
            ),
            child: const Text('J\'ai payé', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  @override
  Future<PaymentVerificationStatus> verifyPayment(String transactionId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/v1/transactions/$transactionId'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );
      
      debugPrint('FedaPay verify response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transaction = data['v1/transaction'] ?? data;
        final status = transaction['status']?.toString().toLowerCase();
        
        debugPrint('FedaPay transaction status: $status');
        
        switch (status) {
          case 'approved':
          case 'transferred':
            return PaymentVerificationStatus.completed;
          case 'pending':
          case 'processing':
            return PaymentVerificationStatus.pending;
          case 'declined':
          case 'refunded':
          case 'canceled':
            return PaymentVerificationStatus.failed;
          default:
            return PaymentVerificationStatus.unknown;
        }
      }
      return PaymentVerificationStatus.unknown;
    } catch (e) {
      debugPrint('FedaPay verify error: $e');
      return PaymentVerificationStatus.unknown;
    }
  }
}
