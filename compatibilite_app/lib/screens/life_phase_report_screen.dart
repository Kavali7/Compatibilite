/// Life Phase Report Screen (Service 07)
/// Écran de rapport des Phases de Vie
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../services/life_phase_service.dart';
import '../widgets/animated_background.dart';

/// Écran de rapport des Phases de Vie
class LifePhaseReportScreen extends StatefulWidget {
  final String userName;
  final DateTime birthDate;

  const LifePhaseReportScreen({
    super.key,
    required this.userName,
    required this.birthDate,
  });

  @override
  State<LifePhaseReportScreen> createState() => _LifePhaseReportScreenState();
}

class _LifePhaseReportScreenState extends State<LifePhaseReportScreen> {
  List<LifePhase> _phases = [];
  CurrentLifePhaseInfo? _currentPhaseInfo;
  bool _isLoading = true;
  int _selectedPhaseIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final phases = await LifePhaseService.instance.getAllPhases();
      
      final currentInfo = LifePhaseService.instance.calculateCurrentPhase(
        birthDate: widget.birthDate,
        phases: phases,
      );
      
      if (mounted) {
        setState(() {
          _phases = phases;
          _currentPhaseInfo = currentInfo;
          _selectedPhaseIndex = (currentInfo?.phase.phaseNumber ?? 1) - 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('LifePhaseReportScreen: Error loading data: $e');
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
          'Phases de Vie',
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
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_phases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            Text('Données non disponibles', style: GoogleFonts.poppins(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => NavigationHelper.goToMenu(context), child: const Text('Retour')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildCurrentPhaseCard(),
          const SizedBox(height: 20),
          _buildTimelineSection(),
          const SizedBox(height: 20),
          _buildPhaseSelector(),
          const SizedBox(height: 20),
          _buildPhaseDetails(),
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
        if (_currentPhaseInfo != null)
          Text(
            '${_currentPhaseInfo!.currentAge} ans • Phase ${_currentPhaseInfo!.phase.phaseNumber}',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
      ],
    );
  }

  Widget _buildCurrentPhaseCard() {
    if (_currentPhaseInfo == null) return const SizedBox.shrink();

    final info = _currentPhaseInfo!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.9),
            AppColors.secondary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
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
                  '${info.phase.phaseNumber}',
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
                      info.phase.phaseName,
                      style: GoogleFonts.philosopher(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      info.phase.theme,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
                _buildStatItem(Icons.cake, 'Âge', '${info.currentAge} ans'),
                _buildStatItem(Icons.calendar_today, 'Année', '${info.yearInPhase}/7'),
                _buildStatItem(Icons.hourglass_bottom, 'Reste', '${info.yearsRemaining} ans'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            info.phase.ageRange,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildTimelineSection() {
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
            '📅 Votre Parcours de Vie',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...(_phases.map((phase) {
            final isCurrent = _currentPhaseInfo?.phase.phaseNumber == phase.phaseNumber;
            final isPast = _currentPhaseInfo != null && phase.phaseNumber < _currentPhaseInfo!.phase.phaseNumber;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent 
                    ? AppColors.primary.withValues(alpha: 0.2) 
                    : isPast 
                        ? AppColors.secondary.withValues(alpha: 0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: isCurrent ? Border.all(color: AppColors.primary) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCurrent 
                          ? AppColors.primary 
                          : isPast 
                              ? AppColors.secondary
                              : Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${phase.phaseNumber}',
                        style: GoogleFonts.poppins(
                          color: isCurrent || isPast ? Colors.white : AppColors.textMuted,
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
                          phase.phaseName,
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          '${phase.ageRange} • ${phase.theme}',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Actuelle',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (isPast)
                    Icon(Icons.check_circle, color: AppColors.secondary, size: 20),
                ],
              ),
            );
          })),
        ],
      ),
    );
  }

  Widget _buildPhaseSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_phases.length, (index) {
          final phase = _phases[index];
          final isSelected = index == _selectedPhaseIndex;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedPhaseIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.block,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Text(
                    '${phase.phaseNumber}',
                    style: GoogleFonts.philosopher(
                      color: isSelected ? Colors.white : AppColors.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phase.phaseName.split(' ').last,
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
    );
  }

  Widget _buildPhaseDetails() {
    if (_selectedPhaseIndex >= _phases.length) return const SizedBox.shrink();
    
    final phase = _phases[_selectedPhaseIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phase.phaseName,
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  phase.ageRange,
                  style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  phase.theme,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (phase.fullContent.isNotEmpty && !phase.fullContent.startsWith('--')) ...[
            Text(
              phase.fullContent,
              style: TextStyle(color: AppColors.textLight.withValues(alpha: 0.9), fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 20),
          ],
          
          if (phase.impacts.isNotEmpty) ...[
            _buildSectionTitle('💪 Impacts sur Votre Vie'),
            ...phase.impacts.map((impact) => _buildBulletPoint(impact, AppColors.primary)),
            const SizedBox(height: 16),
          ],
          
          if (phase.questionsReflection.isNotEmpty) ...[
            _buildSectionTitle('🤔 Points de Réflexion'),
            ...phase.questionsReflection.asMap().entries.map((e) => 
              _buildNumberedPoint(e.key + 1, e.value)),
            const SizedBox(height: 16),
          ],
          
          if (phase.travailGuerison.isNotEmpty) ...[
            _buildSectionTitle('💜 Travail de Guérison'),
            ...phase.travailGuerison.map((item) => _buildBulletPoint(item, AppColors.secondary)),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textLight.withValues(alpha: 0.9), fontSize: 13, height: 1.5),
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
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textLight.withValues(alpha: 0.9), fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
