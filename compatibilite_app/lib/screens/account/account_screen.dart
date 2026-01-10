/// Account Screen - Enhanced User Dashboard
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../services/auth_service.dart';
import '../../services/payment/payment_manager.dart';
import '../../services/pricing_service.dart';
import '../../services/temporal_report_service.dart';
import '../purchase/purchase_screen.dart';
import '../results/results_screen.dart';

/// Enhanced user account dashboard with:
/// - Profile info
/// - Available reports
/// - Purchase history
/// - Quick actions
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isLoading = true;
  List<Purchase> _purchases = [];
  Map<String, TemporalReport?> _availableReports = {};
  bool _hasBasicReport = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final user = AuthService.instance.currentUser;
    if (user != null) {
      // Load purchases
      _purchases = await PaymentManager.instance.getUserPurchases(user.id);
      
      // Check for available reports
      _hasBasicReport = await PaymentManager.instance.hasPurchased(
        user.id, 
        ProductType.basicReport,
      );
      
      // Load temporal reports if available
      try {
        _availableReports = await TemporalReportService.instance.getBonusReports(
          userId: user.id,
        );
      } catch (e) {
        debugPrint('Error loading reports: $e');
      }
    }
    
    setState(() => _isLoading = false);
  }
  
  void _signOut() async {
    await AuthService.instance.signOut();
    if (mounted) {
      Navigator.pop(context);
    }
  }
  
  void _navigateToPurchase({ProductType? productType}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PurchaseScreen(preselectedProductType: productType),
      ),
    );
    if (result != null && result['success'] == true) {
      _loadData();
    }
  }
  
  void _navigateToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text('Mon Compte'),
        ),
        body: const Center(
          child: Text(
            'Veuillez vous connecter',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }
    
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
          'Mon Compte',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textMuted),
            onPressed: _signOut,
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    _buildProfileCard(user),
                    
                    const SizedBox(height: 24),
                    
                    // My Reports Section
                    _buildSectionTitle('📊 Mes Rapports'),
                    const SizedBox(height: 12),
                    _buildReportsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    _buildQuickActions(),
                    
                    const SizedBox(height: 24),
                    
                    // Purchase History
                    _buildSectionTitle('📋 Historique des achats'),
                    const SizedBox(height: 12),
                    
                    if (_purchases.isEmpty)
                      _buildEmptyPurchases()
                    else
                      ..._purchases.map((p) => _buildPurchaseItem(p)),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textLight,
      ),
    );
  }
  
  Widget _buildProfileCard(AppUser user) {
    final isSubscriber = _purchases.any((p) => 
      p.productType == ProductType.subscription30 && 
      p.status == PurchaseStatus.success
    );
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name?.isNotEmpty == true
                    ? user.name![0].toUpperCase()
                    : user.email[0].toUpperCase(),
                style: GoogleFonts.philosopher(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Utilisateur',
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSubscriber 
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.block,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isSubscriber ? '⭐ Abonné' : 'Membre',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSubscriber ? AppColors.primary : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildReportRow(
            icon: '💑',
            title: 'Compatibilité',
            isAvailable: _hasBasicReport,
            onTap: _hasBasicReport ? _navigateToResults : () => _navigateToPurchase(productType: ProductType.basicReport),
          ),
          const Divider(color: AppColors.textMuted, height: 24),
          _buildReportRow(
            icon: '📅',
            title: 'Prévision Annuelle',
            isAvailable: _availableReports['annee'] != null,
            onTap: _availableReports['annee'] != null 
                ? _navigateToResults 
                : () => _navigateToPurchase(productType: ProductType.yearPrediction),
          ),
          const Divider(color: AppColors.textMuted, height: 24),
          _buildReportRow(
            icon: '🗓️',
            title: 'Prévision Mensuelle',
            isAvailable: _availableReports['mois'] != null,
            onTap: _availableReports['mois'] != null 
                ? _navigateToResults 
                : () => _navigateToPurchase(productType: ProductType.monthPrediction),
          ),
          const Divider(color: AppColors.textMuted, height: 24),
          _buildReportRow(
            icon: '☀️',
            title: 'Prévision du Jour',
            isAvailable: _availableReports['jour'] != null,
            onTap: _availableReports['jour'] != null 
                ? _navigateToResults 
                : () => _navigateToPurchase(productType: ProductType.dayPrediction),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportRow({
    required String icon,
    required String title,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isAvailable ? AppColors.textLight : AppColors.textMuted,
                fontWeight: isAvailable ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAvailable 
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.block,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isAvailable ? 'Voir' : 'Débloquer',
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? AppColors.primary : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.visibility,
            label: 'Voir résultats',
            onTap: _navigateToResults,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.shopping_bag,
            label: 'Acheter',
            onTap: () => _navigateToPurchase(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.block,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyPurchases() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aucun achat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Vos achats apparaîtront ici',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToPurchase(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Découvrir les offres',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPurchaseItem(Purchase purchase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                purchase.productType.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          
          const SizedBox(width: 14),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  purchase.productType.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(purchase.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount & Status - uses actual purchase amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${purchase.amountFcfa} FCFA',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: purchase.status == PurchaseStatus.success
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  purchase.status == PurchaseStatus.success ? 'Payé' : 'En cours',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: purchase.status == PurchaseStatus.success
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
