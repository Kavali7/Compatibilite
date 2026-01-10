/// Results Screen - displays compatibility results after purchase
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../models/compatibility_models.dart';
import '../../services/auth_service.dart';
import '../../services/temporal_report_service.dart';
import '../../widgets/temporal_report_card.dart';
import '../purchase/purchase_screen.dart';

/// Screen displaying all purchased results
class ResultsScreen extends StatefulWidget {
  final String? coupleProfileId;
  final CompatibilitySummary? preloadedSummary;
  
  const ResultsScreen({
    super.key,
    this.coupleProfileId,
    this.preloadedSummary,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = true;
  String? _error;
  
  CompatibilitySummary? _summary;
  TemporalReport? _yearReport;
  TemporalReport? _monthReport;
  TemporalReport? _dayReport;
  
  @override
  void initState() {
    super.initState();
    _summary = widget.preloadedSummary;
    _loadReports();
  }
  
  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Veuillez vous connecter pour voir vos résultats';
          _isLoading = false;
        });
        return;
      }
      
      // Load temporal reports
      final service = TemporalReportService.instance;
      final reports = await service.getBonusReports(userId: user.id);
      
      setState(() {
        _yearReport = reports['annee'];
        _monthReport = reports['mois'];
        _dayReport = reports['jour'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
    }
  }
  
  void _navigateToPurchase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PurchaseScreen()),
    ).then((result) {
      if (result != null && result['success'] == true) {
        _loadReports();
      }
    });
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
          'Vos Résultats',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textMuted),
            onPressed: _loadReports,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReports,
              child: const Text('Réessayer'),
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
          // Basic Report Section
          if (_summary != null) ...[
            _buildCoupleCard(_summary!),
            const SizedBox(height: 16),
            _buildPartnerCards(_summary!),
            const SizedBox(height: 16),
            _buildDailyAdvice(_summary!),
            const SizedBox(height: 24),
          ],
          
          // Temporal Reports Section
          Text(
            '📅 Prévisions Temporelles',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 12),
          
          if (_yearReport != null)
            TemporalReportCard(report: _yearReport!, isExpanded: true),
          
          if (_monthReport != null)
            TemporalReportCard(report: _monthReport!, isExpanded: true),
          
          if (_dayReport != null)
            TemporalReportCard(report: _dayReport!, isExpanded: true),
          
          // No reports - show CTA
          if (_yearReport == null && _monthReport == null && _dayReport == null) ...[
            _buildNoReportsCTA(),
          ],
          
          const SizedBox(height: 24),
          
          // Upsell CTA
          _buildUpsellCTA(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildCoupleCard(CompatibilitySummary summary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💑 Dynamique du couple',
            style: GoogleFonts.philosopher(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(summary.coupleMeaning ?? 'Interprétation indisponible.'),
          const SizedBox(height: 10),
          Text(
            'Calculé le ${DateFormat('dd/MM/yyyy').format(summary.generatedAt)}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPartnerCards(CompatibilitySummary summary) {
    return Column(
      children: [
        _buildPartnerCard('Partenaire A', summary.partnerA),
        const SizedBox(height: 12),
        _buildPartnerCard('Partenaire B', summary.partnerB),
      ],
    );
  }
  
  Widget _buildPartnerCard(String title, PartnerReport partner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Portrait de ${partner.input.name}',
            style: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Profil essentiel', partner.lifePathMeaning),
          _buildInfoRow('Signature relationnelle', partner.nameMeaning),
          _buildInfoRow('Tonalité intime', partner.intimateMeaning),
          _buildInfoRow('Style social', partner.personalityMeaning),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
  
  Widget _buildDailyAdvice(CompatibilitySummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Conseil du jour : ${summary.coupleDailyNumber}',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(summary.coupleDailyMeaning ?? 'Laissez-vous guider par vos cycles personnels.'),
        ],
      ),
    );
  }
  
  Widget _buildNoReportsCTA() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.calendar_today, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Aucune prévision temporelle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Débloquez vos prévisions pour l\'année, le mois et le jour.',
            style: TextStyle(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToPurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Voir les offres', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpsellCTA() {
    return GestureDetector(
      onTap: _navigateToPurchase,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.2),
              AppColors.secondary.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Débloquez plus de prévisions',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Découvrez vos prévisions pour demain, la semaine prochaine...',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
