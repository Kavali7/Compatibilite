/// Daily Guide Purchase Screen
/// Écran d'achat du service Guide Horaire (Service 05)
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/daily_guide_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../widgets/animated_background.dart';
import 'daily_guide_report_screen.dart';

/// Écran d'achat du Guide Horaire
class DailyGuidePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const DailyGuidePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<DailyGuidePurchaseScreen> createState() => _DailyGuidePurchaseScreenState();
}

class _DailyGuidePurchaseScreenState extends State<DailyGuidePurchaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Identité de l'utilisateur
  final TextEditingController _firstNameController = TextEditingController();
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthDate;
  
  // Date cible - composants séparés (style Compatibilité)
  int? _targetYear;
  int? _targetMonth;
  int? _targetDay;
  DateTime? _targetDate;
  
  bool _isProcessing = false;
  String? _error;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;

  @override
  void initState() {
    super.initState();
    // Initialiser avec aujourd'hui
    final now = DateTime.now();
    _targetYear = now.year;
    _targetMonth = now.month;
    _targetDay = now.day;
    _targetDate = now;
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
          'Guide Horaire',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Introduction mystique
            _buildIntroCard(),
            const SizedBox(height: 28),

            // Ce que vous obtenez
            _buildFeaturesCard(),
            const SizedBox(height: 28),

            // Récapitulatif du plan
            _buildPlanSummary(),
            const SizedBox(height: 28),

            // Formulaire - Identité personnelle
            _buildPersonalInfoSection(),
            const SizedBox(height: 28),

            // Formulaire - Date cible
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
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.1),
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
        children: [
          const Icon(Icons.schedule, color: AppColors.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            'Votre Guide Horaire Quotidien',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Optimisez chaque moment de votre journée avec les 7 créneaux énergétiques personnalisés.',
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

  Widget _buildFeaturesCard() {
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
              Icon(Icons.star, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Les 7 créneaux de votre journée',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(Icons.wb_twilight, 'Aube (5h-8h) — Initiation'),
          _buildFeatureItem(Icons.wb_sunny, 'Matin (8h-11h) — Concentration'),
          _buildFeatureItem(Icons.restaurant, 'Midi (11h-14h) — Transition'),
          _buildFeatureItem(Icons.groups, 'Après-midi 1 (14h-16h) — Collaboration'),
          _buildFeatureItem(Icons.edit_note, 'Après-midi 2 (16h-18h) — Exécution'),
          _buildFeatureItem(Icons.nightlight, 'Soir (18h-21h) — Personnel'),
          _buildFeatureItem(Icons.bedtime, 'Nuit (21h-23h) — Clôture'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary.withValues(alpha: 0.8), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
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
              Expanded(
                child: Text(
                  widget.plan.name,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
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
          if (_targetDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_available, color: AppColors.textMuted, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Guide pour : ${_formatDate(_targetDate!)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 
                  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
    
    final jour = jours[date.weekday - 1];
    final moisNom = mois[date.month - 1];
    
    return '$jour ${date.day} $moisNom ${date.year}';
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ Votre identité',
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Votre guide est personnalisé selon votre date de naissance.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
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
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                style: const TextStyle(color: AppColors.textLight),
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.3)),
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
              const SizedBox(height: 16),
              _buildBirthDateDropdowns(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateDropdowns() {
    final years = List<int>.generate(126, (i) => 1900 + i); // 1900 → 2025
    final months = const [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxBirthDay = _daysInMonth(_birthYear, _birthMonth);
    final birthDays = List<int>.generate(maxBirthDay, (i) => i + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date de naissance',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Jour'),
          isExpanded: true,
          value: _birthDay != null && _birthDay! <= maxBirthDay ? _birthDay : null,
          items: birthDays
              .map((d) => DropdownMenuItem<int>(
                    value: d,
                    child: Text('$d'),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              _birthDay = val;
              _updateBirthDate();
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Mois'),
          isExpanded: true,
          value: _birthMonth,
          items: List.generate(
            months.length,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text(months[index]),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _birthMonth = val;
              _updateBirthDate();
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Année'),
          isExpanded: true,
          value: _birthYear,
          items: years
              .map((y) => DropdownMenuItem<int>(
                    value: y,
                    child: Text('$y'),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              _birthYear = val;
              _updateBirthDate();
            });
          },
        ),
      ],
    );
  }

  void _updateBirthDate() {
    if (_birthYear != null && _birthMonth != null && _birthDay != null) {
      final maxDay = _daysInMonth(_birthYear, _birthMonth);
      if (_birthDay! > maxDay) {
        _birthDay = null;
        _birthDate = null;
        return;
      }
      _birthDate = DateTime(_birthYear!, _birthMonth!, _birthDay!);
    } else {
      _birthDate = null;
    }
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📅 Date du guide',
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sélectionnez la date pour laquelle vous souhaitez consulter votre guide horaire.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        _buildDateDropdowns(),
      ],
    );
  }

  /// Dropdowns de date style Compatibilité
  Widget _buildDateDropdowns() {
    final years = List<int>.generate(1136, (i) => 1900 + i); // 1900 → 3035
    final months = const [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxDay = _daysInMonth(_targetYear, _targetMonth);
    final days = List<int>.generate(maxDay, (i) => i + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Année'),
                  value: _targetYear,
                  items: years
                      .map((y) => DropdownMenuItem<int>(
                            value: y,
                            child: Text('$y'),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _targetYear = val;
                      _updateTargetDate();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Mois'),
                  value: _targetMonth,
                  items: List.generate(
                    months.length,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(months[index]),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _targetMonth = val;
                      _updateTargetDate();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Jour'),
                  value: _targetDay != null && _targetDay! <= maxDay ? _targetDay : null,
                  items: days
                      .map((d) => DropdownMenuItem<int>(
                            value: d,
                            child: Text('$d'),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _targetDay = val;
                      _updateTargetDate();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _daysInMonth(int? year, int? month) {
    if (year == null || month == null) return 31;
    final beginningNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    final lastDayCurrentMonth = beginningNextMonth.subtract(const Duration(days: 1)).day;
    return lastDayCurrentMonth;
  }

  void _updateTargetDate() {
    if (_targetYear != null && _targetMonth != null && _targetDay != null) {
      final maxDay = _daysInMonth(_targetYear, _targetMonth);
      if (_targetDay! > maxDay) {
        _targetDay = null;
        _targetDate = null;
        return;
      }
      _targetDate = DateTime(_targetYear!, _targetMonth!, _targetDay!);
    } else {
      _targetDate = null;
    }
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
          _buildPaymentOption(
            PaymentProvider.kkiapay,
            'Kkiapay',
            'Cartes, Mobile Money (MTN, Moov, etc.)',
            Icons.credit_card,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            PaymentProvider.fedapay,
            'FedaPay',
            'Cartes bancaires, Mobile Money',
            Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(PaymentProvider provider, String name, String description, IconData icon) {
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
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    final canPay = _targetDate != null && _birthDate != null && _firstNameController.text.trim().isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing || !canPay ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: _isProcessing
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
                      ? 'Payer ${CurrencyService.instance.formatAmount(widget.plan.priceFcfa)}'
                      : 'Sélectionnez une date',
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
    if (_targetDate == null || _birthDate == null || _firstNameController.text.trim().isEmpty) {
      setState(() => _error = 'Veuillez remplir tous les champs (prénom, date de naissance, date du guide).');
      return;
    }

    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() => _error = 'Veuillez vous connecter pour continuer.');
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      // Créer le produit pour le paiement
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? 'Guide Horaire Quotidien',
        priceFcfa: widget.plan.priceFcfa,
      );

      // Lancer le paiement via PaymentManager
      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedProvider,
        customerEmail: user.email,
        callback: (success, purchase, error) async {
          debugPrint('>>> Daily Guide payment callback: success=$success, error=$error');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            debugPrint('>>> Payment success, creating daily guide purchase...');
            
            try {
              // Créer l'achat du guide
              await DailyGuideService.instance.createPurchase(
                paymentId: purchase.id,
                targetDate: _targetDate!,
              );
              
              if (!mounted) return;
              
              // Naviguer vers l'écran de rapport
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DailyGuideReportScreen(
                    targetDate: _targetDate!,
                    firstName: _firstNameController.text.trim(),
                    birthDate: _birthDate!,
                  ),
                ),
              );
            } catch (e) {
              debugPrint('>>> Error creating purchase record: $e');
              if (mounted) {
                // Même en cas d'erreur d'enregistrement, naviguer vers le rapport
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => DailyGuideReportScreen(
                      targetDate: _targetDate!,
                      firstName: _firstNameController.text.trim(),
                      birthDate: _birthDate!,
                    ),
                  ),
                );
              }
            }
          } else {
            setState(() {
              _isProcessing = false;
              _error = error ?? 'Erreur lors du paiement';
            });
          }
        },
      );
    } catch (e) {
      debugPrint('>>> Error initiating payment: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _error = 'Erreur: ${e.toString()}';
        });
      }
    }
  }
}
