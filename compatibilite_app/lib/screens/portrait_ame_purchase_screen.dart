/// Portrait de l'Âme - Purchase Screen
/// Écran d'achat du service Portrait de l'Âme
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/cycles_vie_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';  // Pour PaymentProvider
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../widgets/animated_background.dart';
import 'portrait_ame_report_screen.dart';

/// Écran d'achat du Portrait de l'Âme
class PortraitAmePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const PortraitAmePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<PortraitAmePurchaseScreen> createState() => _PortraitAmePurchaseScreenState();
}

class _PortraitAmePurchaseScreenState extends State<PortraitAmePurchaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  
  // Date de naissance - composants
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthdate;
  
  bool _isProcessing = false;
  String? _error;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
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
          'Portrait de l\'Âme',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 35,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Introduction mystique
            _buildIntroCard(),
            const SizedBox(height: 28),

            // Récapitulatif du plan
            _buildPlanSummary(),
            const SizedBox(height: 28),

            // Formulaire
            _buildFormSection(),
            const SizedBox(height: 28),
            
            // Payment method selection
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),

            // Erreur
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),

            // Bouton de paiement
            _buildPaymentButton(),
            
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
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.purple, size: 48),
          const SizedBox(height: 16),
          Text(
            'Découvrez votre Portrait de l\'Âme',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Basé sur les Cycles de Vie ancestraux, ce rapport révèle votre essence profonde, vos talents naturels et les défis karmiques de votre incarnation.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Votre commande',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.plan.name,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),
              Text(
                CurrencyService.instance.formatAmount(widget.plan.priceFcfa),
                style: GoogleFonts.philosopher(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (widget.plan.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.plan.description!,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📝 Vos informations',
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),

        // Prénom
        TextFormField(
          controller: _firstNameController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: InputDecoration(
            labelText: 'Prénom(s)',
            labelStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.block,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer votre prénom' : null,
        ),
        const SizedBox(height: 16),

        // Date de naissance (dropdowns)
        _buildDateDropdowns(),
      ],
    );
  }

  /// Calcule le nombre de jours dans un mois
  int _daysInMonth(int? year, int? month) {
    if (year == null || month == null) return 31;
    return DateTime(year, month + 1, 0).day;
  }

  /// Met à jour la date de naissance complète
  void _updateBirthdate() {
    if (_birthYear != null && _birthMonth != null && _birthDay != null) {
      final maxDay = _daysInMonth(_birthYear, _birthMonth);
      if (_birthDay! > maxDay) {
        _birthDay = null;
        _birthdate = null;
        return;
      }
      _birthdate = DateTime(_birthYear!, _birthMonth!, _birthDay!);
    } else {
      _birthdate = null;
    }
  }

  Widget _buildDateDropdowns() {
    final now = DateTime.now();
    final years = List<int>.generate(now.year - 1919, (i) => 1920 + i).reversed.toList();
    final months = const [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxDay = _daysInMonth(_birthYear, _birthMonth);
    final days = List<int>.generate(maxDay, (i) => i + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cake, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Text(
                'Date de naissance',
                style: GoogleFonts.philosopher(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Année dropdown
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Année',
              labelStyle: TextStyle(color: AppColors.textMuted),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            value: _birthYear,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: years.map((y) => DropdownMenuItem<int>(
              value: y,
              child: Text('$y'),
            )).toList(),
            onChanged: (val) => setState(() {
              _birthYear = val;
              _updateBirthdate();
            }),
          ),
          const SizedBox(height: 12),
          // Mois dropdown
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Mois',
              labelStyle: TextStyle(color: AppColors.textMuted),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            value: _birthMonth,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: List.generate(
              months.length,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text(months[index]),
              ),
            ),
            onChanged: (val) => setState(() {
              _birthMonth = val;
              _updateBirthdate();
            }),
          ),
          const SizedBox(height: 12),
          // Jour dropdown
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Jour',
              labelStyle: TextStyle(color: AppColors.textMuted),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            value: _birthDay != null && _birthDay! <= maxDay ? _birthDay : null,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: days.map((d) => DropdownMenuItem<int>(
              value: d,
              child: Text('$d'),
            )).toList(),
            onChanged: (val) => setState(() {
              _birthDay = val;
              _updateBirthdate();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💳 Moyen de paiement',
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPaymentProviderCard(
                provider: PaymentProvider.kkiapay,
                label: 'Kkiapay',
                icon: Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPaymentProviderCard(
                provider: PaymentProvider.fedapay,
                label: 'FedaPay',
                icon: Icons.credit_card,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentProviderCard({
    required PaymentProvider provider,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedProvider == provider;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedProvider = provider),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.block,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.block,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textLight : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(Icons.check_circle, color: AppColors.primary, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    final isEnabled = !_isProcessing;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _processPayment : null,
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
                'Payer ${CurrencyService.instance.formatAmount(widget.plan.priceFcfa)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_birthdate == null) {
      setState(() => _error = 'Veuillez sélectionner votre date de naissance complète');
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Veuillez vous connecter pour continuer';
          _isProcessing = false;
        });
        return;
      }

      // Créer le produit pour le paiement
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? '',
        priceFcfa: widget.plan.priceFcfa,
      );

      // Lancer le paiement via PaymentManager
      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedProvider,
        customerEmail: user.email ?? '',
        customerName: _firstNameController.text,
        callback: (success, purchase, error) {
          debugPrint('>>> Portrait Âme payment callback: success=$success, error=$error');
          
          if (!mounted) return;
          
          setState(() => _isProcessing = false);
          
          if (success) {
            debugPrint('>>> Payment success, navigating to report...');
            // Naviguer vers le rapport
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PortraitAmeReportScreen(
                  firstName: _firstNameController.text.trim(),
                  birthdate: _birthdate!,
                ),
              ),
            );
          } else {
            setState(() => _error = error ?? 'Paiement échoué');
          }
        },
      );
    } catch (e) {
      debugPrint('>>> Payment error: $e');
      if (mounted) {
        setState(() {
          _error = 'Erreur: $e';
          _isProcessing = false;
        });
      }
    }
  }
}
