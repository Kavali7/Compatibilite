/// Credit Pack Purchase Modal
/// Modal pour acheter des packs de crédits décision
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/decision_credit_service.dart';
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
      if (_packs.isEmpty) {
        _error = 'Aucun pack disponible pour le moment';
      }
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
      // TODO: Intégrer le système de paiement existant
      // Pour l'instant, on simule un achat réussi pour tester le flow
      
      // Simuler un délai de paiement
      await Future.delayed(const Duration(seconds: 1));
      
      // En production, vous utiliserez:
      // - PaymentManager pour initier le paiement
      // - Webhook/callback pour confirmer et attribuer les crédits
      
      if (mounted) {
        setState(() => _isPurchasing = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${pack.creditsCount} crédits ajoutés !'),
            backgroundColor: Colors.green,
          ),
        );
        
        widget.onPurchaseSuccess?.call();
        Navigator.pop(context);
      }
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.close, color: AppColors.textMuted, size: 24),
                    ),
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
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.textMuted, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Créez des packs dans Admin > Cycles > Credit Packs',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                Flexible(
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
                        overflow: TextOverflow.ellipsis,
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
                
                const SizedBox(width: 8),
                
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
                  child: _isPurchasing 
                      ? const SizedBox(
                          width: 16, 
                          height: 16, 
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
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
