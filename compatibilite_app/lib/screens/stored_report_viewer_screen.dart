/// Stored Report Viewer Screen
/// Displays a frozen stored report from the database
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../models/stored_report_model.dart';
import '../widgets/animated_background.dart';

/// Screen to view a stored (frozen) report
class StoredReportViewerScreen extends StatelessWidget {
  final StoredReport report;

  const StoredReportViewerScreen({
    super.key,
    required this.report,
  });

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
          report.serviceLabel,
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 30,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildReportContent(context),
              const SizedBox(height: 32),
              _buildBackToMenuButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final icon = StoredReport.getIconForType(report.serviceType);
    final dateStr = '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}';

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
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.serviceLabel,
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acheté le $dateStr',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(BuildContext context) {
    // Build content based on service type
    switch (report.serviceType) {
      case StoredReport.typeCompatibility:
        return _buildCompatibilityContent();
      case StoredReport.typeTemporal:
        return _buildTemporalContent();
      case StoredReport.typePortraitAme:
      case StoredReport.typeCyclePersonnel:
      case StoredReport.typeCycleBusiness:
      case StoredReport.typeCycleSante:
      case StoredReport.typeGuideHoraire:
      case StoredReport.typeEclairageDecision:
      case StoredReport.typePhasesVie:
      case StoredReport.typeTimingLunaire:
        return _buildGenericContent();
      default:
        return _buildGenericContent();
    }
  }

  Widget _buildCompatibilityContent() {
    final data = report.reportData;
    
    return Column(
      children: [
        // Couple number
        if (data['couple_number'] != null)
          _buildSection(
            icon: Icons.favorite,
            title: 'Nombre de Couple',
            child: Center(
              child: Text(
                '${data['couple_number']}',
                style: GoogleFonts.philosopher(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Couple vibration
        if (data['couple_vibration'] != null)
          _buildSection(
            icon: Icons.auto_awesome,
            title: 'Vibration du Couple',
            child: Text(
              data['couple_vibration'] as String,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Daily advice
        if (data['daily_advice'] != null)
          _buildSection(
            icon: Icons.lightbulb_outline,
            title: 'Conseil du Jour',
            child: Text(
              data['daily_advice'] as String,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),

        // Other data sections
        ..._buildDynamicSections(data, exclude: ['couple_number', 'couple_vibration', 'daily_advice']),
      ],
    );
  }

  Widget _buildTemporalContent() {
    final data = report.reportData;
    final metadata = report.metadata;
    
    return Column(
      children: [
        // Period info from metadata
        if (metadata['target_date'] != null)
          _buildSection(
            icon: Icons.calendar_today,
            title: 'Date de Prévision',
            child: Text(
              _formatDate(metadata['target_date'] as String),
              style: GoogleFonts.philosopher(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
        
        const SizedBox(height: 16),

        // Build all report data sections
        ..._buildDynamicSections(data),
      ],
    );
  }

  Widget _buildGenericContent() {
    final data = report.reportData;
    final metadata = report.metadata;
    
    return Column(
      children: [
        // User info from metadata
        if (metadata['user_name'] != null)
          _buildSection(
            icon: Icons.person,
            title: 'Rapport de',
            child: Text(
              metadata['user_name'] as String,
              style: GoogleFonts.philosopher(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
        
        const SizedBox(height: 16),

        // Build all report data sections dynamically
        ..._buildDynamicSections(data),
      ],
    );
  }

  List<Widget> _buildDynamicSections(Map<String, dynamic> data, {List<String> exclude = const []}) {
    final widgets = <Widget>[];
    
    data.forEach((key, value) {
      if (exclude.contains(key)) return;
      if (value == null || value.toString().isEmpty) return;
      
      // Format key as title
      final title = _formatKey(key);
      
      if (value is Map) {
        // Nested object
        widgets.add(const SizedBox(height: 16));
        widgets.add(_buildSection(
          icon: Icons.folder_outlined,
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (value as Map<String, dynamic>).entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_formatKey(entry.key)}: ',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ));
      } else if (value is List) {
        // List of items
        widgets.add(const SizedBox(height: 16));
        widgets.add(_buildSection(
          icon: Icons.list,
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (value as List).map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.toString(),
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ));
      } else {
        // Simple value
        widgets.add(const SizedBox(height: 16));
        widgets.add(_buildSection(
          icon: Icons.info_outline,
          title: title,
          child: Text(
            value.toString(),
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ));
      }
    });
    
    return widgets;
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.philosopher(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildBackToMenuButton(BuildContext context) {
    return SizedBox(
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
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return isoDate;
    }
  }
}
