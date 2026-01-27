/// Cycles de Vie Home Screen
/// Écran principal du service Cycles de Vie avec design cohérent
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../services/cycles_vie_service.dart';
import '../services/pricing_service.dart';
import '../widgets/animated_background.dart';
import 'cycles_vie_purchase_screen.dart';

/// Écran d'accueil du service Cycles de Vie
class CyclesVieHomeScreen extends StatefulWidget {
  const CyclesVieHomeScreen({super.key});

  @override
  State<CyclesVieHomeScreen> createState() => _CyclesVieHomeScreenState();
}

class _CyclesVieHomeScreenState extends State<CyclesVieHomeScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  
  List<PricingPlan> _plans = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _isLoading = true);
    
    try {
      // Timeout pour éviter chargement infini
      await PricingService.instance.fetchPlans().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Timeout: utilisation des plans par défaut');
          return <PricingPlan>[];
        },
      );
      _plans = PricingService.instance.plans
          .where((p) => p.planType.toLowerCase().contains('cycles'))
          .toList();
    } catch (e) {
      debugPrint('Erreur chargement plans: $e');
      // Continue avec plans vides, l'UI utilisera les défauts
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cycles de Vie',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 40,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(),
          const SizedBox(height: 28),

          // Services Section
          Text(
            '🌀 Nos services',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),

          // Plan Cards
          ..._buildPlanCards(),
          
          const SizedBox(height: 28),

          // How it works section
          _buildHowItWorksSection(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Cycles de Vie',
                  style: GoogleFonts.philosopher(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Découvrez vos rythmes naturels et optimisez vos décisions importantes grâce à l\'analyse de vos cycles personnels.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPlanCards() {
    if (_plans.isEmpty) {
      // Default plans if not loaded from API
      return [
        _buildServiceCard(
          icon: Icons.psychology,
          title: 'Lecture Stratégique',
          description: 'Analyse complète de votre profil Soul Cycle + tous vos cycles actuels',
          price: '5 FCFA',
          planType: 'cycles_strategique',
          plan: null,
        ),
        _buildServiceCard(
          icon: Icons.flash_on,
          title: 'Lecture Express',
          description: 'Découvrez votre cycle du jour avec les heures clés favorables',
          price: '5 FCFA',
          planType: 'cycles_express',
          plan: null,
        ),
        _buildServiceCard(
          icon: Icons.calendar_today,
          title: 'Consultation Date',
          description: 'Analyse personnalisée d\'une date spécifique pour une décision importante',
          price: '5 FCFA',
          planType: 'cycles_consultation',
          plan: null,
        ),
        _buildServiceCard(
          icon: Icons.star,
          title: 'Abonnement Premium',
          description: 'Notifications quotidiennes personnalisées + accès illimité',
          price: '5 FCFA / 30 jours',
          planType: 'cycles_premium',
          plan: null,
        ),
      ];
    }

    final priceFormat = NumberFormat('#,###', 'fr');
    return _plans.map((plan) {
      IconData icon;
      switch (plan.planType.toLowerCase()) {
        case 'cycles_strategique':
          icon = Icons.psychology;
          break;
        case 'cycles_express':
          icon = Icons.flash_on;
          break;
        case 'cycles_consultation':
          icon = Icons.calendar_today;
          break;
        default:
          icon = Icons.star;
      }
      
      return _buildServiceCard(
        icon: icon,
        title: plan.name,
        description: plan.description ?? '',
        price: '${priceFormat.format(plan.priceFcfa)} FCFA',
        planType: plan.planType,
        plan: plan,
      );
    }).toList();
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required String price,
    required String planType,
    PricingPlan? plan,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToPurchase(planType, plan),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.philosopher(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.philosopher(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textMuted,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💡 Comment ça marche ?',
          style: GoogleFonts.philosopher(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        _buildStepItem(
          number: '1',
          title: 'Votre date de naissance',
          description: 'Elle détermine votre profil Soul Cycle unique parmi les 14 possibles.',
        ),
        _buildStepItem(
          number: '2',
          title: 'Analyse des cycles',
          description: 'Notre algorithme calcule vos rythmes personnels (âme, quotidien, santé).',
        ),
        _buildStepItem(
          number: '3',
          title: 'Conseils personnalisés',
          description: 'Recevez des recommandations pour optimiser vos décisions importantes.',
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPurchase(String planType, PricingPlan? plan) {
    // Create a default plan if not provided
    final effectivePlan = plan ?? PricingPlan(
      id: planType,
      planType: planType,
      name: planType.replaceAll('cycles_', '').replaceAll('_', ' '),
      description: null,
      priceFcfa: 5,
      isActive: true,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CyclesViePurchaseScreen(
          planType: planType,
          plan: effectivePlan,
        ),
      ),
    );
  }
}
