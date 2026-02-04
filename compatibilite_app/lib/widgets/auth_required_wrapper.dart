/// Auth Required Wrapper - Ensures user is authenticated before proceeding
/// Used to redirect unauthenticated users to login for paid services
library;

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_page.dart';

/// Utility class to handle authentication requirements for paid services
class AuthRequiredWrapper {
  /// Ensures user is authenticated before proceeding
  /// Returns true if user is logged in (or successfully logs in)
  /// Returns false if user cancels login
  static Future<bool> ensureAuthenticated(BuildContext context) async {
    // Already logged in
    if (AuthService.instance.isLoggedIn) {
      return true;
    }
    
    // Show login page and wait for result
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    
    // Check if login was successful
    return result == true && AuthService.instance.isLoggedIn;
  }
  
  /// Shows a snackbar message if authentication is required
  static void showAuthRequiredMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Veuillez vous connecter pour accéder à ce service'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
