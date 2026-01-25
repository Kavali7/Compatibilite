/// FedaPay implementation of PaymentGateway
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../env_config.dart';
import 'payment_gateway.dart';
// Conditional import for web popup
import 'web_url_launcher_stub.dart' if (dart.library.html) 'web_url_launcher.dart';

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
      
      // Step 3: Open payment in popup and start polling
      if (context.mounted) {
        _openPaymentPopup(context, paymentUrl, transactionId, callback);
      }
    } catch (e) {
      debugPrint('FedaPay error: $e');
      final msg = e.toString().replaceFirst('Exception: ', '').replaceFirst('Exception', '');
      callback(PaymentResult.failure('Erreur FedaPay: $msg'));
    }
  }
  
  /// Open payment URL in popup window and poll for completion
  void _openPaymentPopup(
    BuildContext context,
    String paymentUrl,
    String transactionId,
    PaymentCallback callback,
  ) {
    debugPrint('FedaPay: Opening payment popup...');
    
    // Show loading dialog with popup management
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PaymentPopupDialog(
        paymentUrl: paymentUrl,
        transactionId: transactionId,
        onVerify: verifyPayment,
        onComplete: (result) {
          if (ctx.mounted) Navigator.pop(ctx);
          callback(result);
        },
      ),
    );
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

/// Widget that manages the FedaPay popup payment flow
/// Opens payment URL in popup, polls for completion, closes automatically
class _PaymentPopupDialog extends StatefulWidget {
  final String paymentUrl;
  final String transactionId;
  final Future<PaymentVerificationStatus> Function(String) onVerify;
  final void Function(PaymentResult) onComplete;

  const _PaymentPopupDialog({
    required this.paymentUrl,
    required this.transactionId,
    required this.onVerify,
    required this.onComplete,
  });

  @override
  State<_PaymentPopupDialog> createState() => _PaymentPopupDialogState();
}

class _PaymentPopupDialogState extends State<_PaymentPopupDialog> {
  bool _isPolling = false;
  bool _popupOpened = false;
  String _statusMessage = 'Ouverture du paiement...';
  int _pollCount = 0;
  static const int _maxPollAttempts = 60; // 3 minutes max (60 * 3 seconds)

  @override
  void initState() {
    super.initState();
    _openPopupAndStartPolling();
  }

  Future<void> _openPopupAndStartPolling() async {
    try {
      bool launched = false;
      
      // On web, use window.open() for a real popup window
      if (kIsWeb) {
        launched = openUrlInPopup(widget.paymentUrl);
        debugPrint('FedaPay: Opened popup via window.open(): $launched');
      }
      
      // Fallback for non-web or if popup failed
      if (!launched) {
        final uri = Uri.parse(widget.paymentUrl);
        launched = await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
      }
      
      if (launched) {
        setState(() {
          _popupOpened = true;
          _statusMessage = 'Paiement ouvert dans une nouvelle fenêtre.\nFinalisez votre paiement là-bas.';
        });
        
        // Start polling after a short delay
        await Future.delayed(const Duration(seconds: 2));
        _startPolling();
      } else {
        widget.onComplete(PaymentResult.failure('Impossible d\'ouvrir le lien de paiement'));
      }
    } catch (e) {
      debugPrint('FedaPay: Error opening popup: $e');
      widget.onComplete(PaymentResult.failure('Erreur lors de l\'ouverture'));
    }
  }

  Future<void> _startPolling() async {
    if (_isPolling) return;
    
    setState(() => _isPolling = true);
    debugPrint('FedaPay: Starting payment status polling...');
    
    while (_isPolling && _pollCount < _maxPollAttempts && mounted) {
      _pollCount++;
      
      setState(() {
        _statusMessage = 'Vérification du paiement...\n(Tentative $_pollCount)';
      });
      
      final status = await widget.onVerify(widget.transactionId);
      debugPrint('FedaPay: Poll #$_pollCount - Status: $status');
      
      if (status == PaymentVerificationStatus.completed) {
        debugPrint('FedaPay: Payment completed! Closing dialog.');
        _isPolling = false;
        if (mounted) {
          setState(() {
            _statusMessage = 'Paiement confirmé! ✓';
          });
          await Future.delayed(const Duration(milliseconds: 500));
          widget.onComplete(PaymentResult.success(widget.transactionId));
        }
        return;
      } else if (status == PaymentVerificationStatus.failed) {
        debugPrint('FedaPay: Payment failed.');
        _isPolling = false;
        if (mounted) {
          widget.onComplete(PaymentResult.failure('Le paiement a été refusé'));
        }
        return;
      }
      
      // Wait 3 seconds before next poll
      await Future.delayed(const Duration(seconds: 3));
    }
    
    // Timeout - but don't fail, let user manually confirm
    if (mounted && _isPolling) {
      setState(() {
        _isPolling = false;
        _statusMessage = 'Vérification automatique terminée.\nCliquez sur "J\'ai payé" pour confirmer.';
      });
    }
  }

  void _manualVerify() async {
    setState(() {
      _isPolling = true;
      _statusMessage = 'Vérification manuelle...';
    });
    
    final status = await widget.onVerify(widget.transactionId);
    
    if (status == PaymentVerificationStatus.completed) {
      widget.onComplete(PaymentResult.success(widget.transactionId));
    } else if (status == PaymentVerificationStatus.failed) {
      widget.onComplete(PaymentResult.failure('Le paiement a été refusé'));
    } else {
      setState(() {
        _isPolling = false;
        _statusMessage = 'Paiement non encore confirmé.\nFinalisez le paiement dans l\'autre fenêtre.';
      });
    }
  }

  @override
  void dispose() {
    _isPolling = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E3B48),
      title: Row(
        children: [
          if (_isPolling)
            const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF14D5C2),
              ),
            ),
          if (_isPolling) const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Paiement FedaPay',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status icon
          Icon(
            _popupOpened ? Icons.open_in_new : Icons.hourglass_empty,
            color: const Color(0xFF14D5C2),
            size: 48,
          ),
          const SizedBox(height: 16),
          
          // Status message
          Text(
            _statusMessage,
            style: const TextStyle(color: Color(0xFFB6C4CC)),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Le paiement sera vérifié automatiquement',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _isPolling = false;
            widget.onComplete(PaymentResult.failure('Paiement annulé'));
          },
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
        if (!_isPolling)
          ElevatedButton(
            onPressed: _manualVerify,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14D5C2),
            ),
            child: const Text(
              'J\'ai payé',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
