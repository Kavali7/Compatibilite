/// Personal Cycle Report Screen
/// Écran d'affichage du rapport Cycle Personnel (Service 02)
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../models/stored_report_model.dart';
import '../services/auth_service.dart';
import '../services/personal_cycle_service.dart';
import '../services/stored_report_service.dart';
import '../widgets/animated_background.dart';

/// Écran d'affichage du rapport Cycle Personnel
class PersonalCycleReportScreen extends StatefulWidget {
  final String firstName;
  final DateTime birthdate;
  final StoredReport? frozenReport; // For frozen reading from Mes Achats

  const PersonalCycleReportScreen({
    super.key,
    required this.firstName,
    required this.birthdate,
    this.frozenReport,
  });

  @override
  State<PersonalCycleReportScreen> createState() => _PersonalCycleReportScreenState();
}

class _PersonalCycleReportScreenState extends State<PersonalCycleReportScreen> {
  final PersonalCycleService _cycleService = PersonalCycleService.instance;
  
  bool _isLoading = true;
  String? _error;
  CurrentPeriodInfo? _currentPeriod;
  PersonalYearCalendar? _yearCalendar;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // If frozen report provided, use its data instead of loading fresh
    if (widget.frozenReport != null) {
      _loadFromFrozenReport();
      return;
    }
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Charger la période actuelle et le calendrier en parallèle
      final results = await Future.wait([
        _cycleService.getCurrentPeriod(widget.birthdate),
        _cycleService.getYearCalendar(widget.birthdate),
      ]);
      
      if (mounted) {
        setState(() {
          _currentPeriod = results[0] as CurrentPeriodInfo;
          _yearCalendar = results[1] as PersonalYearCalendar;
          _isLoading = false;
        });
        
        // Store report for "Mes Achats" (fire and forget)
        _storeReportForHistory();
      }
    } catch (e) {
      debugPrint('Erreur chargement cycle personnel: $e');
      if (mounted) {
        setState(() {
          _error = 'Impossible de charger votre cycle. Veuillez réessayer.';
          _isLoading = false;
        });
      }
    }
  }

  /// Load data from frozen report (for Mes Achats viewing)
  void _loadFromFrozenReport() {
    final data = widget.frozenReport!.reportData;
    
    try {
      // Parse frozen period data
      _currentPeriod = CurrentPeriodInfo(
        periodNumber: data['period_number'] ?? 1,
        periodName: data['period_name'] ?? 'Période',
        themeCentral: data['theme_central'] ?? '',
        energiePeriode: data['energie_periode'] ?? '',
        periodStartDate: DateTime.tryParse(data['period_start_date'] ?? '') ?? DateTime.now(),
        periodEndDate: DateTime.tryParse(data['period_end_date'] ?? '') ?? DateTime.now(),
        dayInPeriod: data['day_in_period'] ?? 1,
        daysRemaining: data['days_remaining'] ?? 0,
        descriptionTheme: data['description_theme'] ?? '',
        domainesFavorables: Map<String, dynamic>.from(data['domaines_favorables'] ?? {
          'tres_favorables': data['tres_favorables'] ?? [],
          'favorables': data['favorables'] ?? [],
        }),
        domainesEviter: Map<String, dynamic>.from(data['domaines_eviter'] ?? {
          'reporter': data['reporter'] ?? [],
          'attention': data['attention'] ?? [],
        }),
        conseils: List<String>.from(data['conseils'] ?? []),
        affirmation: data['affirmation'] ?? '',
        influenceDecisions: data['influence_decisions'] ?? '',
        enseignement: data['enseignement'] ?? '',
      );
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading frozen report: $e');
      setState(() {
        _error = 'Erreur lors du chargement du rapport';
        _isLoading = false;
      });
    }
  }

  /// Store the report for "Mes Achats" feature
  /// This is a fire-and-forget operation that doesn't block UX
  void _storeReportForHistory() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        debugPrint('_storeReportForHistory: No user logged in');
        return;
      }

      // Check if report already exists to avoid duplicates
      final exists = await StoredReportService.instance.hasStoredReport(
        userId: user.id,
        serviceType: StoredReport.typeCyclePersonnel,
      );

      if (exists) {
        debugPrint('_storeReportForHistory: Report already exists, skipping');
        return;
      }

      // Prepare report data from current period
      final reportData = <String, dynamic>{
        'first_name': widget.firstName,
        'birthdate': widget.birthdate.toIso8601String(),
        if (_currentPeriod != null) ...{
          'period_number': _currentPeriod!.periodNumber,
          'period_name': _currentPeriod!.periodName,
          'theme_central': _currentPeriod!.themeCentral,
          'energie_periode': _currentPeriod!.energiePeriode,
          'period_start_date': _currentPeriod!.periodStartDate.toIso8601String(),
          'period_end_date': _currentPeriod!.periodEndDate.toIso8601String(),
        },
        'stored_at': DateTime.now().toIso8601String(),
      };

      // Store the report
      await StoredReportService.instance.storeCyclePersonnelReport(
        userId: user.id,
        userName: widget.firstName,
        birthDate: widget.birthdate,
        reportData: reportData,
      );

      debugPrint('✅ Cycle Personnel report stored for Mes Achats');
    } catch (e) {
      // Silent error - don't impact user experience
      debugPrint('⚠️ Error storing report (ignored): $e');
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
          onPressed: () => NavigationHelper.goToMenu(context),
        ),
        title: Text(
          'Cycle Personnel',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textLight),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 40,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 20),
            Text(
              'Calcul de votre cycle personnel...',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
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
                style: const TextStyle(color: AppColors.textLight, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentPeriod == null) {
      return const Center(
        child: Text(
          'Aucune donnée disponible',
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      );
    }

    return _buildReport();
  }

  Widget _buildReport() {
    final period = _currentPeriod!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête utilisateur
          _buildUserHeader(),
          const SizedBox(height: 24),

          // Carte principale - Période actuelle
          _buildCurrentPeriodCard(period),
          const SizedBox(height: 20),

          // Calendrier des 7 périodes
          if (_yearCalendar != null)
            _buildYearCalendar(),
          if (_yearCalendar != null)
            const SizedBox(height: 20),

          // ═══════════════════════════════════════════════════════════
          // SECTIONS DE CONTENU
          // ═══════════════════════════════════════════════════════════

          // 1. Énergie de la période
          if (period.energiePeriode.isNotEmpty)
            _buildReportCard(
              icon: Icons.auto_awesome,
              iconColor: Colors.teal,
              title: 'Énergie de la Période',
              children: [
                _buildPersonalizedContent(period.energiePeriode),
              ],
            ),
          if (period.energiePeriode.isNotEmpty)
            const SizedBox(height: 20),

          // 2. Thème central
          if (period.descriptionTheme.isNotEmpty)
            _buildReportCard(
              icon: Icons.center_focus_strong,
              iconColor: Colors.indigo,
              title: 'Thème Central: ${period.themeCentral}',
              children: [
                _buildPersonalizedContent(period.descriptionTheme),
              ],
            ),
          if (period.descriptionTheme.isNotEmpty)
            const SizedBox(height: 20),

          // 3. Domaines favorables
          if (period.tresFavorables.isNotEmpty || period.favorables.isNotEmpty)
            _buildReportCard(
              icon: Icons.thumb_up,
              iconColor: Colors.green,
              title: 'Domaines Favorables',
              children: [
                if (period.tresFavorables.isNotEmpty) ...[
                  _buildSubsectionTitle('✨ Très Favorables', Colors.green),
                  const SizedBox(height: 8),
                  ...period.tresFavorables.map((d) => _buildDomainItem(d, Colors.green)),
                  const SizedBox(height: 16),
                ],
                if (period.favorables.isNotEmpty) ...[
                  _buildSubsectionTitle('👍 Favorables', Colors.green.shade300),
                  const SizedBox(height: 8),
                  ...period.favorables.map((d) => _buildDomainItem(d, Colors.green.shade300)),
                ],
              ],
            ),
          if (period.tresFavorables.isNotEmpty || period.favorables.isNotEmpty)
            const SizedBox(height: 20),

          // 4. Domaines à éviter
          if (period.reporter.isNotEmpty || period.attention.isNotEmpty)
            _buildReportCard(
              icon: Icons.warning_amber,
              iconColor: Colors.orange,
              title: 'Domaines à Éviter',
              children: [
                if (period.reporter.isNotEmpty) ...[
                  _buildSubsectionTitle('⏳ À Reporter si Possible', Colors.orange),
                  const SizedBox(height: 8),
                  ...period.reporter.map((d) => _buildDomainItem(d, Colors.orange)),
                  const SizedBox(height: 16),
                ],
                if (period.attention.isNotEmpty) ...[
                  _buildSubsectionTitle('⚠️ Attention Particulière', Colors.red.shade300),
                  const SizedBox(height: 8),
                  ...period.attention.map((d) => _buildDomainItem(d, Colors.red.shade300)),
                ],
              ],
            ),
          if (period.reporter.isNotEmpty || period.attention.isNotEmpty)
            const SizedBox(height: 20),

          // 5. Conseils pratiques
          if (period.conseils.isNotEmpty)
            _buildReportCard(
              icon: Icons.lightbulb,
              iconColor: Colors.amber,
              title: 'Conseils Pratiques',
              children: [
                ...period.conseils.asMap().entries.map((e) => 
                  _buildNumberedAdvice(e.key + 1, e.value)
                ),
              ],
            ),
          if (period.conseils.isNotEmpty)
            const SizedBox(height: 20),

          // 6. Affirmation - Style spécial
          if (period.affirmation.isNotEmpty)
            _buildAffirmationCard(period.affirmation),
          if (period.affirmation.isNotEmpty)
            const SizedBox(height: 20),

          // 7. Influence sur les décisions
          if (period.influenceDecisions.isNotEmpty)
            _buildReportCard(
              icon: Icons.gavel,
              iconColor: Colors.blue,
              title: 'Influence sur les Décisions',
              children: [
                _buildPersonalizedContent(period.influenceDecisions),
              ],
            ),
          if (period.influenceDecisions.isNotEmpty)
            const SizedBox(height: 20),

          // 8. Enseignement
          if (period.enseignement.isNotEmpty)
            _buildReportCard(
              icon: Icons.school,
              iconColor: Colors.purple,
              title: 'Ce que Cette Période Vous Enseigne',
              children: [
                _buildPersonalizedContent(period.enseignement),
              ],
            ),
          if (period.enseignement.isNotEmpty)
            const SizedBox(height: 20),

          // Card cross-promotion
          _buildCrossPromotionCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    final dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.teal.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          // Avatar mystique
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.teal, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          
          // Nom
          Text(
            widget.firstName,
            style: GoogleFonts.philosopher(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          
          // Date de naissance
          Text(
            'Né(e) le ${dateFormat.format(widget.birthdate)}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPeriodCard(CurrentPeriodInfo period) {
    final dateFormat = DateFormat('dd MMM', 'fr_FR');
    
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
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          // Badge période
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PÉRIODE ${period.periodNumber}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Nom de la période
          Text(
            period.periodName,
            style: GoogleFonts.philosopher(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Thème
          Text(
            period.themeCentral,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          
          // Dates et progression
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPeriodStat(
                icon: Icons.calendar_today,
                label: 'Début',
                value: dateFormat.format(period.periodStartDate),
              ),
              _buildPeriodStat(
                icon: Icons.timer,
                label: 'Progression',
                value: '${(period.dayInPeriod * 100 / 52).round()}%',
                highlight: true,
              ),
              _buildPeriodStat(
                icon: Icons.event,
                label: 'Fin',
                value: dateFormat.format(period.periodEndDate),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Barre de progression
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progression',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    '${period.daysRemaining} jours restants',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: period.dayInPeriod / 52,
                  backgroundColor: AppColors.block,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodStat({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Column(
      children: [
        Icon(
          icon, 
          color: highlight ? AppColors.primary : AppColors.textMuted, 
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primary : AppColors.textLight,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildYearCalendar() {
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
              Icon(Icons.calendar_month, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Votre Calendrier Annuel',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._yearCalendar!.periods.map((p) => _buildCalendarEntry(p)),
        ],
      ),
    );
  }

  Widget _buildCalendarEntry(PersonalCalendarEntry entry) {
    final dateFormat = DateFormat('dd MMM', 'fr_FR');
    final isCurrent = entry.isCurrent;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent 
            ? AppColors.primary.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isCurrent
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          // Numéro de période
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                '${entry.periodNumber}',
                style: TextStyle(
                  color: isCurrent ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Nom et dates
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.periodName,
                  style: TextStyle(
                    color: isCurrent ? AppColors.textLight : AppColors.textMuted,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${dateFormat.format(entry.startDate)} - ${dateFormat.format(entry.endDate)}',
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: isCurrent ? 1 : 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Badge "Actuel"
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'ACTUEL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
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
          // Header
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

  Widget _buildSubsectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildDomainItem(String text, Color bulletColor) {
    // Séparer le titre (avant —) du contenu (après —) si présent
    String title = text;
    String? description;
    
    if (text.contains(' — ')) {
      final parts = text.split(' — ');
      title = parts[0];
      description = parts.length > 1 ? parts[1] : null;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 10),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bulletColor,
            ),
          ),
          Expanded(
            child: description != null
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$title — ',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: description,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedAdvice(int number, String advice) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              advice,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(String affirmation) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.format_quote, color: Colors.purple, size: 32),
          const SizedBox(height: 12),
          Text(
            'Affirmation de la Période',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            affirmation,
            style: GoogleFonts.philosopher(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.textLight,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedContent(String content) {
    // Remplacer les placeholders par le prénom
    final personalizedContent = content
        .replaceAll('[Prénom]', widget.firstName)
        .replaceAll('[prénom]', widget.firstName);
    
    return Text(
      personalizedContent,
      style: TextStyle(
        color: AppColors.textLight,
        fontSize: 15,
        height: 1.7,
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
              const Icon(Icons.explore, color: AppColors.secondary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Explorez Aussi',
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
            'Consultez votre Portrait de l\'Âme pour découvrir votre essence profonde et vos talents naturels !',
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
              onPressed: () => NavigationHelper.goToMenu(context),
              icon: const Icon(Icons.home, size: 18),
              label: const Text('Voir autres services'),
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
