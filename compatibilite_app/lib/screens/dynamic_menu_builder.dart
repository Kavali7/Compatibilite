import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import '../services/menu_config_service.dart';
import '../services/auth_service.dart';
import '../services/app_settings_service.dart';
import '../widgets/hamburger_menu_overlay.dart';
import 'auth/login_page.dart';
import 'auth/simple_signup_screen.dart';
import 'purchase_history_screen.dart';
import 'services_catalog_screen.dart';
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
    
    // ========================================
    // NOS SERVICES - Single unified catalog entry
    // ========================================
    // All individual service menu items have been consolidated into
    // a single "Nos Services" entry that opens the ServicesCatalogScreen
    if (isEnabled('services_catalog')) {
      entries.add(MenuEntry(
        label: '🌟 Nos Services',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ServicesCatalogScreen()),
          );
        },
      ));
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
    
    // Rafraîchir la page
    entries.add(MenuEntry(
      label: '🔄 Rafraîchir la page',
      onTap: () {
        if (kIsWeb) {
          // Use JS interop to reload the page
          _reloadPage();
        }
      },
    ));
    
    return entries;
  }
  
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  void _reloadPage() {
    html.window.location.reload();
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
