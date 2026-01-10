/// Unified Purchase Screen
/// Single entry point for all purchases
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../services/auth_service.dart';
import '../../services/payment/payment_manager.dart';
import '../../services/pricing_service.dart';
import 'widgets/product_card.dart';
import 'widgets/payment_method_card.dart';

/// Purchase screen - unified interface for all product purchases
class PurchaseScreen extends StatefulWidget {
  final String? coupleProfileId;
  final ProductType? preselectedProductType;
  
  const PurchaseScreen({
    super.key,
    this.coupleProfileId,
    this.preselectedProductType,
  });

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  // State
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _error;
  
  // Products
  List<Product> _products = [];
  Product? _selectedProduct;
  
  // Payment
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // Fetch products from pricing service
      await PricingService.instance.fetchPlans();
      final plans = PricingService.instance.plans;
      
      // Convert PricingPlan to Product
      _products = plans.map((plan) => Product(
        id: plan.id,
        type: _mapPlanType(plan.planType),
        name: plan.name,
        description: plan.description ?? '',
        priceFcfa: plan.priceFcfa,
        features: [],
        isActive: plan.isActive,
        isPopular: plan.planType.toLowerCase().contains('subscription'),
        durationDays: plan.durationDays,
      )).toList();
      
      // Preselect if specified
      if (widget.preselectedProductType != null) {
        _selectedProduct = _products.firstWhere(
          (p) => p.type == widget.preselectedProductType,
          orElse: () => _products.first,
        );
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Impossible de charger les produits: $e';
      });
    }
  }
  
  ProductType _mapPlanType(String planType) {
    switch (planType.toLowerCase()) {
      case 'consultation':
        return ProductType.basicReport;
      case 'subscription':
        return ProductType.subscription30;
      case 'annee':
        return ProductType.yearPrediction;
      case 'mois':
        return ProductType.monthPrediction;
      case 'jour':
        return ProductType.dayPrediction;
      default:
        return ProductType.basicReport;
    }
  }
  
  void _onProductSelected(Product product) {
    setState(() => _selectedProduct = product);
  }
  
  void _onProviderSelected(PaymentProvider provider) {
    setState(() => _selectedProvider = provider);
  }
  
  Future<void> _processPurchase() async {
    if (_selectedProduct == null) {
      _showSnack('Veuillez sélectionner un produit');
      return;
    }
    
    final user = AuthService.instance.currentUser;
    if (user == null) {
      _showSnack('Veuillez vous connecter pour effectuer un achat');
      return;
    }
    
    setState(() => _isProcessing = true);
    
    PaymentManager.instance.processPurchaseWithCallback(
      context: context,
      userId: user.id,
      product: _selectedProduct!,
      provider: _selectedProvider,
      customerEmail: user.email,
      customerName: user.name,
      callback: (success, purchase, error) {
        if (mounted) {
          setState(() => _isProcessing = false);
          
          if (success) {
            _showSnack('Paiement réussi !');
            // Navigate to results
            Navigator.pop(context, {
              'success': true,
              'purchase': purchase,
              'product': _selectedProduct,
            });
          } else {
            _showSnack(error ?? 'Paiement échoué');
          }
        }
      },
    );
  }
  
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choisissez votre offre',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products Section
          Text(
            '📦 Nos Offres',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._products.map((product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductCard(
              product: product,
              isSelected: _selectedProduct?.id == product.id,
              onTap: () => _onProductSelected(product),
            ),
          )),
          
          const SizedBox(height: 24),
          
          // Payment Method Section
          Text(
            '💳 Moyen de paiement',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: PaymentMethodCard(
                  provider: PaymentProvider.kkiapay,
                  isSelected: _selectedProvider == PaymentProvider.kkiapay,
                  onTap: () => _onProviderSelected(PaymentProvider.kkiapay),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PaymentMethodCard(
                  provider: PaymentProvider.fedapay,
                  isSelected: _selectedProvider == PaymentProvider.fedapay,
                  onTap: () => _onProviderSelected(PaymentProvider.fedapay),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Summary & Pay Button
          if (_selectedProduct != null) ...[
            _buildSummary(),
            const SizedBox(height: 20),
          ],
          
          _buildPayButton(),
          
          const SizedBox(height: 16),
          
          // Security note
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 16, color: AppColors.textMuted.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  'Paiement sécurisé',
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Produit',
                style: TextStyle(color: AppColors.textMuted),
              ),
              Text(
                _selectedProduct!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Moyen',
                style: TextStyle(color: AppColors.textMuted),
              ),
              Text(
                _selectedProvider.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.textMuted, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              Text(
                '${_selectedProduct!.priceFcfa} FCFA',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPayButton() {
    final isEnabled = _selectedProduct != null && !_isProcessing;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _processPurchase : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.primary : AppColors.block,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                _selectedProduct != null
                    ? 'Payer ${_selectedProduct!.priceFcfa} FCFA'
                    : 'Sélectionnez un produit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
