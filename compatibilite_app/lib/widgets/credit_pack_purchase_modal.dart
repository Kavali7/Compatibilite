/// Credit Pack Purchase Modal
/// Modal pour acheter des packs de crédits décision
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/decision_credit_service.dart';
import '../services/payment_manager.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';

/// Modal pour afficher et acheter les packs de crédits
class CreditPackPurchaseModal extends StatefulWidget {
  final VoidCallback? onPurchaseSuccess;

  const CreditPackPurchaseModal({
    super.key,
    this.onPurchaseSuccess,
  });

  /// Affiche le modal
  static Future<void> show(BuildContext context, {VoidCallback? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreditPackPurchaseModal(onPurchaseSuccess: onSuccess),
    );
  }

  @override
  State<CreditPackPurchaseModal> createState() => _CreditPackPurchaseModalState();
}

class _CreditPackPurchaseModalState extends State<CreditPackPurchaseModal> {
  final DecisionCreditService _creditService = DecisionCreditService();
  final CurrencyService _currencyService = CurrencyService.instance;
  
  List<CreditPack> _packs = [];
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPacks();
  }

  Future<void> _loadPacks() async {
    setState(() => _isLoading = true);
    
    try {
      _packs = await _creditService.getAvailablePacks();
    } catch (e) {
      _error = 'Impossible de charger les packs';
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _purchasePack(CreditPack pack) async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter')),
      );
      return;
    }

    setState(() => _isPurchasing = true);

    try {
      final product = Product(
        id: pack.id,
        type: ProductType.addon,
        name: pack.name,
        description: pack.description ?? '${pack.creditsCount} crédits d\'analyse',
        priceFcfa: pack.priceFcfa,
      );

      // Utiliser le système de paiement existant
      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: PaymentProvider.kkiapay, // Par défaut
        customerEmail: user.email ?? '',
        customerName: user.userMetadata?['first_name'] ?? 'Client',
        callback: (success, purchase, error) {
          if (!mounted) return;
          
          setState(() => _isPurchasing = false);
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${pack.creditsCount} crédits ajoutés !'),
                backgroundColor: Colors.green,
              ),
            );
            
            widget.onPurchaseSuccess?.call();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error ?? 'Échec du paiement'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_shopping_cart, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acheter des Crédits',
                          style: GoogleFonts.philosopher(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          'Pour analyser plus de décisions',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Content
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: _packs.map((pack) => _buildPackCard(pack)).toList(),
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPackCard(CreditPack pack) {
    final bool isBestValue = pack.discountPercent > 20;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBestValue 
              ? AppColors.primary 
              : AppColors.primary.withValues(alpha: 0.3),
          width: isBestValue ? 2 : 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Badge réduction
          if (pack.discountPercent > 0)
            Positioned(
              right: 12,
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '-${pack.discountPercent}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Nombre de crédits
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.secondary.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${pack.creditsCount}',
                      style: GoogleFonts.philosopher(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 14),
                
                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_currencyService.formatAmount(pack.pricePerCredit)}/crédit',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bouton achat
                ElevatedButton(
                  onPressed: _isPurchasing ? null : () => _purchasePack(pack),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBestValue ? AppColors.primary : AppColors.block,
                    foregroundColor: isBestValue ? Colors.white : AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isBestValue 
                          ? BorderSide.none 
                          : BorderSide(color: AppColors.primary),
                    ),
                  ),
                  child: Text(
                    _currencyService.formatAmount(pack.priceFcfa),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
