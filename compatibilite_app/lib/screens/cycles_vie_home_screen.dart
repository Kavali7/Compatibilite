import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/cycles_vie_service.dart';
import '../services/pricing_service.dart';
import '../widgets/common/custom_app_bar.dart';
import 'cycles_vie_purchase_screen.dart';
import 'cycles_vie_report_screen.dart';

/// Écran d'accueil pour le service Cycles de Vie.
/// Présente les différentes offres et permet l'achat/accès aux rapports.
class CyclesVieHomeScreen extends StatefulWidget {
  const CyclesVieHomeScreen({super.key});

  @override
  State<CyclesVieHomeScreen> createState() => _CyclesVieHomeScreenState();
}

class _CyclesVieHomeScreenState extends State<CyclesVieHomeScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  final PricingService _pricingService = PricingService();

  bool _isLoading = true;
  List<PricingPlan> _plans = [];
  CyclePurchase? _activeSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Charger les plans tarifaires pour Cycles de Vie
      final allPlans = await _pricingService.fetchPlans();
      _plans = allPlans
          .where((p) => p.planType.startsWith('cycle_vie_') && p.isActive)
          .toList();

      // Vérifier si l'utilisateur a un abonnement actif
      _activeSubscription =
          await _cyclesService.getValidPurchase('abonnement');
    } catch (e) {
      debugPrint('Erreur chargement Cycles de Vie: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '🌀 Cycles de Vie'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 24),
                    if (_activeSubscription != null) _buildActiveSubscription(),
                    const SizedBox(height: 16),
                    _buildServicesGrid(),
                    const SizedBox(height: 24),
                    _buildInfoSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌀 Maîtrisez vos Cycles de Vie',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrez les périodes favorables pour vos décisions importantes '
            'basées sur votre date de naissance et les cycles naturels.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green.shade700, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👑 Abonnement Premium Actif',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                if (_activeSubscription!.expiresAt != null)
                  Text(
                    'Expire le ${DateFormat('d MMMM yyyy', 'fr_FR').format(_activeSubscription!.expiresAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _navigateToReport('abonnement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Mes Rapports'),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      _ServiceCard(
        planType: 'cycle_vie_express',
        title: '⚡ Lecture Express',
        subtitle: 'Analyse du jour',
        description: 'Votre cycle du jour avec les heures clés favorables et défavorables.',
        icon: Icons.flash_on,
        color: Colors.amber,
      ),
      _ServiceCard(
        planType: 'cycle_vie_strategique',
        title: '🎯 Lecture Stratégique',
        subtitle: 'Plage de 7 jours',
        description: 'Planifiez votre semaine selon vos cycles personnels.',
        icon: Icons.calendar_view_week,
        color: Colors.indigo,
      ),
      _ServiceCard(
        planType: 'cycle_vie_consultation',
        title: '📅 Consultation Date',
        subtitle: 'Date spécifique',
        description: 'Analysez une date précise pour un événement important.',
        icon: Icons.event_available,
        color: Colors.teal,
      ),
      _ServiceCard(
        planType: 'cycle_vie_abonnement',
        title: '👑 Abonnement Premium',
        subtitle: '30 jours illimités',
        description: 'Accès complet à tous les services pendant 1 mois.',
        icon: Icons.workspace_premium,
        color: Colors.purple,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nos Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            final plan = _plans.firstWhere(
              (p) => p.planType == service.planType,
              orElse: () => PricingPlan.empty(),
            );

            return _buildServiceCard(service, plan);
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(_ServiceCard service, PricingPlan plan) {
    final hasAccess = _activeSubscription != null;

    return GestureDetector(
      onTap: () => hasAccess
          ? _navigateToReport(service.planType)
          : _navigateToPurchase(service.planType, plan),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: service.color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: service.color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: service.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(service.icon, color: service.color, size: 24),
                ),
                if (plan.priceFcfa > 0)
                  Text(
                    '${plan.priceFcfa} FCFA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: service.color,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              service.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              service.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                service.description,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: hasAccess
                    ? Colors.green.shade100
                    : service.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hasAccess ? '✓ Accès inclus' : 'Commander →',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: hasAccess ? Colors.green.shade700 : service.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Comment ça marche ?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            '1️⃣',
            'Entrez votre date de naissance',
          ),
          _buildInfoItem(
            '2️⃣',
            'Choisissez le type d\'analyse souhaité',
          ),
          _buildInfoItem(
            '3️⃣',
            'Recevez votre lecture personnalisée',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(number, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPurchase(String planType, PricingPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CyclesViePurchaseScreen(
          planType: planType,
          plan: plan,
        ),
      ),
    ).then((_) => _loadData()); // Recharger après achat
  }

  void _navigateToReport(String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CyclesVieReportScreen(
          serviceType: serviceType,
        ),
      ),
    );
  }
}

class _ServiceCard {
  final String planType;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  _ServiceCard({
    required this.planType,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
