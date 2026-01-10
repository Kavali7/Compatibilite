/// Application routes
library;

import 'package:flutter/material.dart';
import '../screens/wizard/compatibility_wizard.dart';
import '../screens/purchase/purchase_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/account/account_screen.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/simple_signup_screen.dart';

/// Route names
class Routes {
  Routes._();
  
  static const String home = '/';
  static const String wizard = '/wizard';
  static const String purchase = '/purchase';
  static const String results = '/results';
  static const String account = '/account';
  static const String login = '/login';
  static const String signup = '/signup';
}

/// Route generator
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
      case Routes.wizard:
        return MaterialPageRoute(
          builder: (_) => const CompatibilityWizard(),
          settings: settings,
        );
      
      case Routes.purchase:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PurchaseScreen(
            coupleProfileId: args?['coupleProfileId'],
            preselectedProductType: args?['productType'],
          ),
          settings: settings,
        );
      
      case Routes.results:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ResultsScreen(
            coupleProfileId: args?['coupleProfileId'],
          ),
          settings: settings,
        );
      
      case Routes.account:
        return MaterialPageRoute(
          builder: (_) => const AccountScreen(),
          settings: settings,
        );
      
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      
      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => const SimpleSignupScreen(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
