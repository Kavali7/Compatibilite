/// Cycles de Vie Purchase Screen
/// Écran d'achat pour les services Cycles de Vie
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../services/cycles_vie_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../widgets/animated_background.dart';
import 'cycles_vie_report_screen.dart';

/// Écran d'achat d'un service Cycles de Vie
class CyclesViePurchaseScreen extends StatefulWidget {
  final String planType;
  final PricingPlan plan;

  const CyclesViePurchaseScreen({
    super.key,
    required this.planType,
    required this.plan,
  });

  @override
  State<CyclesViePurchaseScreen> createState() => _CyclesViePurchaseScreenState();
}

class _CyclesViePurchaseScreenState extends State<CyclesViePurchaseScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Champs du formulaire
  final TextEditingController _firstNameController = TextEditingController();
  
  // Date de naissance - composants
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthdate;
  
  // Date de consultation - composants
  int? _consultYear;
  int? _consultMonth;
  int? _consultDay;
  DateTime? _consultationDate;
  
  String? _selectedDecisionType;
  
  List<DecisionType> _decisionTypes = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _error;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;

  @override
  void initState() {
    super.initState();
    _loadDecisionTypes();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  Future<void> _loadDecisionTypes() async {
    setState(() => _isLoading = true);
    
    try {
      // Timeout pour éviter chargement infini
      _decisionTypes = await _cyclesService.getDecisionTypes().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Timeout: utilisation de types par défaut');
          return <DecisionType>[];
        },
      );
    } catch (e) {
      debugPrint('Erreur chargement types: $e');
      // Continue avec liste vide
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
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
          widget.plan.name,
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildContent(),
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
        _buildDateDropdowns(
          label: 'Date de naissance',
          icon: Icons.cake,
          selectedYear: _birthYear,
          selectedMonth: _birthMonth,
          selectedDay: _birthDay,
          isPastDate: true,
          onYearChanged: (val) => setState(() {
            _birthYear = val;
            _updateBirthdate();
          }),
          onMonthChanged: (val) => setState(() {
            _birthMonth = val;
            _updateBirthdate();
          }),
          onDayChanged: (val) => setState(() {
            _birthDay = val;
            _updateBirthdate();
          }),
        ),
        const SizedBox(height: 16),

        // Date de consultation (dropdowns)
        _buildDateDropdowns(
          label: 'Date de consultation',
          icon: Icons.calendar_today,
          selectedYear: _consultYear,
          selectedMonth: _consultMonth,
          selectedDay: _consultDay,
          isPastDate: false,
          onYearChanged: (val) => setState(() {
            _consultYear = val;
            _updateConsultDate();
          }),
          onMonthChanged: (val) => setState(() {
            _consultMonth = val;
            _updateConsultDate();
          }),
          onDayChanged: (val) => setState(() {
            _consultDay = val;
            _updateConsultDate();
          }),
        ),
        const SizedBox(height: 16),

        // Type de décision
        _buildDecisionTypeDropdown(),
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

  /// Met à jour la date de consultation complète
  void _updateConsultDate() {
    if (_consultYear != null && _consultMonth != null && _consultDay != null) {
      final maxDay = _daysInMonth(_consultYear, _consultMonth);
      if (_consultDay! > maxDay) {
        _consultDay = null;
        _consultationDate = null;
        return;
      }
      _consultationDate = DateTime(_consultYear!, _consultMonth!, _consultDay!);
    } else {
      _consultationDate = null;
    }
  }

  Widget _buildDateDropdowns({
    required String label,
    required IconData icon,
    required int? selectedYear,
    required int? selectedMonth,
    required int? selectedDay,
    required bool isPastDate,
    required ValueChanged<int?> onYearChanged,
    required ValueChanged<int?> onMonthChanged,
    required ValueChanged<int?> onDayChanged,
  }) {
    final now = DateTime.now();
    final years = isPastDate
        ? List<int>.generate(now.year - 1919, (i) => 1920 + i).reversed.toList()
        : List<int>.generate(6, (i) => now.year + i);
    final months = const [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxDay = _daysInMonth(selectedYear, selectedMonth);
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
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
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
            value: selectedYear,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: years.map((y) => DropdownMenuItem<int>(
              value: y,
              child: Text('$y'),
            )).toList(),
            onChanged: onYearChanged,
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
            value: selectedMonth,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: List.generate(
              months.length,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text(months[index]),
              ),
            ),
            onChanged: onMonthChanged,
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
            value: selectedDay != null && selectedDay <= maxDay ? selectedDay : null,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            items: days.map((d) => DropdownMenuItem<int>(
              value: d,
              child: Text('$d'),
            )).toList(),
            onChanged: onDayChanged,
          ),
        ],
      ),
    );
  }



  Widget _buildDecisionTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedDecisionType,
        dropdownColor: AppColors.block,
        style: const TextStyle(color: AppColors.textLight),
        decoration: const InputDecoration(
          labelText: 'Type de décision',
          labelStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(Icons.psychology, color: AppColors.primary),
          border: InputBorder.none,
        ),
        items: _decisionTypes.map((dt) {
          return DropdownMenuItem(
            value: dt.id,
            child: Text(
              dt.label,
              style: const TextStyle(color: AppColors.textLight),
            ),
          );
        }).toList(),
        onChanged: (v) => setState(() => _selectedDecisionType = v),
        validator: (v) => v == null ? 'Veuillez sélectionner un type' : null,
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

  Future<void> _selectDate({required bool isConsultation}) async {
    final now = DateTime.now();
    final initial = isConsultation 
        ? (_consultationDate ?? now)
        : (_birthdate ?? DateTime(now.year - 30));
    
    final first = isConsultation ? now : DateTime(1900);
    final last = isConsultation ? DateTime(now.year + 2) : now;
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.block,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isConsultation) {
          _consultationDate = picked;
        } else {
          _birthdate = picked;
        }
      });
    }
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
      setState(() => _error = 'Veuillez sélectionner votre date de naissance');
      return;
    }
    
    if (_consultationDate == null) {
      setState(() => _error = 'Veuillez sélectionner une date de consultation');
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
          debugPrint('>>> Cycles de Vie payment callback: success=$success, error=$error');
          
          if (!mounted) return;
          
          setState(() => _isProcessing = false);
          
          if (success) {
            debugPrint('>>> Payment success, navigating to report...');
            // Naviguer directement vers le rapport (sans créer de purchase séparé)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CyclesVieReportScreen(
                  serviceType: widget.planType,
                  birthdate: _birthdate,
                  targetDate: _consultationDate!,
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
