/// Écran d'achat du service Timing Lunaire
/// Abonnement mensuel au calendrier lunaire personnalisé
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/lunar_timing_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../widgets/animated_background.dart';
import 'lunar_timing_report_screen.dart';

/// Écran d'achat pour le Timing Lunaire
class LunarTimingPurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const LunarTimingPurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<LunarTimingPurchaseScreen> createState() => _LunarTimingPurchaseScreenState();
}

class _LunarTimingPurchaseScreenState extends State<LunarTimingPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLoadingPhases = true;
  String? _error;
  List<LunarPhase> _phases = [];
  CurrentLunarPhaseInfo? _currentPhaseInfo;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;

  @override
  void initState() {
    super.initState();
    _loadPhases();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  Future<void> _loadPhases() async {
    try {
      final phases = await LunarTimingService.instance.getAllPhases();
      if (mounted) {
        setState(() {
          _phases = phases;
          if (phases.isNotEmpty) {
            _currentPhaseInfo = LunarTimingService.instance.calculateCurrentPhase(
              phases: phases,
            );
          }
          _isLoadingPhases = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading lunar phases: $e');
      if (mounted) {
        setState(() => _isLoadingPhases = false);
      }
    }
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
          'Timing Lunaire',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 60,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroCard(),
            const SizedBox(height: 24),
            _buildCurrentPhasePreview(),
            const SizedBox(height: 24),
            _buildPhasesOverview(),
            const SizedBox(height: 24),
            _buildPlanSummary(),
            const SizedBox(height: 24),
            _buildFormSection(),
            const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            Colors.indigo.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🌙', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Timing Lunaire',
                  style: GoogleFonts.philosopher(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Synchronisez vos activités avec les 8 phases de la Lune pour optimiser vos décisions et actions quotidiennes.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhasePreview() {
    if (_isLoadingPhases) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.block,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_currentPhaseInfo == null) {
      return const SizedBox.shrink();
    }

    final phase = _currentPhaseInfo!.phase;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.indigo.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                phase.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phase actuelle',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phase.phaseName,
                      style: GoogleFonts.philosopher(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPhaseInfo!.daysRemaining}j restants',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo[200],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.indigo[300], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    phase.theme,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.indigo[200],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (phase.conseil != null) ...[
            const SizedBox(height: 12),
            Text(
              '"${phase.conseil}"',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhasesOverview() {
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
            '🌙 Les 8 Phases Lunaires',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _phases.isNotEmpty
                ? _phases.map((phase) => _buildPhaseChip(phase)).toList()
                : _buildDefaultPhaseChips(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDefaultPhaseChips() {
    final defaultPhases = [
      ('🌑', 'Nouvelle Lune', 1),
      ('🌒', 'Premier Croissant', 2),
      ('🌓', 'Premier Quartier', 3),
      ('🌔', 'Gibbeuse Croissante', 4),
      ('🌕', 'Pleine Lune', 5),
      ('🌖', 'Gibbeuse Décroissante', 6),
      ('🌗', 'Dernier Quartier', 7),
      ('🌘', 'Dernier Croissant', 8),
    ];

    return defaultPhases.map((phase) {
      final isCurrent = _currentPhaseInfo?.phase.phaseNumber == phase.$3;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent 
              ? Colors.indigo.withValues(alpha: 0.3)
              : AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: isCurrent 
              ? Border.all(color: Colors.indigo, width: 2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(phase.$1, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              phase.$2,
              style: TextStyle(
                fontSize: 12,
                color: isCurrent ? Colors.white : AppColors.textMuted,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildPhaseChip(LunarPhase phase) {
    final isCurrent = _currentPhaseInfo?.phase.phaseNumber == phase.phaseNumber;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent 
            ? Colors.indigo.withValues(alpha: 0.3)
            : AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: isCurrent 
            ? Border.all(color: Colors.indigo, width: 2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(phase.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            phase.phaseName,
            style: TextStyle(
              fontSize: 12,
              color: isCurrent ? Colors.white : AppColors.textMuted,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
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
                'Votre abonnement',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPlanFeature('✅', 'Calendrier lunaire personnalisé'),
          _buildPlanFeature('✅', 'Phase du jour avec conseils'),
          _buildPlanFeature('✅', 'Activités favorables quotidiennes'),
          _buildPlanFeature('✅', 'Alertes nouvelle/pleine lune'),
          _buildPlanFeature('✅', 'Prévisions sur 30 jours'),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Abonnement mensuel',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
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
        ],
      ),
    );
  }

  Widget _buildPlanFeature(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
            '👤 Vos informations',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _firstNameController,
            style: const TextStyle(color: AppColors.textLight),
            decoration: InputDecoration(
              labelText: 'Votre prénom',
              labelStyle: TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez entrer votre prénom';
              }
              return null;
            },
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
    final canPay = _firstNameController.text.isNotEmpty;
    final price = CurrencyService.instance.formatAmount(widget.plan.priceFcfa);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading || !canPay ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    canPay
                        ? 'S\'abonner - $price/mois'
                        : 'Remplissez le formulaire',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() => _error = 'Veuillez vous connecter pour continuer.');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    try {
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? 'Timing Lunaire - Abonnement',
        priceFcfa: widget.plan.priceFcfa,
      );

      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedProvider,
        customerEmail: user.email,
        callback: (success, purchase, error) async {
          debugPrint('>>> Lunar Timing payment callback: success=$success');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            try {
              // Créer l'abonnement
              await LunarTimingService.instance.createSubscription(
                userId: user.id,
                durationDays: widget.plan.durationDays ?? 30,
                paymentId: purchase.id,
              );
              
              if (!mounted) return;
              
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LunarTimingReportScreen(
                    userName: _firstNameController.text.trim(),
                  ),
                ),
              );
            } catch (e) {
              debugPrint('>>> Error creating subscription: $e');
              if (mounted) {
                // Naviguer quand même vers le rapport
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LunarTimingReportScreen(
                      userName: _firstNameController.text.trim(),
                    ),
                  ),
                );
              }
            }
          } else {
            setState(() { _isLoading = false; _error = error ?? 'Erreur lors du paiement'; });
          }
        },
      );
    } catch (e) {
      debugPrint('>>> Error initiating payment: $e');
      if (mounted) {
        setState(() { _isLoading = false; _error = 'Erreur: ${e.toString()}'; });
      }
    }
  }
}
