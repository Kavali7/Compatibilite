import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_catalog_item.dart';
import '../services/menu_config_service.dart';
import '../services/pricing_service.dart';
import '../services/currency_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/service_catalog_card.dart';
import '../widgets/hamburger_menu_overlay.dart';
import '../widgets/auth_required_wrapper.dart';

// Import all service screens
import 'compatibility_wizard.dart';
import 'temporal_purchase_screen.dart';
import 'portrait_ame_purchase_screen.dart';
import 'personal_cycle_purchase_screen.dart';
import 'business_cycle_purchase_screen.dart';
import 'health_cycle_purchase_screen.dart';
import 'daily_guide_purchase_screen.dart';
import 'decision_advice_purchase_screen.dart';
import 'life_phase_purchase_screen.dart';
import 'lunar_timing_purchase_screen.dart';
import 'dynamic_menu_builder.dart';

/// Main services catalog screen showing all available services
class ServicesCatalogScreen extends StatefulWidget {
  const ServicesCatalogScreen({super.key});

  @override
  State<ServicesCatalogScreen> createState() => _ServicesCatalogScreenState();
}

class _ServicesCatalogScreenState extends State<ServicesCatalogScreen> {
  Map<String, MenuItemConfig>? _menuConfig;
  bool _isLoading = true;
  bool _isMenuOpen = false;
  late DynamicMenuBuilder _menuBuilder;

  @override
  void initState() {
    super.initState();
    _menuBuilder = DynamicMenuBuilder(
      context: context,
      onLoginSuccess: () => setState(() {}),
      onLogout: () => setState(() {}),
    );
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await MenuConfigService.instance.getMenuConfig();
      await _menuBuilder.loadConfig();
      if (mounted) {
        setState(() {
          _menuConfig = config;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading menu config: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isServiceEnabled(String serviceId) {
    return _menuConfig?[serviceId]?.enabled ?? true;
  }

  String? _getPriceLabel(String planType) {
    try {
      final plan = PricingService.instance.getPlanByType(planType);
      if (plan != null) {
        return CurrencyService.instance.formatAmount(plan.priceFcfa);
      }
    } catch (e) {
      debugPrint('Error getting price for $planType: $e');
    }
    return null;
  }

  void _navigateToService(Map<String, dynamic> serviceData) async {
    final serviceId = serviceData['id'] as String;
    final requiresAuth = serviceData['requiresAuth'] as bool? ?? true;
    final planType = serviceData['planType'] as String;

    // Check auth if required
    if (requiresAuth) {
      final authenticated = await AuthRequiredWrapper.ensureAuthenticated(context);
      if (!authenticated) return;
    }

    if (!mounted) return;

    // Navigate based on service ID
    switch (serviceId) {
      case 'compatibilite_couple':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CompatibilityWizard()),
        );
        break;
      case 'previsions_temporelles':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TemporalPurchaseScreen()),
        );
        break;
      case 'portrait_ame':
        final plan = PricingService.instance.portraitAmePlan;
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PortraitAmePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'cycle_personnel':
        final plan = PricingService.instance.getPlanByType('personal_cycle_annual');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PersonalCyclePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'cycle_business':
        final plan = PricingService.instance.getPlanByType('business_cycle_annual');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => BusinessCyclePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'cycle_sante':
        final plan = PricingService.instance.getPlanByType('health_cycle_annual');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => HealthCyclePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'guide_horaire':
        final plan = PricingService.instance.getPlanByType('daily_guide_day');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DailyGuidePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'eclairage_decision':
        final plan = PricingService.instance.getPlanByType('decision_credit');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DecisionAdvicePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'phases_vie':
        final plan = PricingService.instance.getPlanByType('life_phase_report');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LifePhasePurchaseScreen(plan: plan)),
          );
        }
        break;
      case 'timing_lunaire':
        final plan = PricingService.instance.getPlanByType('lunar_timing_monthly');
        if (plan != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LunarTimingPurchaseScreen(plan: plan)),
          );
        }
        break;
    }
  }

  void _toggleMenu() => setState(() => _isMenuOpen = !_isMenuOpen);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);
    // Higher ratio = more compact cards
    final childAspectRatio = screenWidth > 600 ? 1.1 : 1.2;

    // Filter enabled services
    final enabledServices = ServiceCatalogData.services
        .where((s) => _isServiceEnabled(s['id'] as String))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Animated background with stars
          AnimatedBackground(
            showStars: true,
            showOrbs: true,
            starCount: 40,
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        // Title
                        Text(
                          '🌟 Nos Services',
                          style: GoogleFonts.philosopher(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentText,
                          ),
                        ),
                        const Spacer(),
                        // Menu button
                        IconButton(
                          onPressed: _toggleMenu,
                          icon: const Icon(
                            Icons.menu,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Découvrez nos services de guidance personnalisée',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loading or Grid
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : enabledServices.isEmpty
                            ? Center(
                                child: Text(
                                  'Aucun service disponible pour le moment.',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  itemCount: enabledServices.length,
                                  itemBuilder: (context, index) {
                                    final service = enabledServices[index];
                                    return ServiceCatalogCard(
                                      emoji: service['emoji'] as String,
                                      name: service['name'] as String,
                                      advantages: List<String>.from(service['advantages'] as List),
                                      priceLabel: _getPriceLabel(service['planType'] as String),
                                      onTap: () => _navigateToService(service),
                                      animationDelay: index * 100,
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),

          // Hamburger menu overlay
          HamburgerMenuOverlay(
            isOpen: _isMenuOpen,
            onToggle: _toggleMenu,
            entries: _menuBuilder.buildMenuEntries(),
          ),
        ],
      ),
    );
  }
}
