/// FedaPay implementation of PaymentGateway
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../env_config.dart';
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
    final publicKey = EnvConfig.fedapayPublicKey;
    final secretKey = EnvConfig.fedapaySecretKey;
    return publicKey.isNotEmpty && secretKey.isNotEmpty;
  }
  
  @override
  bool get isSandbox => EnvConfig.fedapaySandbox;
  
  String get _baseUrl => isSandbox ? _sandboxBaseUrl : _liveBaseUrl;
  String get _secretKey => EnvConfig.fedapaySecretKey;
  
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
      final msg = e.toString().replaceFirst('Exception: ', '').replaceFirst('Exception', '');
      callback(PaymentResult.failure('Erreur FedaPay: $msg'));
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
      // Split name safely
      String firstname = 'Client';
      String lastname = 'Compatibilite';
      
      if (customerName != null && customerName.trim().isNotEmpty) {
        final parts = customerName.trim().split(' ');
        if (parts.length >= 2) {
          firstname = parts.first;
          lastname = parts.sublist(1).join(' ');
        } else {
          firstname = parts.first;
        }
      }

      final Map<String, dynamic> customerData = {
        'email': customerEmail,
        'firstname': firstname,
        'lastname': lastname,
      };

      // Only add phone_number if provided and valid-looking
      if (customerPhone != null && customerPhone.trim().length >= 8) {
        customerData['phone_number'] = {
          'number': customerPhone.trim().replaceAll('+', '').replaceAll(' ', ''), 
          'country': 'bj' // Default country
        };
      }

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
          // Callback URL for web - FedaPay will redirect here after payment
          'callback_url': 'https://growpeak-agence.com/#/payment-callback',
          'customer': customerData,
        }),
      );
      
      debugPrint('FedaPay create transaction response: ${response.statusCode}');
      debugPrint('FedaPay response body: ${response.body}');
      
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data['v1/transaction'] ?? data;
      } else {
        // Handle API errors
        String errorMessage = data['message'] ?? 'Erreur lors de la création de la transaction';
        
        // Extract specific validation errors if present
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          final details = errors.entries
              .map((e) => '${e.key}: ${e.value is List ? e.value.join(", ") : e.value}')
              .join('\n');
          if (details.isNotEmpty) {
            errorMessage += '\n$details';
          }
        }
        
        debugPrint('FedaPay API Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('FedaPay _createTransaction error: $e');
      rethrow;
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
      debugPrint('FedaPay token body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // FedaPay returns the complete payment URL in the 'url' field
        final paymentUrl = data['url'] as String?;
        
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          debugPrint('FedaPay: Using returned payment URL: $paymentUrl');
          return paymentUrl;
        }
        
        // Fallback: construct URL from token if 'url' is not provided
        final token = data['token'];
        if (token == null || token.toString().isEmpty) {
          debugPrint('FedaPay: Token is null or empty');
          return null;
        }
        
        final checkoutBase = isSandbox 
            ? 'https://sandbox-process.fedapay.com'
            : 'https://process.fedapay.com';
        final constructedUrl = '$checkoutBase/$token';
        debugPrint('FedaPay: Constructed payment URL: $constructedUrl');
        return constructedUrl;
      } else {
        debugPrint('FedaPay token error: ${response.body}');
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
    bool isVerifying = false;
    String? errorMessage;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E3B48),
          title: const Text(
            'Confirmer le paiement',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Avez-vous terminé le paiement sur FedaPay ?',
                style: TextStyle(color: Color(0xFFB6C4CC)),
              ),
              if (isVerifying) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: Color(0xFF14D5C2)),
                const SizedBox(height: 8),
                const Text(
                  'Vérification en cours...',
                  style: TextStyle(color: Color(0xFFB6C4CC), fontSize: 12),
                ),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isVerifying ? null : () {
                Navigator.pop(ctx);
                callback(PaymentResult.failure('Paiement annulé'));
              },
              child: Text(
                'Annuler',
                style: TextStyle(color: isVerifying ? Colors.grey : null),
              ),
            ),
            ElevatedButton(
              onPressed: isVerifying ? null : () async {
                setDialogState(() {
                  isVerifying = true;
                  errorMessage = null;
                });
                
                // Verify transaction status
                debugPrint('FedaPay: Verifying transaction $transactionId...');
                final status = await verifyPayment(transactionId);
                debugPrint('FedaPay: Verification result: $status');
                
                if (status == PaymentVerificationStatus.completed) {
                  if (ctx.mounted) Navigator.pop(ctx);
                  callback(PaymentResult.success(transactionId));
                } else if (status == PaymentVerificationStatus.pending) {
                  setDialogState(() {
                    isVerifying = false;
                    errorMessage = 'Le paiement est encore en cours de traitement. Veuillez patienter quelques secondes et réessayer.';
                  });
                } else {
                  setDialogState(() {
                    isVerifying = false;
                    errorMessage = 'Paiement non confirmé. Veuillez vérifier que vous avez bien finalisé le paiement sur FedaPay, puis réessayez.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isVerifying ? Colors.grey : const Color(0xFF14D5C2),
              ),
              child: Text(
                isVerifying ? 'Vérification...' : 'J\'ai payé',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
