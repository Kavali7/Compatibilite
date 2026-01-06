import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/compatibility_wizard.dart';
import 'screens/temporal_purchase_screen.dart';
import 'services/supabase_manager.dart';
import 'services/app_settings_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Custom error widget to avoid red error screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                'Chargement en cours...',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  };
  
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    try {
      await dotenv.load(fileName: '.env.example');
    } catch (_) {
      // Continue without env file
    }
  }
  
  try {
    await SupabaseManager.init(
      url: dotenv.env['SUPABASE_URL'],
      anonKey: dotenv.env['SUPABASE_ANON_KEY'],
    );
    
    // Load app settings after Supabase is ready
    await AppSettingsService.instance.fetchSettings();
  } catch (e) {
    debugPrint('Supabase init failed: $e');
    // Continue anyway, app will work with limited functionality
  }
  
  runApp(const CompatibiliteApp());
}

class CompatibiliteApp extends StatelessWidget {
  const CompatibiliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compatibilité & Guidance',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    final settings = AppSettingsService.instance;
    
    // Route to the appropriate screen based on primary service setting
    switch (settings.primaryService) {
      case 'prevision_jour':
      case 'prevision_mois':
      case 'prevision_annee':
        // Temporal prediction services
        return const TemporalPurchaseScreen();
      case 'compatibilite':
      default:
        // Default to compatibility wizard
        return const CompatibilityWizard();
    }
  }
}
