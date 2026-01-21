import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../services/supabase_manager.dart';

/// Screen to view a purchased compatibility report
/// Only accessible for reports that have been paid for
class PurchasedReportViewScreen extends StatefulWidget {
  final String profileId;
  final Map<String, dynamic> profileData;
  final String purchaseTitle;

  const PurchasedReportViewScreen({
    super.key,
    required this.profileId,
    required this.profileData,
    required this.purchaseTitle,
  });

  @override
  State<PurchasedReportViewScreen> createState() => _PurchasedReportViewScreenState();
}

class _PurchasedReportViewScreenState extends State<PurchasedReportViewScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _reportData;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    try {
      // Call RPC function to get full report
      final client = SupabaseManager.client;
      
      final response = await client.rpc('fn_get_compatibility_summary', params: {
        'p_couple_profile_id': widget.profileId,
      });

      setState(() {
        _reportData = response as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading report data: $e');
      setState(() {
        _error = 'Erreur lors du chargement du rapport';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.purchaseTitle,
            style: GoogleFonts.philosopher(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),
        body: _buildBody(),
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
            SizedBox(height: 16),
            Text(
              'Chargement du rapport...',
              style: TextStyle(color: AppColors.textMuted),
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
              const Icon(Icons.error_outline, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadReportData();
                },
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

    // Build report display from profile data
    final profile = widget.profileData;
    final userFirstname = profile['user_firstname'] as String? ?? 'Partenaire 1';
    final partnerFirstname = profile['partner_firstname'] as String? ?? 'Partenaire 2';
    final coupleNumber = profile['couple_number']?.toString() ?? '?';
    final coupleVibration = profile['couple_vibration'] as String? ?? '';
    final dailyAdvice = profile['daily_advice'] as String? ?? '';
    final createdAt = profile['created_at'] != null 
        ? DateTime.tryParse(profile['created_at'] as String) 
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: AppColors.primary, size: 32),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        '$userFirstname & $partnerFirstname',
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (createdAt != null)
                  Text(
                    'Rapport généré le ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Couple Number
          _buildSection(
            icon: Icons.stars,
            title: 'Nombre de Couple',
            child: Column(
              children: [
                Text(
                  coupleNumber,
                  style: GoogleFonts.philosopher(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (coupleVibration.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    coupleVibration,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Daily Advice
          if (dailyAdvice.isNotEmpty)
            _buildSection(
              icon: Icons.lightbulb_outline,
              title: 'Conseil du Jour',
              child: Text(
                dailyAdvice,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Report Data from RPC (if available)
          if (_reportData != null) ...[
            _buildReportSections(_reportData!),
          ],
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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
                  fontSize: 18,
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

  Widget _buildReportSections(Map<String, dynamic> reportData) {
    final sections = <Widget>[];
    
    // Display each section from the report data
    reportData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty && 
          !['user_firstname', 'partner_firstname', 'couple_number', 
            'couple_vibration', 'daily_advice', 'created_at', 'id'].contains(key)) {
        final title = _formatSectionTitle(key);
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSection(
              icon: Icons.auto_awesome,
              title: title,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        );
      }
    });
    
    return Column(children: sections);
  }

  String _formatSectionTitle(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
