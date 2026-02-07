/// Health Cycle Report Screen (Service 04)
/// Écran de rapport du Cycle Santé
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../models/stored_report_model.dart';
import '../services/auth_service.dart';
import '../services/health_cycle_service.dart';
import '../services/stored_report_service.dart';
import '../widgets/animated_background.dart';

/// Écran de rapport du Cycle Santé
class HealthCycleReportScreen extends StatefulWidget {
  final String userName;
  final DateTime birthDate;
  final StoredReport? frozenReport; // For frozen reading from Mes Achats

  const HealthCycleReportScreen({
    super.key,
    required this.userName,
    required this.birthDate,
    this.frozenReport,
  });

  @override
  State<HealthCycleReportScreen> createState() => _HealthCycleReportScreenState();
}

class _HealthCycleReportScreenState extends State<HealthCycleReportScreen> {
  List<HealthPeriod> _periods = [];
  CurrentHealthPeriodInfo? _currentPeriodInfo;
  HealthYearCalendar? _calendar;
  bool _isLoading = true;
  int _selectedPeriodIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // If frozen report provided, just mark as not loading (UI will show minimal frozen data)
    if (widget.frozenReport != null) {
      setState(() => _isLoading = false);
      return;
    }
    
    try {
      final periods = await HealthCycleService.instance.getAllPeriods();
      
      final currentInfo = HealthCycleService.instance.calculateCurrentPeriod(
        birthDate: widget.birthDate,
        periods: periods,
      );
      
      final calendar = HealthCycleService.instance.generateYearCalendar(
        birthDate: widget.birthDate,
        periods: periods,
      );
      
      if (mounted) {
        setState(() {
          _periods = periods;
          _currentPeriodInfo = currentInfo;
          _calendar = calendar;
          _selectedPeriodIndex = (currentInfo?.period.periodNumber ?? 1) - 1;
          _isLoading = false;
        });
        
        // Store report for "Mes Achats" (fire and forget)
        _storeReportForHistory();
      }
    } catch (e) {
      debugPrint('HealthCycleReportScreen: Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _storeReportForHistory() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) return;

      // Check if report already exists
      final exists = await StoredReportService.instance.hasStoredReport(
        userId: user.id,
        serviceType: StoredReport.typeCycleSante,
      );

      if (exists) {
        debugPrint('Health Cycle report already exists, skipping');
        return;
      }

      // Prepare report data
      final reportData = <String, dynamic>{
        'user_name': widget.userName,
        'birth_date': widget.birthDate.toIso8601String(),
        if (_currentPeriodInfo != null) ...{
          'period_number': _currentPeriodInfo!.period.periodNumber,
          'period_name': _currentPeriodInfo!.period.periodName,
          'theme_central': _currentPeriodInfo!.period.themeCentral,
          'day_in_period': _currentPeriodInfo!.dayInPeriod,
          'days_remaining': _currentPeriodInfo!.daysRemaining,
        },
        'stored_at': DateTime.now().toIso8601String(),
      };

      await StoredReportService.instance.storeCyclesVieReport(
        userId: user.id,
        serviceType: StoredReport.typeCycleSante,
        userName: widget.userName,
        birthDate: widget.birthDate,
        targetDate: DateTime.now(),
        reportData: reportData,
      );

      debugPrint('✅ Health Cycle report stored for Mes Achats');
    } catch (e) {
      debugPrint('⚠️ Error storing Health Cycle report: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => NavigationHelper.goToMenu(context),
        ),
        title: Text(
          '🏥 Cycle Santé',
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
        gradientColors: const [Color(0xFF1B5E20), Color(0xFF0E2E15)],
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF66BB6A)))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_periods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              'Données non disponibles',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => NavigationHelper.goToMenu(context),
              child: const Text('Retour'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Espace pour l'app bar
          _buildHeader(),
          const SizedBox(height: 20),
          _buildCurrentPeriodCard(),
          const SizedBox(height: 20),
          _buildCalendarSection(),
          const SizedBox(height: 20),
          _buildPeriodSelector(),
          const SizedBox(height: 20),
          _buildPeriodDetails(),
          const SizedBox(height: 20),
          _buildMedicalDisclaimer(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rapport de ${widget.userName}',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Votre guide bien-être personnalisé',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPeriodCard() {
    if (_currentPeriodInfo == null) return const SizedBox.shrink();

    final info = _currentPeriodInfo!;
    final dateFormat = DateFormat('d MMM yyyy', 'fr_FR');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32).withValues(alpha: 0.9),
            const Color(0xFF388E3C).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${info.period.periodNumber}',
                  style: GoogleFonts.philosopher(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.period.periodName,
                      style: GoogleFonts.philosopher(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      info.period.themeCentral,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.calendar_today,
                  value: 'Jour ${info.dayInPeriod}',
                  label: 'de la période',
                ),
                _buildStatItem(
                  icon: Icons.hourglass_bottom,
                  value: '${info.daysRemaining}',
                  label: 'jours restants',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${dateFormat.format(info.startDate)} → ${dateFormat.format(info.endDate)}',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    if (_calendar == null) return const SizedBox.shrink();

    final dateFormat = DateFormat('d MMM', 'fr_FR');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📅 Calendrier Santé ${_calendar!.year}-${_calendar!.year + 1}',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...(_calendar!.periods.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: entry.isCurrent 
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.2) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: entry.isCurrent 
                    ? Border.all(color: const Color(0xFF2E7D32)) 
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: entry.isCurrent 
                          ? const Color(0xFF2E7D32) 
                          : Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.periodNumber}',
                        style: GoogleFonts.poppins(
                          color: entry.isCurrent ? Colors.white : AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.periodName,
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                            fontWeight: entry.isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          '${dateFormat.format(entry.startDate)} - ${dateFormat.format(entry.endDate)}',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (entry.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'En cours',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          })),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_periods.length, (index) {
            final period = _periods[index];
            final isSelected = index == _selectedPeriodIndex;
            
            return GestureDetector(
              onTap: () => setState(() => _selectedPeriodIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF2E7D32) 
                      : AppColors.block,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? null 
                      : Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${period.periodNumber}',
                      style: GoogleFonts.philosopher(
                        color: isSelected ? Colors.white : AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      period.periodName.split(' ').last,
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPeriodDetails() {
    if (_selectedPeriodIndex >= _periods.length) return const SizedBox.shrink();
    
    final period = _periods[_selectedPeriodIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period.periodName,
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            period.themeCentral,
            style: TextStyle(
              color: const Color(0xFF66BB6A),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          
          // État énergétique
          if (period.etatEnergetique.isNotEmpty) ...[
            _buildSectionTitle('💪 État Énergétique'),
            Text(
              period.etatEnergetique,
              style: TextStyle(
                color: AppColors.textLight.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Points de vigilance
          if (period.pointsVigilance.isNotEmpty) ...[
            _buildSectionTitle('⚠️ Points de Vigilance'),
            ...period.pointsVigilance.map((point) => _buildBulletPoint(point, Colors.amber)),
            const SizedBox(height: 16),
          ],
          
          // Activités recommandées
          if (period.activitesRecommandees.isNotEmpty) ...[
            _buildSectionTitle('✅ Activités Recommandées'),
            ...period.activitesRecommandees.map((activity) => _buildBulletPoint(activity, const Color(0xFF66BB6A))),
            const SizedBox(height: 16),
          ],
          
          // Activités à modérer
          if (period.activitesModerer.isNotEmpty) ...[
            _buildSectionTitle('❌ À Modérer'),
            ...period.activitesModerer.map((activity) => _buildBulletPoint(activity, Colors.red.shade300)),
            const SizedBox(height: 16),
          ],
          
          // Alimentation
          if (period.alimentationPrivilegier.isNotEmpty) ...[
            _buildSectionTitle('🥗 Alimentation à Privilégier'),
            ...period.alimentationPrivilegier.map((food) => _buildBulletPoint(food, const Color(0xFF66BB6A))),
            const SizedBox(height: 16),
          ],
          
          if (period.alimentationEviter.isNotEmpty) ...[
            _buildSectionTitle('🚫 Alimentation à Éviter'),
            ...period.alimentationEviter.map((food) => _buildBulletPoint(food, Colors.red.shade300)),
            const SizedBox(height: 16),
          ],
          
          // Repos et sommeil
          if (period.reposSommeil.isNotEmpty) ...[
            _buildSectionTitle('🛏️ Repos et Sommeil'),
            Text(
              period.reposSommeil,
              style: TextStyle(
                color: AppColors.textLight.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Conseils pratiques
          if (period.conseilsPratiques.isNotEmpty) ...[
            _buildSectionTitle('💡 Conseils Pratiques'),
            ...period.conseilsPratiques.asMap().entries.map((entry) => 
              _buildNumberedPoint(entry.key + 1, entry.value)),
            const SizedBox(height: 16),
          ],
          
          // Affirmation
          if (period.affirmationBienEtre.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, color: Color(0xFF66BB6A), size: 24),
                  const SizedBox(height: 8),
                  Text(
                    period.affirmationBienEtre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.philosopher(
          color: AppColors.textLight,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textLight.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: const Color(0xFF66BB6A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textLight.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ce rapport fournit des conseils généraux de bien-être basés sur des cycles ancestraux. '
              'Il ne remplace en aucun cas un avis médical professionnel. '
              'Consultez votre médecin avant de modifier votre alimentation ou votre activité physique.',
              style: TextStyle(
                color: Colors.amber.shade100,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
