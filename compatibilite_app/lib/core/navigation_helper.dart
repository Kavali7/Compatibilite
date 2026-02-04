/// Navigation Helper - Centralized navigation utilities
/// Provides consistent navigation behavior across the app
library;

import 'package:flutter/material.dart';
import '../screens/compatibility_wizard.dart';

/// Centralized navigation helper for consistent UX across the app
class NavigationHelper {
  /// Navigate to the main menu, clearing the navigation stack
  /// Used after viewing reports to encourage service discovery
  static void goToMenu(BuildContext context) {
    // Use pushAndRemoveUntil to clear the stack and go to home/wizard
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const CompatibilityWizard()),
      (route) => false,
    );
  }
  
  /// Navigate to home with a nice transition
  static void goToMenuWithTransition(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          const CompatibilityWizard(),
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
