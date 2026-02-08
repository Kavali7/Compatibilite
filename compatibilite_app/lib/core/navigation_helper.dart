/// Navigation Helper - Centralized navigation utilities
/// Provides consistent navigation behavior across the app
library;

import 'package:flutter/material.dart';
import '../screens/services_catalog_screen.dart';

/// Centralized navigation helper for consistent UX across the app
class NavigationHelper {
  /// Navigate to the services catalog, clearing the navigation stack
  /// Used after viewing reports to encourage service discovery
  static void goToMenu(BuildContext context) {
    // Navigate to "Nos Services" catalog — all buttons lead here
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ServicesCatalogScreen()),
      (route) => false,
    );
  }

  /// Navigate to the services catalog so user can purchase another service
  static void goToServices(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ServicesCatalogScreen()),
      (route) => false,
    );
  }
  
  /// Navigate to services catalog with a nice transition
  static void goToMenuWithTransition(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          const ServicesCatalogScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false,
    );
  }
}
