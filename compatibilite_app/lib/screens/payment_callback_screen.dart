import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../services/payment/fedapay_gateway.dart';
import '../services/payment/payment_gateway.dart';

/// Screen shown after FedaPay payment redirect
/// This screen automatically verifies the payment and shows the result
class PaymentCallbackScreen extends StatefulWidget {
  final String? transactionId;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  const PaymentCallbackScreen({
    super.key,
    this.transactionId,
    this.onSuccess,
    this.onFailure,
  });

  @override
  State<PaymentCallbackScreen> createState() => _PaymentCallbackScreenState();
}

class _PaymentCallbackScreenState extends State<PaymentCallbackScreen> {
  bool _isVerifying = true;
  bool _isSuccess = false;
  String _message = 'Vérification du paiement en cours...';

  @override
  void initState() {
    super.initState();
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    if (widget.transactionId == null || widget.transactionId!.isEmpty) {
      setState(() {
        _isVerifying = false;
        _isSuccess = false;
        _message = 'Transaction non trouvée. Veuillez réessayer.';
      });
      return;
    }

    try {
      final status = await FedapayGateway.instance.verifyPayment(widget.transactionId!);
      
      setState(() {
        _isVerifying = false;
        _isSuccess = status == PaymentVerificationStatus.completed;
        _message = _isSuccess 
            ? 'Paiement confirmé ! Votre rapport est prêt.'
            : status == PaymentVerificationStatus.pending
                ? 'Paiement en attente de confirmation...'
                : 'Paiement non confirmé. Veuillez réessayer.';
      });

      if (_isSuccess) {
        widget.onSuccess?.call();
      } else {
        widget.onFailure?.call();
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _isSuccess = false;
        _message = 'Erreur lors de la vérification: ${e.toString()}';
      });
      widget.onFailure?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isVerifying)
                const CircularProgressIndicator(color: AppColors.primary)
              else
                Icon(
                  _isSuccess ? Icons.check_circle : Icons.error,
                  size: 80,
                  color: _isSuccess ? Colors.green : Colors.orange,
                ),
              const SizedBox(height: 24),
              Text(
                _isVerifying ? 'Vérification...' : (_isSuccess ? 'Succès !' : 'Attention'),
                style: GoogleFonts.philosopher(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              if (!_isVerifying)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    _isSuccess ? 'Voir mon rapport' : 'Retour',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
