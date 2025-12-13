import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/pricing_service.dart';
import '../services/kkiapay_service.dart';
import '../theme/app_theme.dart';

/// Admin page for managing pricing plans and viewing transactions
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAuthenticated = false;
  final _passwordController = TextEditingController();
  List<PricingPlan> _plans = [];
  List<PaymentRecord> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await PricingService.instance.fetchPlans();
      _plans = PricingService.instance.plans;
      _payments = await KkiapayService.instance.getRecentPayments();
    } catch (e) {
      debugPrint('Admin loadData error: $e');
    }
    setState(() => _isLoading = false);
  }

  String get _adminPassword {
    return dotenv.env['ADMIN_PASSWORD'] ?? 'admin123';
  }

  void _authenticate() {
    if (_passwordController.text == _adminPassword) {
      setState(() => _isAuthenticated = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildLoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administration',
          style: GoogleFonts.philosopher(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Forfaits', icon: Icon(Icons.attach_money)),
            Tab(text: 'Transactions', icon: Icon(Icons.receipt_long)),
          ],
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPricingTab(),
          _buildTransactionsTab(),
        ],
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withBlue(30),
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            color: AppColors.block,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Accès Administration',
                    style: GoogleFonts.philosopher(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe admin',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    onSubmitted: (_) => _authenticate(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _authenticate,
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return _buildPlanEditCard(plan);
        },
      ),
    );
  }

  Widget _buildPlanEditCard(PricingPlan plan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.block,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    plan.isSubscription ? Icons.star : Icons.description,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        plan.planType == 'subscription' ? 'Abonnement' : 'Consultation',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    '${plan.priceFcfa} FCFA',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditDialog(plan),
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _togglePlanStatus(plan),
                    icon: Icon(plan.isActive ? Icons.visibility_off : Icons.visibility),
                    label: Text(plan.isActive ? 'Désactiver' : 'Activer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: plan.isActive ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(PricingPlan plan) async {
    final nameController = TextEditingController(text: plan.name);
    final priceController = TextEditingController(text: plan.priceFcfa.toString());
    final durationController = TextEditingController(
      text: plan.durationDays?.toString() ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.block,
        title: Text('Modifier ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom du forfait'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix (FCFA)',
                suffixText: 'FCFA',
              ),
            ),
            if (plan.isSubscription) ...[
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Durée (jours)',
                  suffixText: 'jours',
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await PricingService.instance.updatePlan(
          planId: plan.id,
          name: nameController.text,
          priceFcfa: int.tryParse(priceController.text),
          durationDays: int.tryParse(durationController.text),
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forfait mis à jour')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }

  Future<void> _togglePlanStatus(PricingPlan plan) async {
    try {
      await PricingService.instance.updatePlan(
        planId: plan.id,
        isActive: !plan.isActive,
      );
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Widget _buildTransactionsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_payments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: AppColors.textMuted),
            SizedBox(height: 16),
            Text(
              'Aucune transaction',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    // Calculate totals
    final totalRevenue = _payments
        .where((p) => p.status == PaymentStatus.success)
        .fold<int>(0, (sum, p) => sum + p.amountFcfa);
    final successfulPayments = _payments.where((p) => p.status == PaymentStatus.success).length;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: Column(
        children: [
          // Summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.monetization_on, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        '$totalRevenue FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Revenus totaux',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(height: 8),
                      Text(
                        '$successfulPayments',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Paiements réussis',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Transactions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _payments.length,
              itemBuilder: (context, index) {
                final payment = _payments[index];
                return _buildTransactionCard(payment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(PaymentRecord payment) {
    final isSuccess = payment.status == PaymentStatus.success;
    final statusColor = isSuccess ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.block,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(
            isSuccess ? Icons.check : Icons.pending,
            color: statusColor,
          ),
        ),
        title: Text(
          '${payment.amountFcfa} FCFA',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payment.planType == 'subscription' ? 'Abonnement' : 'Consultation',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              _formatDate(payment.createdAt),
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                payment.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
