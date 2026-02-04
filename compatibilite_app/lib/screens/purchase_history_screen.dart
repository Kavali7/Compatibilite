import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../core/navigation_helper.dart';
import '../services/auth_service.dart';
import '../services/supabase_manager.dart';
import '../services/currency_service.dart';
import '../services/stored_report_service.dart';
import '../models/stored_report_model.dart';
import '../widgets/animated_background.dart';
import 'compatibility_wizard.dart';
import 'purchased_report_view_screen.dart';
import 'stored_report_viewer_screen.dart';

/// Screen to view purchase history (all service types)
class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  bool _isLoading = true;
  List<_PurchaseItem> _purchases = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _error = 'Vous devez être connecté pour voir vos achats';
      });
      return;
    }

    try {
      if (!SupabaseManager.isReady) {
        setState(() {
          _isLoading = false;
          _error = 'Service indisponible';
        });
        return;
      }

      final List<_PurchaseItem> allPurchases = [];

      // 1. Fetch stored reports (new system)
      final storedReports = await StoredReportService.instance.getUserReports(user.id);
      for (final report in storedReports) {
        allPurchases.add(_PurchaseItem(
          id: report.id,
          type: report.serviceType,
          title: report.serviceLabel,
          subtitle: _formatDate(report.createdAt),
          date: report.createdAt,
          icon: StoredReport.getIconForType(report.serviceType),
          storedReport: report,
        ));
      }

      // 2. Fetch legacy data (couple_profiles without stored reports)
      await _loadLegacyPurchases(user.id, allPurchases);

      // Sort by date descending
      allPurchases.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _purchases = allPurchases;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading purchases: $e');
      setState(() {
        _isLoading = false;
        _error = 'Erreur lors du chargement: $e';
      });
    }
  }

  Future<void> _loadLegacyPurchases(String userId, List<_PurchaseItem> purchases) async {
    try {
      final client = SupabaseManager.client;

      // Get IDs of stored reports to avoid duplicates
      final storedReportPaymentIds = purchases
          .where((p) => p.storedReport?.paymentId != null)
          .map((p) => p.storedReport!.paymentId!)
          .toSet();

      // Fetch payments that don't have stored reports
      final payments = await client
          .from('payments')
          .select('id, amount_fcfa, plan_type, payment_method, created_at, status')
          .eq('user_id', userId)
          .eq('status', 'success')
          .order('created_at', ascending: false);

      // Fetch couple profiles
      final profiles = await client
          .from('couple_profiles')
          .select('id, user_firstname, partner_firstname, payment_id, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Process payments
      for (final payment in (payments as List)) {
        final paymentId = payment['id'] as String;
        
        // Skip if already in stored reports
        if (storedReportPaymentIds.contains(paymentId)) continue;

        final planType = payment['plan_type'] as String? ?? '';
        final amount = payment['amount_fcfa'] as int? ?? 0;
        final method = payment['payment_method'] as String? ?? '';
        final date = DateTime.parse(payment['created_at'] as String);

        // Find matching profile
        var matchingProfile = (profiles as List).cast<Map<String, dynamic>>().firstWhere(
          (p) => p['payment_id'] == paymentId,
          orElse: () => <String, dynamic>{},
        );

        // For compatibility reports
        if (!planType.contains('temporel') && matchingProfile.isNotEmpty) {
          final userFirstname = matchingProfile['user_firstname'] as String? ?? '';
          final partnerFirstname = matchingProfile['partner_firstname'] as String? ?? '';
          
          purchases.add(_PurchaseItem(
            id: paymentId,
            type: StoredReport.typeCompatibility,
            title: userFirstname.isNotEmpty && partnerFirstname.isNotEmpty
                ? 'Compatibilité: $userFirstname & $partnerFirstname'
                : 'Rapport de Compatibilité',
            subtitle: '${_formatDate(date)} • ${CurrencyService.instance.formatAmount(amount)} • $method',
            date: date,
            icon: '❤️',
            legacyProfileId: matchingProfile['id'] as String?,
            legacyProfileData: matchingProfile,
          ));
        } else if (planType.contains('temporel')) {
          // Temporal predictions
          String title = 'Prévision Temporelle';
          if (planType.contains('jour')) title = 'Prévision Journalière';
          if (planType.contains('mois')) title = 'Prévision Mensuelle';
          if (planType.contains('annee') || planType.contains('année')) title = 'Prévision Annuelle';

          purchases.add(_PurchaseItem(
            id: paymentId,
            type: StoredReport.typeTemporal,
            title: title,
            subtitle: '${_formatDate(date)} • ${CurrencyService.instance.formatAmount(amount)} • $method',
            date: date,
            icon: '📅',
          ));
        }
      }

      // Add standalone profiles (free access)
      for (final profile in (profiles as List).cast<Map<String, dynamic>>()) {
        final profileId = profile['id'] as String;
        final alreadyAdded = purchases.any((p) => p.id == profileId || p.legacyProfileId == profileId);

        if (!alreadyAdded) {
          final userFirstname = profile['user_firstname'] as String? ?? '';
          final partnerFirstname = profile['partner_firstname'] as String? ?? '';
          final date = DateTime.parse(profile['created_at'] as String);

          purchases.add(_PurchaseItem(
            id: profileId,
            type: StoredReport.typeCompatibility,
            title: userFirstname.isNotEmpty && partnerFirstname.isNotEmpty
                ? 'Compatibilité: $userFirstname & $partnerFirstname'
                : 'Rapport de Compatibilité',
            subtitle: '${_formatDate(date)} • Accès gratuit',
            date: date,
            icon: '❤️',
            legacyProfileId: profileId,
            legacyProfileData: profile,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error loading legacy purchases: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openReport(_PurchaseItem purchase) async {
    // If we have a stored report, use the new viewer
    if (purchase.storedReport != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoredReportViewerScreen(report: purchase.storedReport!),
        ),
      );
      return;
    }

    // Legacy compatibility reports
    if (purchase.legacyProfileId != null && purchase.legacyProfileData != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      try {
        final client = SupabaseManager.client;
        final profileResponse = await client
            .from('couple_profiles')
            .select('*')
            .eq('id', purchase.legacyProfileId!)
            .maybeSingle();

        if (!mounted) return;
        Navigator.pop(context);

        if (profileResponse == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rapport introuvable'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PurchasedReportViewScreen(
              profileId: purchase.legacyProfileId!,
              profileData: profileResponse,
              purchaseTitle: purchase.title,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Temporal predictions (legacy, no detailed view)
    if (purchase.type == StoredReport.typeTemporal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prévision: ${purchase.title}'),
          backgroundColor: AppColors.secondary,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ce rapport n\'est plus disponible'),
        backgroundColor: Colors.orange,
      ),
    );
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
            onPressed: () => NavigationHelper.goToMenu(context),
          ),
          title: Text(
            'Mes Achats',
            style: GoogleFonts.philosopher(
              fontSize: 22,
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
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
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
                  _loadPurchases();
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

    if (_purchases.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucun achat',
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vos rapports et prévisions apparaîtront ici après achat',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CompatibilityWizard()),
                ),
                icon: const Icon(Icons.favorite),
                label: const Text('Faire une consultation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPurchases,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _purchases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildPurchaseCard(_purchases[index]),
      ),
    );
  }

  Widget _buildPurchaseCard(_PurchaseItem purchase) {
    final color = _getColorForType(purchase.type);

    return InkWell(
      onTap: () => _openReport(purchase),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.block.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                purchase.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.title,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    purchase.subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case StoredReport.typeCompatibility:
        return AppColors.primary;
      case StoredReport.typeTemporal:
        return AppColors.secondary;
      case StoredReport.typePortraitAme:
        return const Color(0xFF9C27B0);
      case StoredReport.typeCyclePersonnel:
      case StoredReport.typeCycleBusiness:
        return const Color(0xFF2196F3);
      case StoredReport.typeCycleSante:
        return const Color(0xFF4CAF50);
      case StoredReport.typeGuideHoraire:
        return const Color(0xFFFF9800);
      case StoredReport.typeEclairageDecision:
        return const Color(0xFFFFEB3B);
      case StoredReport.typePhasesVie:
        return const Color(0xFF673AB7);
      case StoredReport.typeTimingLunaire:
        return const Color(0xFF607D8B);
      default:
        return AppColors.primary;
    }
  }
}

/// Internal model for purchase items (supports both new and legacy data)
class _PurchaseItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final DateTime date;
  final String icon;
  
  // For new stored reports
  final StoredReport? storedReport;
  
  // For legacy compatibility reports
  final String? legacyProfileId;
  final Map<String, dynamic>? legacyProfileData;

  const _PurchaseItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    this.storedReport,
    this.legacyProfileId,
    this.legacyProfileData,
  });
}

