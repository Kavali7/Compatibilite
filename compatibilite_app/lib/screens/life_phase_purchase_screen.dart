/// Life Phase Purchase Screen (Service 07)
/// Écran d'achat du service Phases de Vie
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/life_phase_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../widgets/animated_background.dart';
import 'life_phase_report_screen.dart';

/// Écran d'achat des Phases de Vie
class LifePhasePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const LifePhasePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<LifePhasePurchaseScreen> createState() => _LifePhasePurchaseScreenState();
}

class _LifePhasePurchaseScreenState extends State<LifePhasePurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  
  // Date de naissance - dropdowns séparés (style Compatibilité)
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthdate;
  
  bool _isProcessing = false;
  String? _error;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _birthYear = now.year - 30;
    _birthMonth = now.month;
    _birthDay = now.day;
    _updateBirthdate();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  void _updateBirthdate() {
    if (_birthYear != null && _birthMonth != null && _birthDay != null) {
      final maxDay = _daysInMonth(_birthYear, _birthMonth);
      if (_birthDay! > maxDay) {
        _birthDay = maxDay;
      }
      _birthdate = DateTime(_birthYear!, _birthMonth!, _birthDay!);
    } else {
      _birthdate = null;
    }
  }

  int _daysInMonth(int? year, int? month) {
    if (year == null || month == null) return 31;
    final beginningNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1)).day;
  }

  int? get _currentAge {
    if (_birthdate == null) return null;
    final now = DateTime.now();
    int age = now.year - _birthdate!.year;
    if (now.month < _birthdate!.month ||
        (now.month == _birthdate!.month && now.day < _birthdate!.day)) {
      age--;
    }
    return age;
  }

  int? get _currentPhaseNumber {
    final age = _currentAge;
    if (age == null) return null;
    return (age ~/ 7) + 1;
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
          'Phases de Vie',
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
            _buildIntroCard(),
            const SizedBox(height: 28),

            _buildPhasesOverview(),
            const SizedBox(height: 28),

            _buildPlanSummary(),
            const SizedBox(height: 28),

            _buildFormSection(),
            const SizedBox(height: 28),
            
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),

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
                    Expanded(child: Text(_error!, style: TextStyle(color: AppColors.error))),
                  ],
                ),
              ),

            _buildPayButton(),
            
            const SizedBox(height: 16),
            
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
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.timeline, color: AppColors.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            'Découvrez Vos Phases de Vie',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Votre existence suit un schéma de cycles de 7 ans, chacun avec son thème unique. '
            'Comprenez où vous en êtes et comment les phases passées ont façonné qui vous êtes.',
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

  Widget _buildPhasesOverview() {
    final phases = [
      ('1', 'Enfance', '0-7'),
      ('2', 'Croissance', '7-14'),
      ('3', 'Adolescence', '14-21'),
      ('4', 'Jeune Adulte', '21-28'),
      ('5', 'Maturité', '28-35'),
      ('6', 'Réévaluation', '35-42'),
      ('7', 'Sagesse', '42-49'),
      ('8', 'Accomplissement', '49-56'),
      ('9', 'Sagesse Profonde', '56-63'),
      ('10', 'Transcendance', '63+'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Les 10 Phases de Vie',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: phases.map((p) {
              final isCurrentPhase = _currentPhaseNumber != null && 
                  int.parse(p.$1) == _currentPhaseNumber;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrentPhase 
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCurrentPhase 
                        ? AppColors.primary 
                        : AppColors.textMuted.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${p.$1}.',
                      style: TextStyle(
                        color: isCurrentPhase ? AppColors.primary : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${p.$2} (${p.$3})',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (_currentAge != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Vous avez $_currentAge ans → Phase $_currentPhaseNumber',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    final price = CurrencyService.instance.formatAmount(widget.plan.priceFcfa);
    
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
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
              Expanded(
                child: Text(
                  widget.plan.name,
                  style: TextStyle(color: AppColors.textLight, fontSize: 15),
                ),
              ),
              Text(
                price,
                style: GoogleFonts.philosopher(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Accès permanent à votre rapport complet',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
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
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.block,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          child: TextFormField(
            controller: _firstNameController,
            style: TextStyle(color: AppColors.textLight),
            decoration: InputDecoration(
              labelText: 'Votre prénom',
              labelStyle: TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre prénom';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        
        Text(
          '🎂 Date de naissance',
          style: GoogleFonts.philosopher(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Essentielle pour calculer vos phases de vie',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildDateDropdowns(),
      ],
    );
  }

  Widget _buildDateDropdowns() {
    final now = DateTime.now();
    final years = List<int>.generate(now.year - 1919, (i) => 1920 + i).reversed.toList();
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxDay = _daysInMonth(_birthYear, _birthMonth);
    final days = List<int>.generate(maxDay, (i) => i + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Année'),
            value: _birthYear,
            items: years.map((y) => DropdownMenuItem<int>(value: y, child: Text('$y'))).toList(),
            onChanged: (val) => setState(() { _birthYear = val; _updateBirthdate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Mois'),
            value: _birthMonth,
            items: List.generate(months.length, (i) => DropdownMenuItem<int>(value: i + 1, child: Text(months[i]))),
            onChanged: (val) => setState(() { _birthMonth = val; _updateBirthdate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Jour'),
            value: _birthDay != null && _birthDay! <= maxDay ? _birthDay : null,
            items: days.map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(),
            onChanged: (val) => setState(() { _birthDay = val; _updateBirthdate(); }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
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
          _buildPaymentOption(PaymentProvider.kkiapay, 'Kkiapay', 'Cartes, Mobile Money', Icons.credit_card),
          const SizedBox(height: 12),
          _buildPaymentOption(PaymentProvider.fedapay, 'FedaPay', 'Cartes bancaires, Mobile Money', Icons.account_balance),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(PaymentProvider provider, String name, String desc, IconData icon) {
    final isSelected = _selectedProvider == provider;
    
    return InkWell(
      onTap: () => setState(() => _selectedProvider = provider),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textMuted.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    final canPay = _birthdate != null && _firstNameController.text.isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing || !canPay ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: _isProcessing
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    canPay 
                      ? 'Payer ${CurrencyService.instance.formatAmount(widget.plan.priceFcfa)}'
                      : 'Remplissez le formulaire',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_birthdate == null) {
      setState(() => _error = 'Veuillez sélectionner votre date de naissance.');
      return;
    }

    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() => _error = 'Veuillez vous connecter pour continuer.');
      return;
    }

    setState(() { _isProcessing = true; _error = null; });

    try {
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? 'Phases de Vie',
        priceFcfa: widget.plan.priceFcfa,
      );

      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedProvider,
        customerEmail: user.email,
        callback: (success, purchase, error) async {
          debugPrint('>>> Life Phase payment callback: success=$success');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            try {
              await LifePhaseService.instance.createPurchase(
                userId: user.id,
                birthDate: _birthdate!,
                paymentId: purchase.id,
              );
              
              if (!mounted) return;
              
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LifePhaseReportScreen(
                    userName: _firstNameController.text.trim(),
                    birthDate: _birthdate!,
                  ),
                ),
              );
            } catch (e) {
              debugPrint('>>> Error creating purchase: $e');
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LifePhaseReportScreen(
                      userName: _firstNameController.text.trim(),
                      birthDate: _birthdate!,
                    ),
                  ),
                );
              }
            }
          } else {
            setState(() { _isProcessing = false; _error = error ?? 'Erreur lors du paiement'; });
          }
        },
      );
    } catch (e) {
      debugPrint('>>> Error initiating payment: $e');
      if (mounted) {
        setState(() { _isProcessing = false; _error = 'Erreur: ${e.toString()}'; });
      }
    }
  }
}
