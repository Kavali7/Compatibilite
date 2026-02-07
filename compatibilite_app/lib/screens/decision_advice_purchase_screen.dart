/// Decision Advice Purchase Screen (Service 06)
/// Écran d'achat du service Éclairage Décision
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../services/decision_credit_service.dart';
import '../widgets/animated_background.dart';
import 'decision_advice_screen.dart';

/// Écran d'achat pour le service Éclairage Décision
class DecisionAdvicePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const DecisionAdvicePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<DecisionAdvicePurchaseScreen> createState() => _DecisionAdvicePurchaseScreenState();
}

class _DecisionAdvicePurchaseScreenState extends State<DecisionAdvicePurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Date de naissance - dropdowns séparés
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthdate;
  
  // Date cible de la décision - dropdowns séparés
  int? _targetYear;
  int? _targetMonth;
  int? _targetDay;
  DateTime _targetDate = DateTime.now();
  
  // Type de décision sélectionné
  String? _selectedDecisionType;
  
  bool _isProcessing = false;
  String? _error;
  
  // Payment provider
  PaymentProvider _selectedProvider = PaymentProvider.kkiapay;
  
  // Liste des types de décision (28 types)
  static const List<Map<String, String>> _decisionTypes = [
    // Immobilier
    {'code': 'location_immobilier', 'label': 'Location immobilière', 'category': 'Immobilier'},
    {'code': 'achat_immobilier', 'label': 'Achat immobilier', 'category': 'Immobilier'},
    {'code': 'demenagement', 'label': 'Déménagement', 'category': 'Immobilier'},
    {'code': 'construction_renovation', 'label': 'Construction / Rénovation', 'category': 'Immobilier'},
    // Finance
    {'code': 'achat_vehicule', 'label': 'Achat véhicule', 'category': 'Finance'},
    {'code': 'achat_important', 'label': 'Achat important', 'category': 'Finance'},
    {'code': 'demande_financement', 'label': 'Demande de financement', 'category': 'Finance'},
    {'code': 'recherche_argent', 'label': 'Recherche d\'argent', 'category': 'Finance'},
    {'code': 'investissement', 'label': 'Investissement', 'category': 'Finance'},
    // Juridique
    {'code': 'signature_contrat', 'label': 'Signature de contrat', 'category': 'Juridique'},
    {'code': 'negociation_accord', 'label': 'Négociation / Accord formel', 'category': 'Juridique'},
    // Business
    {'code': 'lancement_business', 'label': 'Lancement business', 'category': 'Business'},
    {'code': 'partenariat', 'label': 'Partenariat / Association', 'category': 'Business'},
    // Commerce
    {'code': 'campagne_pub', 'label': 'Campagne publicitaire', 'category': 'Commerce'},
    {'code': 'vente_bien', 'label': 'Vente d\'un bien', 'category': 'Commerce'},
    // Carrière
    {'code': 'entretien_embauche', 'label': 'Entretien d\'embauche', 'category': 'Carrière'},
    {'code': 'demande_promotion', 'label': 'Demande de promotion', 'category': 'Carrière'},
    {'code': 'demission', 'label': 'Démission / Changement', 'category': 'Carrière'},
    // Éducation
    {'code': 'inscription_formation', 'label': 'Inscription à formation / école', 'category': 'Éducation'},
    // Personnel
    {'code': 'voyage', 'label': 'Voyage', 'category': 'Personnel'},
    {'code': 'mariage', 'label': 'Mariage / Engagement', 'category': 'Personnel'},
    {'code': 'debut_relation', 'label': 'Début de relation', 'category': 'Personnel'},
    // Santé  
    {'code': 'operation_medicale', 'label': 'Opération médicale', 'category': 'Santé'},
    {'code': 'debut_traitement', 'label': 'Début de traitement', 'category': 'Santé'},
    {'code': 'changement_habitudes', 'label': 'Changement d\'habitudes de vie', 'category': 'Santé'},
    // Spirituel
    {'code': 'pelerinage_retraite', 'label': 'Pèlerinage / Retraite spirituelle', 'category': 'Spirituel'},
    // Autre
    {'code': 'autre', 'label': 'Autre décision importante', 'category': 'Autre'},
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _birthYear = now.year - 30;
    _birthMonth = now.month;
    _birthDay = now.day;
    _updateBirthdate();
    
    // Initialize target date dropdowns to today
    _targetYear = now.year;
    _targetMonth = now.month;
    _targetDay = now.day;
    _updateTargetDate();
  }

  void _updateTargetDate() {
    if (_targetYear != null && _targetMonth != null && _targetDay != null) {
      final maxDay = _daysInMonth(_targetYear, _targetMonth);
      if (_targetDay! > maxDay) {
        _targetDay = maxDay;
      }
      _targetDate = DateTime(_targetYear!, _targetMonth!, _targetDay!);
    }
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

  int get _currentPeriodNumber {
    final age = _currentAge;
    if (age == null) return 1;
    return (age % 7) + 1;
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
          'Éclairage Décision',
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

            _buildDecisionTypesOverview(),
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
          const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            'Éclairage Décision',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Découvrez le meilleur moment pour prendre vos décisions importantes. '
            'Basé sur votre cycle personnel actuel, recevez un conseil personnalisé avec un score de favorabilité.',
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

  Widget _buildDecisionTypesOverview() {
    final categories = [
      ('Immobilier', 4),
      ('Finance', 5),
      ('Juridique', 2),
      ('Business', 2),
      ('Commerce', 2),
      ('Carrière', 3),
      ('Éducation', 1),
      ('Personnel', 3),
      ('Santé', 3),
      ('Spirituel', 1),
      ('Autre', 1),
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
              Icon(Icons.category, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                '28 Types de Décisions',
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
            children: categories.map((c) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${c.$1} (${c.$2})',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Score de favorabilité de 1 à 5, conseils et alternatives',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
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
            '1 consultation = 1 type de décision analysé',
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
          'Vos informations',
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        
        // Date de naissance
        Text(
          'Date de naissance',
          style: GoogleFonts.philosopher(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pour calculer votre période personnelle actuelle',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildDateDropdowns(),
        
        const SizedBox(height: 20),
        
        // Type de décision
        Text(
          'Type de décision',
          style: GoogleFonts.philosopher(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Quelle décision souhaitez-vous analyser ?',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildDecisionTypeDropdown(),
        
        const SizedBox(height: 20),
        
        // Date cible
        Text(
          'Date prévue de la décision',
          style: GoogleFonts.philosopher(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Quand comptez-vous prendre cette décision ?',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildTargetDatePicker(),
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
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: years.map((y) => DropdownMenuItem<int>(value: y, child: Text('$y'))).toList(),
            onChanged: (val) => setState(() { _birthYear = val; _updateBirthdate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Mois'),
            value: _birthMonth,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: List.generate(months.length, (i) => DropdownMenuItem<int>(value: i + 1, child: Text(months[i]))),
            onChanged: (val) => setState(() { _birthMonth = val; _updateBirthdate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Jour'),
            value: _birthDay != null && _birthDay! <= maxDay ? _birthDay : null,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: days.map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(),
            onChanged: (val) => setState(() { _birthDay = val; _updateBirthdate(); }),
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
                    'Vous avez $_currentAge ans → Période $_currentPeriodNumber',
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

  Widget _buildDecisionTypeDropdown() {
    // Trouver la description détaillée du type sélectionné
    String? selectedDescription;
    if (_selectedDecisionType != null) {
      final selected = _decisionTypes.firstWhere(
        (dt) => dt['code'] == _selectedDecisionType,
        orElse: () => {},
      );
      if (selected.isNotEmpty) {
        selectedDescription = selected['description'];
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.block,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Sélectionnez un type',
              border: InputBorder.none,
            ),
            value: _selectedDecisionType,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            isExpanded: true,
            items: _decisionTypes.map((dt) {
              return DropdownMenuItem<String>(
                value: dt['code'],
                child: Text(
                  '${dt['category']} - ${dt['label']}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedDecisionType = val),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner un type de décision';
              }
              return null;
            },
          ),
        ),
        // Description détaillée du type sélectionné
        if (_selectedDecisionType != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Ce que ce type couvre',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  selectedDescription ?? 'Analyse personnalisée de votre cycle pour cette décision.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTargetDatePicker() {
    // Generate years from 1900 to 3035
    final years = List<int>.generate(1136, (i) => 1900 + i);
    const months = [
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
        children: [
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Année'),
            value: _targetYear,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: years.map((y) => DropdownMenuItem<int>(value: y, child: Text('$y'))).toList(),
            onChanged: (val) => setState(() { _targetYear = val; _updateTargetDate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Mois'),
            value: _targetMonth,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: List.generate(months.length, (i) => DropdownMenuItem<int>(value: i + 1, child: Text(months[i]))),
            onChanged: (val) => setState(() { _targetMonth = val; _updateTargetDate(); }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Jour'),
            value: _targetDay != null && _targetDay! <= maxDay ? _targetDay : null,
            dropdownColor: AppColors.block,
            style: TextStyle(color: AppColors.textLight),
            items: days.map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(),
            onChanged: (val) => setState(() { _targetDay = val; _updateTargetDate(); }),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.event, color: AppColors.secondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Date prévue: ${_formatDate(_targetDate)}',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
            'Moyen de paiement',
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
    final canPay = _birthdate != null && _selectedDecisionType != null;
    
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
    
    if (_selectedDecisionType == null) {
      setState(() => _error = 'Veuillez sélectionner un type de décision.');
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
        description: widget.plan.description ?? 'Éclairage Décision',
        priceFcfa: widget.plan.priceFcfa,
      );

      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedProvider,
        customerEmail: user.email,
        callback: (success, purchase, error) async {
          debugPrint('>>> Decision Advice payment callback: success=$success');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            try {
              // Attribuer le crédit pour cette consultation
              await DecisionCreditService().grantCreditsForPurchase(
                userId: user.id,
                purchaseId: purchase.id,
                planType: widget.plan.planType,
              );
              
              if (!mounted) return;
              
              // Naviguer vers l'écran de conseil
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DecisionAdviceScreen(
                    birthdate: _birthdate!,
                    targetDate: _targetDate,
                    initialDecisionTypeId: _selectedDecisionType,
                    currentPeriodNumber: _currentPeriodNumber,
                    cycleType: 'personal',
                    purchaseId: purchase.id,
                  ),
                ),
              );
            } catch (e) {
              debugPrint('>>> Error granting credits: $e');
              if (mounted) {
                // Navigate anyway, the report screen will handle missing credits gracefully
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => DecisionAdviceScreen(
                      birthdate: _birthdate!,
                      targetDate: _targetDate,
                      initialDecisionTypeId: _selectedDecisionType,
                      currentPeriodNumber: _currentPeriodNumber,
                      cycleType: 'personal',
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
