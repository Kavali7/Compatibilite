/// Decision Advice Screen
/// Écran d'analyse des décisions avec conseils mystiques
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../models/stored_report_model.dart';
import '../services/cycles_vie_service.dart';
import '../services/daily_guide_service.dart';
import '../services/decision_credit_service.dart';
import '../services/auth_service.dart';
import '../services/stored_report_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/credit_pack_purchase_modal.dart';

/// Écran d'analyse des décisions basé sur les cycles
class DecisionAdviceScreen extends StatefulWidget {
  final DateTime birthdate;
  final DateTime targetDate;
  final String? initialDecisionTypeId;
  final int currentPeriodNumber;
  final String cycleType;
  final String? purchaseId; // ID de l'achat pour lier les crédits

  const DecisionAdviceScreen({
    super.key,
    required this.birthdate,
    required this.targetDate,
    this.initialDecisionTypeId,
    required this.currentPeriodNumber,
    this.cycleType = 'personal',
    this.purchaseId,
  });

  @override
  State<DecisionAdviceScreen> createState() => _DecisionAdviceScreenState();
}

class _DecisionAdviceScreenState extends State<DecisionAdviceScreen>
    with SingleTickerProviderStateMixin {
  final CyclesVieService _cyclesService = CyclesVieService();
  final DecisionCreditService _creditService = DecisionCreditService();

  List<DecisionType> _decisionTypes = [];
  String? _selectedDecisionTypeId;
  DecisionAdvice? _currentAdvice;
  bool _isLoading = true;
  bool _isLoadingAdvice = false;
  String? _error;

  // Système de crédits
  CreditBalance? _creditBalance;
  Set<String> _unlockedTypeIds = {}; // Types déjà débloqués

  // Créneaux quotidiens (7 périodes de 3h25)
  List<DailyPeriodWithSlot>? _dailyPeriods;
  DailyPeriodWithSlot? _currentDailyPeriod;

  late AnimationController _gaugeController;
  late Animation<double> _gaugeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDecisionTypeId = widget.initialDecisionTypeId;

    _gaugeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _gaugeAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _gaugeController, curve: Curves.easeOutCubic),
    );

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    
    // Charger les crédits, types et créneaux quotidiens en parallèle
    await Future.wait([
      _loadCreditBalance(),
      _loadDecisionTypesOnly(),
      _loadDailyPeriods(),
    ]);
    
    // Charger le conseil après que crédits et types soient prêts
    if (_decisionTypes.isNotEmpty) {
      // Si initialDecisionTypeId est un code (pas un UUID), le résoudre
      if (_selectedDecisionTypeId != null && !_isUuid(_selectedDecisionTypeId!)) {
        final typeByCode = _decisionTypes.firstWhere(
          (t) => t.code == _selectedDecisionTypeId,
          orElse: () => _decisionTypes.first,
        );
        _selectedDecisionTypeId = typeByCode.id;
      } else if (_selectedDecisionTypeId == null) {
        _selectedDecisionTypeId = _decisionTypes.first.id;
      }
      await _loadAdvice();
    } else {
      // Aucun type chargé - utiliser des types par défaut en mode gracieux
      debugPrint('>>> Aucun type de décision chargé - mode gracieux');
      _error = 'Les types de décision ne sont pas disponibles. Veuillez réessayer.';
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
  
  /// Vérifie si une chaîne est un UUID valide
  bool _isUuid(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    );
    return uuidRegex.hasMatch(value);
  }

  Future<void> _loadCreditBalance() async {
    try {
      _creditBalance = await _creditService.getCreditBalance();
      // Charger les types déjà utilisés
      final usage = await _creditService.getUsageHistory(limit: 100);
      _unlockedTypeIds = usage.map((u) => u.decisionTypeId).toSet();
    } catch (e) {
      debugPrint('Erreur chargement crédits: $e');
      // En cas d'erreur, permettre l'accès (grace mode)
      _creditBalance = CreditBalance.unlimited();
    }
  }

  @override
  void dispose() {
    _gaugeController.dispose();
    super.dispose();
  }

  Future<void> _loadDecisionTypesOnly() async {
    try {
      _decisionTypes = await _cyclesService.getDecisionTypes().timeout(
        const Duration(seconds: 5),
        onTimeout: () => <DecisionType>[],
      );
    } catch (e) {
      debugPrint('Erreur chargement types de décision: $e');
      _error = 'Impossible de charger les types de décision';
    }
  }

  /// Vérifie si l'utilisateur peut accéder au conseil
  bool _canAccessAdvice(String typeId) {
    // Type déjà débloqué pendant cette session
    if (_unlockedTypeIds.contains(typeId)) return true;
    
    // Si on vient d'un paiement (purchaseId présent), accès autorisé (crédits attribués)
    if (widget.purchaseId != null && widget.purchaseId!.isNotEmpty) return true;
    
    // Crédits illimités (-1)
    if (_creditBalance != null && _creditBalance!.totalCredits < 0) return true;
    
    // A des crédits disponibles
    if (_creditBalance != null && _creditBalance!.hasCredits) return true;
    
    return false;
  }

  /// Affiche le modal d'achat de crédits
  void _showPurchaseModal() {
    CreditPackPurchaseModal.show(
      context,
      onSuccess: () {
        // Recharger les crédits après achat
        _loadCreditBalance().then((_) {
          if (mounted) setState(() {});
        });
      },
    );
  }

  Future<void> _loadAdvice() async {
    if (_selectedDecisionTypeId == null) return;

    // Vérifier les crédits avant de charger le conseil
    if (!_canAccessAdvice(_selectedDecisionTypeId!)) {
      _showPurchaseModal();
      return;
    }

    setState(() => _isLoadingAdvice = true);

    try {
      _currentAdvice = await _cyclesService.getAdvice(
        decisionTypeId: _selectedDecisionTypeId!,
        cycleType: widget.cycleType,
        periodNumber: widget.currentPeriodNumber,
      );

      // Consommer un crédit si c'est un nouveau type
      if (_currentAdvice != null && !_unlockedTypeIds.contains(_selectedDecisionTypeId!)) {
        final userId = AuthService.instance.currentUser?.id;
        if (userId != null) {
          final result = await _creditService.consumeCredit(
            userId: userId,
            purchaseId: widget.purchaseId ?? '',
            decisionTypeId: _selectedDecisionTypeId!,
            cycleType: widget.cycleType,
            periodNumber: widget.currentPeriodNumber,
            targetDate: widget.targetDate,
          );
          
          if (result.success) {
            _unlockedTypeIds.add(_selectedDecisionTypeId!);
            _creditBalance = result.balance;
            
            // Store report for "Mes Achats" after successful credit consumption
            _storeReportForHistory();
          }
        } else {
          // Pas connecté, débloquer quand même (grace mode)
          _unlockedTypeIds.add(_selectedDecisionTypeId!);
        }
      }

      // Animer la jauge (score 0-100 → 0.0–1.0)
      if (_currentAdvice != null && _currentAdvice!.favorabilityScore != null) {
        _gaugeAnimation = Tween<double>(
          begin: 0,
          end: _currentAdvice!.favorabilityScore! / 100.0,
        ).animate(
          CurvedAnimation(parent: _gaugeController, curve: Curves.easeOutCubic),
        );
        _gaugeController.forward(from: 0);
      }
    } catch (e) {
      debugPrint('Erreur chargement conseil: $e');
    }

    if (mounted) {
      setState(() => _isLoadingAdvice = false);
    }
  }

  /// Store the report for "Mes Achats" feature
  void _storeReportForHistory() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null || _currentAdvice == null) return;

      // Find the decision type label
      final decisionType = _decisionTypes.firstWhere(
        (dt) => dt.id == _selectedDecisionTypeId,
        orElse: () => _decisionTypes.first,
      );

      // Prepare report data
      final reportData = <String, dynamic>{
        'decision_type_id': _selectedDecisionTypeId,
        'decision_type_label': decisionType.label,
        'cycle_type': widget.cycleType,
        'period_number': widget.currentPeriodNumber,
        'target_date': widget.targetDate.toIso8601String(),
        'favorability_score': _currentAdvice!.favorabilityScore,
        'advice_text': _currentAdvice!.adviceText,
        'cosmic_context': _currentAdvice!.cosmicContext,
        'recommended_actions': _currentAdvice!.recommendedActions,
        'optimal_timing': _currentAdvice!.optimalTiming,
        'warnings': _currentAdvice!.warnings,
        'stored_at': DateTime.now().toIso8601String(),
      };

      await StoredReportService.instance.storeCyclesVieReport(
        userId: user.id,
        serviceType: StoredReport.typeEclairageDecision,
        userName: decisionType.label,
        birthDate: widget.birthdate,
        targetDate: widget.targetDate,
        reportData: reportData,
      );

      debugPrint('✅ Decision Advice report stored for Mes Achats');
    } catch (e) {
      debugPrint('⚠️ Error storing Decision Advice report: $e');
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
          'Analyse de Décision',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 25,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _error != null
                ? _buildErrorView()
                : _buildContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadInitialData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête avec icône mystique
          _buildHeader(),
          const SizedBox(height: 24),

          // Sélecteur de type de décision
          _buildDecisionTypeSelector(),
          const SizedBox(height: 24),

          // Contenu du conseil
          if (_isLoadingAdvice)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (_currentAdvice != null)
            _buildAdviceContent()
          else
            _buildNoAdviceMessage(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conseil Mystique',
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lecture personnalisée selon votre thème astral',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionTypeSelector() {
    // Find description for the selected type
    String? selectedDescription;
    if (_selectedDecisionTypeId != null && _decisionTypes.isNotEmpty) {
      try {
        final selected = _decisionTypes.firstWhere(
          (dt) => dt.id == _selectedDecisionTypeId,
        );
        selectedDescription = selected.detailedDescription ?? selected.description;
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
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
              Icon(Icons.help_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Quelle décision analyser ?',
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedDecisionTypeId,
            dropdownColor: AppColors.block,
            style: const TextStyle(color: AppColors.textLight),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            items: _decisionTypes.map((dt) {
              return DropdownMenuItem<String>(
                value: dt.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForDecisionType(dt.code),
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        dt.label,
                        style: const TextStyle(color: AppColors.textLight),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedDecisionTypeId = value);
              _loadAdvice();
            },
          ),
          // Description du type sélectionné
          if (_selectedDecisionTypeId != null && selectedDescription != null && selectedDescription.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary, size: 16),
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
                    selectedDescription,
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
      ),
    );
  }

  IconData _getIconForDecisionType(String code) {
    switch (code) {
      case 'location_immobilier':
      case 'achat_immobilier':
        return Icons.home;
      case 'demenagement':
        return Icons.local_shipping;
      case 'achat_vehicule':
        return Icons.directions_car;
      case 'achat_important':
        return Icons.shopping_cart;
      case 'demande_financement':
      case 'recherche_argent':
        return Icons.account_balance;
      case 'investissement':
        return Icons.trending_up;
      case 'signature_contrat':
        return Icons.description;
      case 'lancement_business':
        return Icons.rocket_launch;
      case 'partenariat':
        return Icons.handshake;
      case 'entretien_embauche':
        return Icons.work;
      case 'demande_promotion':
        return Icons.arrow_upward;
      case 'demission':
        return Icons.exit_to_app;
      case 'voyage':
        return Icons.flight;
      case 'mariage':
        return Icons.favorite;
      case 'debut_relation':
        return Icons.people;
      case 'operation_medicale':
        return Icons.local_hospital;
      case 'debut_traitement':
        return Icons.medical_services;
      case 'construction_renovation':
        return Icons.construction;
      case 'negociation_accord':
        return Icons.gavel;
      case 'campagne_pub':
        return Icons.campaign;
      case 'vente_bien':
        return Icons.sell;
      case 'inscription_formation':
        return Icons.school;
      case 'changement_habitudes':
        return Icons.fitness_center;
      case 'pelerinage_retraite':
        return Icons.self_improvement;
      case 'autre':
        return Icons.help_outline;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildAdviceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Jauge de favorabilité
        _buildFavorabilityGauge(),
        const SizedBox(height: 24),

        // Contexte cosmique si présent
        if (_currentAdvice!.cosmicContext != null &&
            _currentAdvice!.cosmicContext!.isNotEmpty)
          _buildCosmicContextCard(),

        // Conseil principal
        _buildAdviceCard(),
        const SizedBox(height: 16),

        // Actions recommandées si présentes
        if (_currentAdvice!.recommendedActions != null &&
            _currentAdvice!.recommendedActions!.isNotEmpty)
          _buildActionsCard(),

        // Timing optimal si présent
        if (_currentAdvice!.optimalTiming != null &&
            _currentAdvice!.optimalTiming!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTimingCard(),
        ],

        // Warnings si présents
        if (_currentAdvice!.warnings != null &&
            _currentAdvice!.warnings!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildWarningCard(),
        ],

        // Pièges à éviter si présents
        if (_currentAdvice!.pitfallsToAvoid != null &&
            _currentAdvice!.pitfallsToAvoid!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildPitfallsCard(),
        ],

        // Alternatives si présentes
        if (_currentAdvice!.alternativesSuggestion != null &&
            _currentAdvice!.alternativesSuggestion!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildAlternativesCard(),
        ],

        // Message de conclusion si présent
        if (_currentAdvice!.closingMessage != null &&
            _currentAdvice!.closingMessage!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildClosingMessageCard(),
        ],

        // Section créneaux quotidiens (7 périodes de 3h25)
        if (_dailyPeriods != null && _dailyPeriods!.isNotEmpty) ...[
          const SizedBox(height: 28),
          _buildDailyPeriodsSection(),
        ],
      ],
    );
  }

  Widget _buildCosmicContextCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.15),
            Colors.indigo.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.stars, color: Colors.purple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contexte Cosmique',
                  style: GoogleFonts.philosopher(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentAdvice!.cosmicContext!,
                  style: GoogleFonts.philosopher(
                    color: AppColors.textLight,
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Text(
                'Actions Recommandées',
                style: GoogleFonts.philosopher(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentAdvice!.recommendedActions!,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.schedule, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Timing Optimal',
                  style: GoogleFonts.philosopher(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentAdvice!.optimalTiming!,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPitfallsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dangerous_outlined, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Text(
                'Pièges à Éviter',
                style: GoogleFonts.philosopher(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentAdvice!.pitfallsToAvoid!,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosingMessageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.15),
            Colors.amber.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 32),
          const SizedBox(height: 12),
          Text(
            _currentAdvice!.closingMessage!,
            style: GoogleFonts.philosopher(
              fontSize: 16,
              height: 1.5,
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Charge les 7 créneaux quotidiens pour la date cible
  Future<void> _loadDailyPeriods() async {
    try {
      _dailyPeriods = await DailyGuideService.instance.getPeriodsForDate(widget.targetDate);
      _currentDailyPeriod = await DailyGuideService.instance.getCurrentPeriodForDate(widget.targetDate);
    } catch (e) {
      debugPrint('⏰ Erreur chargement créneaux quotidiens: $e');
    }
  }

  /// Section des 7 créneaux quotidiens intégrée au rapport décision
  Widget _buildDailyPeriodsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.schedule, color: Color(0xFF0284C7), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Créneaux du jour',
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    Text(
                      'Vos influences cosmiques du jour',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info contextuelle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: const Color(0xFF0284C7), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Les astres influencent votre journée par vagues successives. '
                    'Découvrez les moments clés et leurs énergies.',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Liste des 7 créneaux
          ...(_dailyPeriods ?? []).map((pws) => _buildDailyPeriodItem(pws)),
        ],
      ),
    );
  }

  Widget _buildDailyPeriodItem(DailyPeriodWithSlot pws) {
    final isCurrent = _currentDailyPeriod?.periodNumber == pws.periodNumber;
    final periodColor = const Color(0xFF0284C7);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent
            ? periodColor.withValues(alpha: 0.15)
            : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? periodColor : AppColors.textMuted.withValues(alpha: 0.15),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête créneau
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrent ? periodColor : AppColors.block,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${pws.periodNumber}',
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : periodColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pws.periodName,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: periodColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'EN COURS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pws.timeSlotLabel}  •  ${pws.keyword}',
                      style: TextStyle(
                        color: isCurrent ? periodColor : AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Activités favorables/défavorables (compact)
          if (pws.favorablesList.isNotEmpty || pws.eviterList.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...pws.favorablesList.take(3).map((a) => _buildMiniActivityChip(a, Colors.green, Icons.check_circle)),
                ...pws.eviterList.take(2).map((a) => _buildMiniActivityChip(a, Colors.red.shade300, Icons.cancel)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniActivityChip(String text, Color color, IconData icon) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textLight, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavorabilityGauge() {
    final score = _currentAdvice?.favorabilityScore ?? 0;
    final color = _getFavorabilityColor(score);
    final label = _getFavorabilityLabel(score);


    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Score de Favorabilité',
            style: GoogleFonts.philosopher(
              fontSize: 16,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _gaugeAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: _gaugeAnimation.value,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score%',
                        style: GoogleFonts.philosopher(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getFavorabilityColor(int score) {
    // Score DB: 0-100
    if (score >= 80) return Colors.green;
    if (score >= 65) return Colors.lightGreen;
    if (score >= 50) return Colors.orange;
    if (score >= 35) return Colors.deepOrange;
    if (score > 0) return Colors.red;
    return Colors.grey;
  }

  String _getFavorabilityLabel(int score) {
    // Score DB: 0-100
    if (score >= 80) return 'Très Favorable';
    if (score >= 65) return 'Favorable';
    if (score >= 50) return 'Neutre';
    if (score >= 35) return 'Défavorable';
    if (score > 0) return 'À Éviter';
    return 'Non évalué';
  }

  Widget _buildAdviceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
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
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Conseil Mystique',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currentAdvice!.adviceText,
            style: GoogleFonts.philosopher(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attention',
                  style: GoogleFonts.philosopher(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentAdvice!.warnings!,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.teal.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.teal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alternative suggérée',
                  style: GoogleFonts.philosopher(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentAdvice!.alternativesSuggestion!,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAdviceMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textMuted,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun conseil disponible',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les conseils pour cette combinaison de cycle et période ne sont pas encore disponibles.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
