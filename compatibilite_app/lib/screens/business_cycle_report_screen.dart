import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../widgets/animated_background.dart';
import '../services/business_cycle_service.dart';

class BusinessCycleReportScreen extends StatefulWidget {
  final String companyName;
  final DateTime referenceDate;

  const BusinessCycleReportScreen({
    super.key,
    required this.companyName,
    required this.referenceDate,
  });

  @override
  State<BusinessCycleReportScreen> createState() => _BusinessCycleReportScreenState();
}

class _BusinessCycleReportScreenState extends State<BusinessCycleReportScreen> {
  CurrentBusinessPeriodInfo? _currentPeriod;
  BusinessYearCalendar? _calendar;
  bool _isLoading = true;
  String? _error;

  final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = BusinessCycleService.instance;
      
      final currentPeriod = await service.getCurrentPeriod(widget.referenceDate);
      final calendar = await service.getYearCalendar(widget.referenceDate);
      
      if (mounted) {
        setState(() {
          _currentPeriod = currentPeriod;
          _calendar = calendar;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erreur de chargement: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond animé
          AnimatedBackground(
            starCount: 80,
            showOrbs: true,
            child: Container(),
          ),
          
          // Contenu
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Cycle Business',
              style: GoogleFonts.philosopher(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textLight),
            onPressed: _loadData,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_currentPeriod == null) {
      return const Center(
        child: Text('Aucune donnée disponible', style: TextStyle(color: AppColors.textMuted)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCompanyHeader(),
          const SizedBox(height: 20),
          _buildCurrentPeriodCard(),
          const SizedBox(height: 20),
          _buildEnergieBusiness(),
          const SizedBox(height: 20),
          _buildFenetreStrategique(),
          const SizedBox(height: 20),
          _buildActionsRecommandees(),
          const SizedBox(height: 20),
          _buildRisquesEviter(),
          const SizedBox(height: 20),
          _buildIndicateursCles(),
          const SizedBox(height: 20),
          _buildDecisions(),
          const SizedBox(height: 20),
          _buildAstuceStrategique(),
          const SizedBox(height: 20),
          if (_calendar != null) _buildCalendar(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_center,
              color: Colors.green,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.companyName,
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Créée le ${dateFormat.format(widget.referenceDate)}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPeriodCard() {
    final period = _currentPeriod!;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Badge période
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PÉRIODE ${period.periodNumber}',
              style: GoogleFonts.philosopher(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Nom période
          Text(
            period.periodName,
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            period.themeCentral,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Stats
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
          const SizedBox(height: 20),
          
          // Barre progression
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progression', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text('${period.daysRemaining} jours restants',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: period.dayInPeriod / 52,
                  backgroundColor: AppColors.block,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
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
        Icon(icon, color: highlight ? Colors.green : AppColors.textMuted, size: 20),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: highlight ? Colors.green : AppColors.textLight,
            fontSize: highlight ? 18 : 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergieBusiness() {
    final period = _currentPeriod!;
    
    return _buildReportCard(
      icon: Icons.electric_bolt,
      title: 'Focus Stratégique',
      iconColor: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period.focusStrategique,
            style: TextStyle(color: AppColors.textLight, fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 16),
          _buildSubsectionTitle('Énergie de la Période'),
          const SizedBox(height: 8),
          Text(
            period.energieBusiness,
            style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFenetreStrategique() {
    final period = _currentPeriod!;
    final points = period.fenetrePoints;
    
    if (points.isEmpty) return const SizedBox.shrink();
    
    return _buildReportCard(
      icon: Icons.window,
      title: 'Fenêtre Stratégique',
      iconColor: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points.map((point) {
          final parts = point.split(' — ');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parts[0],
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (parts.length > 1)
                        Text(
                          parts[1],
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionsRecommandees() {
    final period = _currentPeriod!;
    
    return _buildReportCard(
      icon: Icons.check_circle,
      title: 'Actions Recommandées',
      iconColor: Colors.green,
      child: Column(
        children: period.actionsRecommandees.asMap().entries.map((entry) {
          return _buildNumberedItem(entry.key + 1, entry.value, Colors.green);
        }).toList(),
      ),
    );
  }

  Widget _buildRisquesEviter() {
    final period = _currentPeriod!;
    
    return _buildReportCard(
      icon: Icons.warning_amber,
      title: 'Risques à Éviter',
      iconColor: Colors.orange,
      child: Column(
        children: period.risquesEviter.map((risk) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.close, color: Colors.orange, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    risk,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIndicateursCles() {
    final period = _currentPeriod!;
    
    if (period.indicateursCles.isEmpty) return const SizedBox.shrink();
    
    return _buildReportCard(
      icon: Icons.analytics,
      title: 'Indicateurs Clés à Surveiller',
      iconColor: Colors.purple,
      child: Column(
        children: period.indicateursCles.map((kpi) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_up, color: Colors.purple, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kpi['kpi'] ?? '',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        kpi['raison'] ?? '',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDecisions() {
    final period = _currentPeriod!;
    
    return _buildReportCard(
      icon: Icons.gavel,
      title: 'Décisions',
      iconColor: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubsectionTitle('✅ Décisions Favorables'),
          const SizedBox(height: 8),
          ...period.decisionsFavorables.map((decision) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.thumb_up, color: Colors.green, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    decision,
                    style: TextStyle(color: AppColors.textLight, fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          _buildSubsectionTitle('❌ Décisions à Éviter'),
          const SizedBox(height: 8),
          ...period.decisionsDefavorables.map((decision) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.thumb_down, color: Colors.red, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    decision,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAstuceStrategique() {
    final period = _currentPeriod!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.2),
            Colors.orange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber, size: 32),
          const SizedBox(height: 12),
          Text(
            'Astuce Stratégique',
            style: GoogleFonts.philosopher(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"${period.astuceStrategique}"',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final calendar = _calendar!;
    
    return _buildReportCard(
      icon: Icons.calendar_month,
      title: 'Calendrier Annuel',
      iconColor: Colors.cyan,
      child: Column(
        children: calendar.periods.map((entry) {
          final isCurrent = entry.isCurrent;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCurrent 
                  ? Colors.green.withValues(alpha: 0.15)
                  : AppColors.background.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent ? Colors.green : Colors.white12,
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.green : AppColors.block,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.periodNumber}',
                      style: TextStyle(
                        color: isCurrent ? Colors.white : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.periodName,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'ACTUELLE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${dateFormat.format(entry.startDate)} → ${dateFormat.format(entry.endDate)}',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: GoogleFonts.philosopher(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        color: AppColors.textLight,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textLight, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
