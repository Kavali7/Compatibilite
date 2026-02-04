/// Écran de rapport du Timing Lunaire
/// Affiche la phase actuelle, le calendrier lunaire et les conseils
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../services/lunar_timing_service.dart';
import '../widgets/animated_background.dart';

/// Écran de rapport du Timing Lunaire
class LunarTimingReportScreen extends StatefulWidget {
  final String userName;

  const LunarTimingReportScreen({
    super.key,
    required this.userName,
  });

  @override
  State<LunarTimingReportScreen> createState() => _LunarTimingReportScreenState();
}

class _LunarTimingReportScreenState extends State<LunarTimingReportScreen> {
  bool _isLoading = true;
  List<LunarPhase> _phases = [];
  CurrentLunarPhaseInfo? _currentPhaseInfo;
  LunarPhase? _selectedPhase;
  List<Map<String, dynamic>> _calendar = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final phases = await LunarTimingService.instance.getAllPhases();
      
      CurrentLunarPhaseInfo? phaseInfo;
      if (phases.isNotEmpty) {
        phaseInfo = LunarTimingService.instance.calculateCurrentPhase(
          phases: phases,
        );
      }

      // Générer le calendrier pour les 30 prochains jours
      final calendar = LunarTimingService.instance.generateLunarCalendar(
        phases: phases,
        daysCount: 30,
      );

      if (mounted) {
        setState(() {
          _phases = phases;
          _currentPhaseInfo = phaseInfo;
          _selectedPhase = phaseInfo?.phase;
          _calendar = calendar;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading lunar data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          'Votre Timing Lunaire',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.textLight),
            onPressed: _showCalendarModal,
          ),
        ],
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 80,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          const SizedBox(height: 24),
          _buildCurrentPhaseCard(),
          const SizedBox(height: 24),
          _buildPhaseSelector(),
          const SizedBox(height: 24),
          if (_selectedPhase != null) ...[
            _buildPhaseDetails(),
            const SizedBox(height: 24),
            _buildActivities(),
            const SizedBox(height: 24),
          ],
          _buildUpcomingPhases(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withValues(alpha: 0.2),
            Colors.purple.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.indigo.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌙', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour ${widget.userName}',
                      style: GoogleFonts.philosopher(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    Text(
                      dateFormat.format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhaseCard() {
    if (_currentPhaseInfo == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.block,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Impossible de calculer la phase actuelle',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final phase = _currentPhaseInfo!.phase;
    final dateFormat = DateFormat('d MMM', 'fr_FR');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withValues(alpha: 0.3),
            Colors.deepPurple.withValues(alpha: 0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.indigo.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Emoji de la phase
          Text(
            phase.emoji,
            style: const TextStyle(fontSize: 72),
          ),
          const SizedBox(height: 16),
          
          // Nom de la phase
          Text(
            phase.phaseName,
            style: GoogleFonts.philosopher(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          
          // Thème
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              phase.theme,
              style: TextStyle(
                fontSize: 14,
                color: Colors.indigo[200],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Barre de progression
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(_currentPhaseInfo!.phaseStartDate),
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  Text(
                    '${_currentPhaseInfo!.daysRemaining} jours restants',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.indigo[200],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateFormat.format(_currentPhaseInfo!.phaseEndDate),
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _currentPhaseInfo!.progressPercentage / 100,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[300]!),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          
          // Énergie
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt, color: Colors.amber[300], size: 20),
              const SizedBox(width: 8),
              Text(
                'Énergie: ${phase.energyType}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber[200],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explorer les phases',
          style: GoogleFonts.philosopher(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _phases.map((phase) {
              final isSelected = _selectedPhase?.phaseNumber == phase.phaseNumber;
              final isCurrent = _currentPhaseInfo?.phase.phaseNumber == phase.phaseNumber;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPhase = phase),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.indigo.withValues(alpha: 0.4)
                          : AppColors.block,
                      borderRadius: BorderRadius.circular(16),
                      border: isCurrent
                          ? Border.all(color: Colors.indigo, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(phase.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          phase.phaseName.split(' ').first,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white : AppColors.textMuted,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseDetails() {
    final phase = _selectedPhase!;
    
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
              Text(phase.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.phaseName,
                      style: GoogleFonts.philosopher(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    Text(
                      phase.theme,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.indigo[200],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (phase.conseil != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote, color: Colors.indigo[300], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      phase.conseil!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (phase.fullContent.isNotEmpty && phase.fullContent != '-- VOIR content --') ...[
            const SizedBox(height: 16),
            Text(
              phase.fullContent,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivities() {
    final phase = _selectedPhase!;

    return Column(
      children: [
        // Activités favorables
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[400], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Activités Favorables',
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...phase.activitiesFavorables.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✅', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activity,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Activités à éviter
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cancel, color: Colors.red[400], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'À Éviter',
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...phase.activitiesEviter.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('❌', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activity,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingPhases() {
    final nextNewMoon = LunarTimingService.instance.getNextNewMoon();
    final nextFullMoon = LunarTimingService.instance.getNextFullMoon();
    final dateFormat = DateFormat('EEEE d MMMM', 'fr_FR');

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
            '📅 Prochaines dates clés',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          _buildUpcomingPhaseItem(
            emoji: '🌑',
            label: 'Prochaine Nouvelle Lune',
            date: dateFormat.format(nextNewMoon),
            daysUntil: nextNewMoon.difference(DateTime.now()).inDays,
          ),
          const SizedBox(height: 12),
          _buildUpcomingPhaseItem(
            emoji: '🌕',
            label: 'Prochaine Pleine Lune',
            date: dateFormat.format(nextFullMoon),
            daysUntil: nextFullMoon.difference(DateTime.now()).inDays,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingPhaseItem({
    required String emoji,
    required String label,
    required String date,
    required int daysUntil,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Dans $daysUntil jours',
              style: TextStyle(
                fontSize: 12,
                color: Colors.indigo[200],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.block,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _buildCalendarContent(scrollController),
      ),
    );
  }

  Widget _buildCalendarContent(ScrollController scrollController) {
    final dateFormat = DateFormat('EEE d', 'fr_FR');
    final monthFormat = DateFormat('MMMM yyyy', 'fr_FR');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '📅 Calendrier Lunaire',
                style: GoogleFonts.philosopher(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              Text(
                monthFormat.format(DateTime.now()),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _calendar.length,
            itemBuilder: (context, index) {
              final item = _calendar[index];
              final date = item['date'] as DateTime;
              final phase = item['phase'] as LunarPhase?;
              final isToday = DateUtils.isSameDay(date, DateTime.now());

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isToday
                      ? Colors.indigo.withValues(alpha: 0.2)
                      : AppColors.background.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: isToday
                      ? Border.all(color: Colors.indigo, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormat.format(date),
                            style: TextStyle(
                              fontSize: 14,
                              color: isToday ? Colors.white : AppColors.textLight,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isToday)
                            Text(
                              'Aujourd\'hui',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.indigo[200],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      phase?.emoji ?? '🌙',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phase?.phaseName ?? 'Phase lunaire',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            phase?.theme ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
