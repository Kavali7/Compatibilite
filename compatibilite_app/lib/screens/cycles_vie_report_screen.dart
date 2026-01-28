/// Cycles de Vie Report Screen
/// Écran d'affichage du rapport personnalisé
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../services/cycles_vie_service.dart';
import '../widgets/animated_background.dart';
import 'decision_advice_screen.dart';

/// Écran de visualisation du rapport Cycles de Vie
class CyclesVieReportScreen extends StatefulWidget {
  final String serviceType;
  final DateTime? birthdate;
  final DateTime targetDate;
  final String? decisionTypeId;

  const CyclesVieReportScreen({
    super.key,
    required this.serviceType,
    this.birthdate,
    required this.targetDate,
    this.decisionTypeId,
  });

  @override
  State<CyclesVieReportScreen> createState() => _CyclesVieReportScreenState();
}

class _CyclesVieReportScreenState extends State<CyclesVieReportScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  
  ExpressReport? _report;
  bool _isLoading = true;
  String? _error;

  /// Vérifie si c'est un rapport détaillé (tous sauf 'express')
  /// Un rapport est détaillé s'il n'est PAS express
  bool get _isDetailedReport {
    final type = widget.serviceType.toLowerCase();
    // Seul 'express' est un rapport simple, tous les autres sont détaillés
    return type != 'express' && type != 'cycles_vie_express';
  }

  /// Titre du rapport selon le type
  String get _reportTitle {
    final type = widget.serviceType.toLowerCase();
    
    // Rapports Express
    if (type == 'express' || type == 'cycles_vie_express') {
      return 'Rapport Express';
    }
    
    // Rapports Consultation/Stratégique
    if (type == 'consultation' || type == 'strategique' || 
        type == 'cycles_vie_consultation') {
      return 'Consultation Complète';
    }
    
    // Rapports Abonnement
    if (type == 'abonnement' || type == 'subscription' || 
        type == 'cycles_vie_abonnement') {
      return 'Rapport Abonné';
    }
    
    // Par défaut - rapport complet
    return 'Votre Rapport Complet';
  }


  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('📊 Génération du rapport express...');
      debugPrint('📅 Birthdate: ${widget.birthdate}');
      debugPrint('📅 TargetDate: ${widget.targetDate}');
      
      // Timeout pour éviter chargement infini
      _report = await _cyclesService.generateExpressReport(
        birthdate: widget.birthdate ?? DateTime.now(),
        targetDate: widget.targetDate,
      ).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('⏱️ Timeout: génération rapport');
          throw Exception('Délai dépassé');
        },
      );
      
      debugPrint('✅ Rapport généré avec succès');
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur génération rapport: $e');
      debugPrint('📚 Stack: $stackTrace');
      _error = 'Impossible de charger le rapport. Vérifiez votre connexion.';
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
          _reportTitle,
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textLight),
            onPressed: () => _shareReport(),
          ),
        ],
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 30,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _error != null
                ? _buildErrorView()
                : _buildReportContent(),
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
              onPressed: _loadReport,
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

  Widget _buildReportContent() {
    if (_report == null) {
      return _buildErrorView();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date
          _buildDateHeader(),
          const SizedBox(height: 24),

          // Soul Period Card
          if (_report!.soulPeriod != null) ...[
            _buildSoulPeriodCard(),
            const SizedBox(height: 20),
          ],

          // Daily Schedule Card
          if (_report!.daySchedule.isNotEmpty) ...[
            _buildDayScheduleCard(),
            const SizedBox(height: 20),
          ],

          // Current Period Card
          if (_report!.currentPeriod != null) ...[
            _buildCurrentPeriodCard(),
            const SizedBox(height: 20),
          ],

          // Decision Advice Button
          _buildDecisionAdviceButton(),
          const SizedBox(height: 20),

          // Cross-promotion
          _buildCrossPromotionCard(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date analysée',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(widget.targetDate),
                  style: GoogleFonts.philosopher(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoulPeriodCard() {
    final sp = _report!.soulPeriod!;
    
    return _buildReportCard(
      icon: Icons.auto_awesome,
      iconColor: Colors.purple,
      title: 'Période Soul',
      subtitle: sp.periodTitle,
      children: [
        Text(
          sp.descriptionGeneral,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        if (sp.traitsPositifs != null && sp.traitsPositifs!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '✨ Traits Positifs',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sp.traitsPositifs!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        // === SECTIONS DETAILLEES (consultation/abonnement uniquement) ===
        // Traits de Vigilance
        if (sp.traitsVigilance != null && sp.traitsVigilance!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '⚠️ Points de Vigilance',
            style: GoogleFonts.philosopher(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Text(
              sp.traitsVigilance!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        // Professions Favorables
        if (sp.professionsFavorables != null && sp.professionsFavorables!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '💼 Professions Favorables',
            style: GoogleFonts.philosopher(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sp.professionsFavorables!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        // Santé Vigilance
        if (sp.santeVigilance != null && sp.santeVigilance!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '🏥 Vigilance Santé',
            style: GoogleFonts.philosopher(
              color: const Color(0xFF10B981),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sp.santeVigilance!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        // Pays Affinités
        if (sp.paysAffinites != null && sp.paysAffinites!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '🌍 Pays d\'Affinités',
            style: GoogleFonts.philosopher(
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sp.paysAffinites!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDayScheduleCard() {
    final schedule = _report!.daySchedule;
    
    return _buildReportCard(
      icon: Icons.schedule,
      iconColor: Colors.orange,
      title: 'Planning du Jour',
      subtitle: '${schedule.length} périodes',
      children: [
        ...schedule.map((item) => _buildDayPeriodItem(item)),
      ],
    );
  }

  /// Construit un élément de période avec tout le contenu
  Widget _buildDayPeriodItem(DailyPeriodWithTime item) {
    final period = item.period;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isCurrentPeriod 
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isCurrentPeriod 
                ? AppColors.primary 
                : period.color.withValues(alpha: 0.5),
            width: item.isCurrentPeriod ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Lettre + Nom + Horaires + Badge Actuel
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: period.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    period.periodLetter,
                    style: TextStyle(
                      color: period.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                          Text(
                            period.periodName,
                            style: GoogleFonts.philosopher(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (period.keyword.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              '• ${period.keyword}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${item.startTime} - ${item.endTime}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          if (period.energyLevel != null) ...[
                            const SizedBox(width: 12),
                            _buildEnergyBadge(period.energyLevel!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (item.isCurrentPeriod)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Actuel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            // Description
            if (period.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                period.description,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
            
            // Activités favorables
            if (period.activitesFavorables != null && period.activitesFavorables!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✅', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        period.activitesFavorables!,
                        style: TextStyle(
                          color: const Color(0xFF10B981),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Activités à éviter
            if (period.activitesEviter != null && period.activitesEviter!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        period.activitesEviter!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Badge niveau d'énergie
  Widget _buildEnergyBadge(String level) {
    String emoji;
    Color color;
    
    switch (level.toLowerCase()) {
      case 'high':
        emoji = '🔥';
        color = const Color(0xFFEF4444);
        break;
      case 'medium':
        emoji = '⚡';
        color = const Color(0xFFF59E0B);
        break;
      case 'low':
        emoji = '🧘';
        color = const Color(0xFF8B5CF6);
        break;
      default:
        emoji = '➖';
        color = AppColors.textMuted;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }


  Widget _buildCurrentPeriodCard() {
    final cp = _report!.currentPeriod!;
    
    return _buildReportCard(
      icon: Icons.trending_up,
      iconColor: Colors.teal,
      title: 'Cycle Actuel',
      subtitle: '${cp.periodLetter} - ${cp.periodName}',
      children: [
        // Mot-clé
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cp.keyword,
                  style: GoogleFonts.philosopher(
                    color: AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Description complète
        if (cp.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            cp.description,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
        
        // Activités favorables
        if (cp.activitesFavorables != null && cp.activitesFavorables!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '✅ Activités Favorables',
            style: GoogleFonts.philosopher(
              color: const Color(0xFF10B981),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              cp.activitesFavorables!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        
        // Activités à éviter
        if (cp.activitesEviter != null && cp.activitesEviter!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '⚠️ À Éviter',
            style: GoogleFonts.philosopher(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Text(
              cp.activitesEviter!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.textMuted, height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDecisionAdviceButton() {
    // Déterminer le numéro de période actuelle
    int currentPeriodNumber = 1;
    if (_report?.soulPeriod != null) {
      currentPeriodNumber = _report!.soulPeriod!.periodNumber;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            Colors.purple.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology, color: Colors.purple, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analyse de Décision',
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Obtenez des conseils mystiques personnalisés',
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DecisionAdviceScreen(
                      birthdate: widget.birthdate ?? DateTime.now(),
                      targetDate: widget.targetDate,
                      initialDecisionTypeId: widget.decisionTypeId,
                      currentPeriodNumber: currentPeriodNumber,
                      cycleType: 'personal',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: const Text('Analyser une Décision'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossPromotionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 24),
              const SizedBox(width: 12),
              Text(
                'Découvrez aussi',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Faites l\'analyse de compatibilité amoureuse pour révéler le potentiel de votre relation !',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Retour à l\'accueil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de partage bientôt disponible'),
        backgroundColor: AppColors.block,
      ),
    );
  }
}
