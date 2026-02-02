import 'package:flutter/material.dart';
import '../services/menu_config_service.dart';
import '../services/auth_service.dart';
import '../services/app_settings_service.dart';
import '../services/pricing_service.dart';
import '../widgets/hamburger_menu_overlay.dart';
import 'auth/login_page.dart';
import 'auth/simple_signup_screen.dart';
import 'purchase_history_screen.dart';
import 'temporal_purchase_screen.dart';
import 'cycles_vie_home_screen.dart';
import 'portrait_ame_purchase_screen.dart';
import 'personal_cycle_purchase_screen.dart';
import 'business_cycle_purchase_screen.dart';
import 'health_cycle_purchase_screen.dart';
import 'daily_guide_purchase_screen.dart';
import 'life_phase_purchase_screen.dart';
import 'lunar_timing_purchase_screen.dart';
import 'decision_advice_entry_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class to build dynamic menu entries based on admin configuration
class DynamicMenuBuilder {
  final BuildContext context;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onLogout;
  
  // Cached config
  Map<String, MenuItemConfig>? _menuConfig;
  
  DynamicMenuBuilder({
    required this.context,
    this.onLoginSuccess,
    this.onLogout,
  });
  
  /// Load menu configuration (call in initState or before building)
  Future<void> loadConfig() async {
    _menuConfig = await MenuConfigService.instance.getMenuConfig();
  }
  
  /// Check if a menu item is enabled
  bool isEnabled(String menuId) {
    return _menuConfig?[menuId]?.enabled ?? true;
  }
  
  /// Build menu entries based on admin configuration
  List<MenuEntry> buildMenuEntries() {
    final entries = <MenuEntry>[];
    final authService = AuthService.instance;
    final settings = AppSettingsService.instance;
    
    // Account actions (login/logout)
    if (authService.isLoggedIn) {
      // Mon Compte (always show if logged in)
      entries.add(MenuEntry(
        label: 'Mon Compte',
        onTap: () {
          _showSnack('Compte: ${authService.currentUser?.email}');
        },
      ));
      
      // Se déconnecter
      if (isEnabled('se_deconnecter')) {
        entries.add(MenuEntry(
          label: 'Se déconnecter',
          onTap: () {
            authService.signOut();
            onLogout?.call();
            _showSnack('Vous êtes déconnecté.');
          },
        ));
      }
    } else {
      // Se connecter
      if (isEnabled('se_connecter')) {
        entries.add(MenuEntry(
          label: 'Se connecter',
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) {
              onLoginSuccess?.call();
            }
          },
        ));
      }
      
      // Créer un compte
      if (isEnabled('creer_compte')) {
        entries.add(MenuEntry(
          label: 'Créer un compte',
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SimpleSignupScreen()),
            );
            if (result == true) {
              onLoginSuccess?.call();
            }
          },
        ));
      }
    }
    
    // Mes achats
    if (isEnabled('mes_achats')) {
      entries.add(MenuEntry(
        label: 'Mes achats',
        onTap: () async {
          if (authService.isLoggedIn) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
            );
          } else {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
              );
            }
          }
        },
      ));
    }
    
    // Prévisions Temporelles (accès direct au service)
    if (isEnabled('previsions_temporelles')) {
      entries.add(MenuEntry(
        label: '✨ Prévisions Temporelles',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TemporalPurchaseScreen()),
          );
        },
      ));
    }
    
    // Cycles de Vie (nouveau service)
    if (isEnabled('cycles_vie')) {
      entries.add(MenuEntry(
        label: '🌀 Cycles de Vie',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CyclesVieHomeScreen()),
          );
        },
      ));
    }
    
    // Portrait de l'Âme (Service 01)
    if (isEnabled('portrait_ame')) {
      final portraitPlan = PricingService.instance.portraitAmePlan;
      if (portraitPlan != null) {
        entries.add(MenuEntry(
          label: '✨ Portrait de l\'Âme',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PortraitAmePurchaseScreen(plan: portraitPlan),
              ),
            );
          },
        ));
      }
    }
    
    // Cycle Personnel (Service 02)
    if (isEnabled('cycle_personnel')) {
      final cyclePlan = PricingService.instance.getPlanByType('personal_cycle_annual');
      if (cyclePlan != null) {
        entries.add(MenuEntry(
          label: '🔄 Cycle Personnel',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PersonalCyclePurchaseScreen(plan: cyclePlan),
              ),
            );
          },
        ));
      }
    }
    
    // Cycle Business (Service 03)
    if (isEnabled('cycle_business')) {
      final businessPlan = PricingService.instance.getPlanByType('business_cycle_annual');
      if (businessPlan != null) {
        entries.add(MenuEntry(
          label: '💼 Cycle Business',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BusinessCyclePurchaseScreen(plan: businessPlan),
              ),
            );
          },
        ));
      }
    }
    
    // Cycle Santé (Service 04)
    if (isEnabled('cycle_sante')) {
      final healthPlan = PricingService.instance.getPlanByType('health_cycle_annual');
      if (healthPlan != null) {
        entries.add(MenuEntry(
          label: '🏥 Cycle Santé',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HealthCyclePurchaseScreen(plan: healthPlan),
              ),
            );
          },
        ));
      }
    }
    
    // Guide Horaire (Service 05)
    if (isEnabled('guide_horaire')) {
      final dailyPlan = PricingService.instance.getPlanByType('daily_guide_day');
      if (dailyPlan != null) {
        entries.add(MenuEntry(
          label: '⏰ Guide Horaire',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DailyGuidePurchaseScreen(plan: dailyPlan),
              ),
            );
          },
        ));
      }
    }
    
    // Éclairage Décision (Service 06)
    if (isEnabled('eclairage_decision')) {
      entries.add(MenuEntry(
        label: '💡 Éclairage Décision',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DecisionAdviceEntryScreen(),
            ),
          );
        },
      ));
    }
    
    // Phases de Vie (Service 07)
    if (isEnabled('phases_vie')) {
      final phasePlan = PricingService.instance.getPlanByType('life_phase_report');
      if (phasePlan != null) {
        entries.add(MenuEntry(
          label: '🔄 Phases de Vie',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LifePhasePurchaseScreen(plan: phasePlan),
              ),
            );
          },
        ));
      }
    }
    
    // Timing Lunaire (Service 08)
    if (isEnabled('timing_lunaire')) {
      final lunarPlan = PricingService.instance.getPlanByType('lunar_timing_monthly');
      if (lunarPlan != null) {
        entries.add(MenuEntry(
          label: '🌙 Timing Lunaire',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LunarTimingPurchaseScreen(plan: lunarPlan),
              ),
            );
          },
        ));
      }
    }
    
    // Contact options
    if (isEnabled('contacter')) {
      entries.add(MenuEntry(
        label: 'Contacter Growpeak Agence',
        onTap: () => _launchEmail(settings.contactEmail),
      ));
    }
    
    if (isEnabled('whatsapp')) {
      entries.add(MenuEntry(
        label: 'WhatsApp Growpeak Agence',
        onTap: () => _launchWhatsApp(settings.contactWhatsApp),
      ));
    }
    
    if (isEnabled('appeler')) {
      entries.add(MenuEntry(
        label: 'Appeler Growpeak Agence',
        onTap: () => _launchPhone(settings.contactWhatsApp),
      ));
    }
    
    return entries;
  }
  
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  Future<void> _launchEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Support Growpeak Agence'},
    );
    await _launchUri(uri);
  }
  
  Future<void> _launchWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(' ', '').replaceAll('+', '');
    final url = Uri.parse("https://wa.me/$cleanPhone");
    await _launchUri(url);
  }
  
  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await _launchUri(uri);
  }
  
  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showSnack('Impossible d\'ouvrir ce lien pour le moment.');
    }
  }
}
