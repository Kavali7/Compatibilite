import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/supabase_manager.dart';
import '../widgets/animated_background.dart';
import 'compatibility_wizard.dart';
import 'purchased_report_view_screen.dart';

/// Screen to view purchase history (compatibility reports and temporal predictions)
class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _purchases = [];
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

      final client = SupabaseManager.client;
      
      // Fetch payments with successful status
      final payments = await client
          .from('payments')
          .select('id, amount_fcfa, plan_type, payment_method, created_at, status')
          .eq('user_id', user.id)
          .eq('status', 'success')
          .order('created_at', ascending: false);
      
      // Fetch couple profiles
      final profiles = await client
          .from('couple_profiles')
          .select('id, user_firstname, partner_firstname, payment_id, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      // Combine into purchase history
      final List<Map<String, dynamic>> purchases = [];
      
      // First, add all payments with their matching profiles
      for (final payment in (payments as List)) {
        final paymentId = payment['id'];
        final planType = payment['plan_type'] as String? ?? '';
        
        // Find matching profile if any (by payment_id or closest date)
        var matchingProfile = (profiles as List).cast<Map<String, dynamic>>().firstWhere(
          (p) => p['payment_id'] == paymentId,
          orElse: () => <String, dynamic>{},
        );
        
        // If no match by payment_id, try to find by closest creation date
        if (matchingProfile.isEmpty && !planType.contains('temporel')) {
          final paymentDate = DateTime.parse(payment['created_at'] as String);
          Map<String, dynamic>? closestProfile;
          Duration? closestDiff;
          
          for (final profile in (profiles as List).cast<Map<String, dynamic>>()) {
            final profileDate = DateTime.parse(profile['created_at'] as String);
            final diff = (profileDate.difference(paymentDate)).abs();
            
            // If within 1 hour of payment, consider it a match
            if (diff.inMinutes <= 60) {
              if (closestDiff == null || diff < closestDiff) {
                closestDiff = diff;
                closestProfile = profile;
              }
            }
          }
          
          if (closestProfile != null) {
            matchingProfile = closestProfile;
          }
        }
        
        purchases.add({
          'id': paymentId,
          'type': planType.contains('temporel') ? 'temporal' : 'compatibility',
          'title': _getPurchaseTitle(planType, matchingProfile),
          'subtitle': _getPurchaseSubtitle(payment),
          'date': DateTime.parse(payment['created_at'] as String),
          'amount': payment['amount_fcfa'] as int? ?? 0,
          'profileId': matchingProfile['id'],
          'userFirstname': matchingProfile['user_firstname'],
          'partnerFirstname': matchingProfile['partner_firstname'],
        });
      }
      
      // Add standalone profiles that don't have matching payments (free or manual access)
      for (final profile in (profiles as List).cast<Map<String, dynamic>>()) {
        final profileId = profile['id'];
        final alreadyAdded = purchases.any((p) => p['profileId'] == profileId);
        
        if (!alreadyAdded) {
          purchases.add({
            'id': profileId,
            'type': 'compatibility',
            'title': _getPurchaseTitle('compatibility', profile),
            'subtitle': 'Accès manuel',
            'date': DateTime.parse(profile['created_at'] as String),
            'amount': 0,
            'profileId': profileId,
            'userFirstname': profile['user_firstname'],
            'partnerFirstname': profile['partner_firstname'],
          });
        }
      }
      
      // Sort by date descending
      purchases.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      setState(() {
        _purchases = purchases;
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

  String _getPurchaseTitle(String planType, Map<String, dynamic> profile) {
    final userFirstname = profile['user_firstname'] as String? ?? '';
    final partnerFirstname = profile['partner_firstname'] as String? ?? '';
    
    if (planType.contains('temporel')) {
      if (planType.contains('jour')) return 'Prévision Journalière';
      if (planType.contains('mois')) return 'Prévision Mensuelle';
      if (planType.contains('annee') || planType.contains('année')) return 'Prévision Annuelle';
      return 'Prévision Temporelle';
    }
    
    if (userFirstname.isNotEmpty && partnerFirstname.isNotEmpty) {
      return 'Compatibilité: $userFirstname & $partnerFirstname';
    }
    return 'Rapport de Compatibilité';
  }

  String _getPurchaseSubtitle(Map<String, dynamic> payment) {
    final date = DateTime.parse(payment['created_at'] as String);
    final amount = payment['amount_fcfa'] as int? ?? 0;
    final method = payment['payment_method'] as String? ?? 'Paiement';
    
    return '${date.day}/${date.month}/${date.year} • $amount FCFA • $method';
  }

  void _openReport(Map<String, dynamic> purchase) async {
    final profileId = purchase['profileId'];
    
    // For compatibility reports with a valid profileId
    if (purchase['type'] == 'compatibility' && profileId != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
      
      try {
        // Fetch the report data from Supabase
        final client = SupabaseManager.client;
        
        // Get couple profile data
        final profileResponse = await client
            .from('couple_profiles')
            .select('*')
            .eq('id', profileId)
            .maybeSingle();
        
        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        
        if (profileResponse == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rapport introuvable'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        // Navigate to a dedicated report viewing screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PurchasedReportViewScreen(
              profileId: profileId,
              profileData: profileResponse,
              purchaseTitle: purchase['title'] as String,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        
        debugPrint('Error opening report: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (purchase['type'] == 'temporal') {
      // For temporal predictions, show a message (can be expanded later)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prévision: ${purchase['title']}'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce rapport n\'est plus disponible'),
          backgroundColor: Colors.orange,
        ),
      );
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
                'Vos rapports de compatibilité et prévisions temporelles apparaîtront ici',
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

  Widget _buildPurchaseCard(Map<String, dynamic> purchase) {
    final isCompatibility = purchase['type'] == 'compatibility';
    final icon = isCompatibility ? Icons.favorite : Icons.calendar_today;
    final color = isCompatibility ? AppColors.primary : AppColors.secondary;
    
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
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase['title'] as String,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    purchase['subtitle'] as String,
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
}
