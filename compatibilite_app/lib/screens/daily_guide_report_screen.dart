/// Daily Guide Report Screen
/// Écran de rapport du service Guide Horaire (Service 05)
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../models/stored_report_model.dart';
import '../services/auth_service.dart';
import '../services/daily_guide_service.dart';
import '../services/stored_report_service.dart';
import '../widgets/animated_background.dart';

/// Écran de rapport du Guide Horaire
class DailyGuideReportScreen extends StatefulWidget {
  final DateTime targetDate;
  final StoredReport? frozenReport;

  const DailyGuideReportScreen({
    super.key,
    required this.targetDate,
    this.frozenReport,
  });

  @override
  State<DailyGuideReportScreen> createState() => _DailyGuideReportScreenState();
}

class _DailyGuideReportScreenState extends State<DailyGuideReportScreen> {
  List<DailyPeriodWithSlot>? _periods;
  DailyPeriodWithSlot? _currentPeriod;
  bool _isLoading = true;
  String? _error;

  // Couleur thème bleu ciel
  static const Color _themeColor = Color(0xFF0284C7);
  static const Color _themeColorDark = Color(0xFF075985);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // If frozen report provided, skip fresh loading
    if (widget.frozenReport != null) {
      setState(() => _isLoading = false);
      return;
    }
    
    try {
      final periods = await DailyGuideService.instance.getPeriodsForDate(widget.targetDate);
      final current = await DailyGuideService.instance.getCurrentPeriodForDate(widget.targetDate);
      
      if (mounted) {
        setState(() {
          _periods = periods;
          _currentPeriod = current;
          _isLoading = false;
        });
        
        // Store report for "Mes Achats" (fire and forget)
        _storeReportForHistory();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erreur lors du chargement: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Store the report for "Mes Achats" feature
  void _storeReportForHistory() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) return;

      // Check if report already exists
      final exists = await StoredReportService.instance.hasStoredReport(
        userId: user.id,
        serviceType: StoredReport.typeGuideHoraire,
      );
      if (exists) return;

      // Prepare report data from periods
      final periodsData = (_periods ?? []).map((p) => {
        'period_name': p.periodName,
        'time_slot': p.timeSlotLabel,
        'keyword': p.keyword,
        'description': p.description,
        'period_letter': p.periodLetter,
        'period_number': p.periodNumber,
        'favorables': p.favorablesList,
        'eviter': p.eviterList,
      }).toList();

      await StoredReportService.instance.storeCyclesVieReport(
        userId: user.id,
        serviceType: StoredReport.typeGuideHoraire,
        userName: user.email ?? 'Utilisateur',
        birthDate: widget.targetDate,
        targetDate: widget.targetDate,
        reportData: {
          'target_date': widget.targetDate.toIso8601String(),
          'periods': periodsData,
          'current_period_name': _currentPeriod?.periodName ?? '',
        },
      );
      debugPrint('DailyGuideReportScreen: Report stored');
    } catch (e) {
      debugPrint('DailyGuideReportScreen: Failed to store: $e');
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
          'Guide Horaire',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: _themeColor),
            onPressed: () {
              // TODO: Partage
            },
          ),
        ],
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 35,
        gradientColors: const [_themeColor, _themeColorDark],
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _themeColor),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: _themeColor),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header avec date
          _buildDateHeader(),
          const SizedBox(height: 24),

          // Période actuelle mise en évidence
          if (_currentPeriod != null) ...[
            _buildCurrentPeriodCard(),
            const SizedBox(height: 24),
          ],

          // Timeline des 7 créneaux
          _buildTimelineSection(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _themeColor.withValues(alpha: 0.2),
            _themeColorDark.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _themeColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today, color: _themeColor, size: 32),
          const SizedBox(height: 12),
          Text(
            _formatDate(widget.targetDate),
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Votre guide personnalisé des énergies quotidiennes',
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

  String _formatDate(DateTime date) {
    final jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 
                  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
    
    final jour = jours[date.weekday - 1];
    final moisNom = mois[date.month - 1];
    
    return '$jour ${date.day} $moisNom ${date.year}';
  }

  Widget _buildCurrentPeriodCard() {
    final period = _currentPeriod!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _themeColor.withValues(alpha: 0.25),
            _themeColorDark.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _themeColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _themeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'EN COURS',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                period.timeSlotLabel,
                style: GoogleFonts.poppins(
                  color: _themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            period.periodName,
            style: GoogleFonts.philosopher(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            period.keyword,
            style: TextStyle(
              color: _themeColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            period.description,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (period.favorablesList.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildActivityList('Activités favorables', period.favorablesList, Icons.check_circle, Colors.green),
          ],
          if (period.eviterList.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildActivityList('À éviter', period.eviterList, Icons.cancel, Colors.red.shade300),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityList(String title, List<String> items, IconData icon, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: iconColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  item,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
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
              Icon(Icons.timeline, color: _themeColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Vos 7 créneaux du jour',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...(_periods ?? []).map((pws) => _buildTimelineItem(pws)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(DailyPeriodWithSlot period) {
    final isCurrent = _currentPeriod?.periodNumber == period.periodNumber;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showPeriodDetails(period),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCurrent 
              ? _themeColor.withValues(alpha: 0.15)
              : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrent ? _themeColor : AppColors.textMuted.withValues(alpha: 0.2),
              width: isCurrent ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Indicateur de période
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCurrent ? _themeColor : AppColors.block,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    period.periodNumber.toString(),
                    style: GoogleFonts.philosopher(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : _themeColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            period.periodName,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          period.timeSlotLabel,
                          style: TextStyle(
                            color: isCurrent ? _themeColor : AppColors.textMuted,
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      period.keyword,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: isCurrent ? _themeColor : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPeriodDetails(DailyPeriodWithSlot period) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.block,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Titre
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _themeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        period.periodNumber.toString(),
                        style: GoogleFonts.philosopher(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          period.periodName,
                          style: GoogleFonts.philosopher(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          period.timeSlotLabel,
                          style: TextStyle(
                            color: _themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Énergie
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: _themeColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type d\'énergie',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            period.keyword,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Description
              Text(
                'Description',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                period.description,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              
              // Activités favorables
              if (period.favorablesList.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  '✅ Activités favorables',
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 12),
                ...period.favorablesList.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activity,
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              
              // Activités à éviter
              if (period.eviterList.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  '❌ À éviter',
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 12),
                ...period.eviterList.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red.shade300, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activity,
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
