import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/temporal_report_service.dart';

/// Widget to display a temporal report card (year, month, or day)
class TemporalReportCard extends StatelessWidget {
  const TemporalReportCard({
    super.key,
    required this.report,
    this.isExpanded = true,
  });

  final TemporalReport report;
  final bool isExpanded;

  IconData get _periodIcon {
    switch (report.periode) {
      case 'annee':
        return Icons.calendar_today;
      case 'mois':
        return Icons.date_range;
      case 'jour':
        return Icons.today;
      default:
        return Icons.access_time;
    }
  }

  Color get _stateColor {
    switch (report.etatRelationnel) {
      case 'harmonieux':
        return Colors.green;
      case 'neutre':
        return Colors.orange;
      case 'tendu':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String get _periodTitle {
    switch (report.periode) {
      case 'annee':
        return 'Prévisions pour ${report.dateReference.year}';
      case 'mois':
        return 'Prévisions pour ${_getMonthName(report.dateReference.month)} ${report.dateReference.year}';
      case 'jour':
        return 'Prévisions du ${report.dateReference.day} ${_getMonthName(report.dateReference.month)}';
      default:
        return 'Prévisions';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_periodIcon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _periodTitle,
                        style: GoogleFonts.philosopher(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                        ),
                      ),
                      if (report.bloc0Titre != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          report.bloc0Titre!,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Vibration number badge
                if (report.numeroPeriode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${report.numeroPeriode}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // State indicator
          if (report.etatRelationnel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _stateColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'État relationnel : ${report.etatLabel}',
                    style: TextStyle(
                      color: _stateColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // Content blocks
          if (isExpanded) ...[
            // Bloc 0 - Canon PDF
            if (report.bloc0Contenu != null && report.bloc0Contenu!.isNotEmpty)
              _buildContentBlock('', report.bloc0Contenu!, isMain: true),
            
            // Bloc 1 - Énergie, Focus, Alerte, Conseil
            if (report.bloc1Contenu != null && report.bloc1Contenu!.isNotEmpty)
              _buildContentBlock('Guidance', report.bloc1Contenu!),
            
            // Bloc 2 - Posture, Levier, Risque
            if (report.bloc2Contenu != null && report.bloc2Contenu!.isNotEmpty)
              _buildContentBlock('Dynamique', report.bloc2Contenu!),
            
            // Bloc 3 - Checklist premium
            if (report.bloc3Contenu != null && report.bloc3Contenu!.isNotEmpty)
              _buildContentBlock('Actions', report.bloc3Contenu!),
          ],
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildContentBlock(String title, String content, {bool isMain = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                color: isMain ? AppColors.textLight : AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: isMain ? 16 : 14,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMain 
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.block.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: isMain ? 15 : 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Call-to-action widget for purchasing tomorrow's report
class TomorrowReportCTA extends StatelessWidget {
  const TomorrowReportCTA({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          // Emoji and text
          const Text(
            '✨',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'Envie de savoir ce que demain vous réserve ?',
            textAlign: TextAlign.center,
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrez comment naviguer ensemble demain et anticipez les opportunités de votre couple.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // CTA Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Prévisions de demain',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading state for temporal reports
class TemporalReportsLoading extends StatelessWidget {
  const TemporalReportsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Chargement de vos prévisions...',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Error state for temporal reports
class TemporalReportsError extends StatelessWidget {
  const TemporalReportsError({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ],
      ),
    );
  }
}
