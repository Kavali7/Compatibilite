/// Cycles de Vie Report Screen
/// Écran d'affichage du rapport personnalisé
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../services/cycles_vie_service.dart';
import '../widgets/animated_background.dart';

/// Écran de visualisation du rapport Cycles de Vie
class CyclesVieReportScreen extends StatefulWidget {
  final String serviceType;
  final DateTime? birthdate;
  final DateTime targetDate;

  const CyclesVieReportScreen({
    super.key,
    required this.serviceType,
    this.birthdate,
    required this.targetDate,
  });

  @override
  State<CyclesVieReportScreen> createState() => _CyclesVieReportScreenState();
}

class _CyclesVieReportScreenState extends State<CyclesVieReportScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  
  ExpressReport? _report;
  bool _isLoading = true;
  String? _error;

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
          'Votre Rapport',
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
        ...schedule.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.isCurrentPeriod 
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.isCurrentPeriod 
                    ? AppColors.primary 
                    : AppColors.block,
                width: item.isCurrentPeriod ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.period.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.period.periodLetter,
                    style: TextStyle(
                      color: item.period.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.period.periodName,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${item.startTime} - ${item.endTime}',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isCurrentPeriod)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Actuel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )),
      ],
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
