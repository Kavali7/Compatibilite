import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/compatibility_wizard.dart';
import 'screens/temporal_purchase_screen.dart';
import 'screens/payment_callback_screen.dart';
import 'services/supabase_manager.dart';
import 'services/app_settings_service.dart';
import 'services/currency_service.dart';
import 'services/env_config.dart';
import 'services/analytics_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize French locale data for DateFormat
  await initializeDateFormatting('fr_FR', null);
  
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
  
  // Only try to load .env file on non-web platforms or in debug mode
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (_) {
        // Continue without env file - will use build-time variables
      }
    }
  }
  
  // Get Supabase config - prioritize build-time variables
  final supabaseUrl = EnvConfig.supabaseUrl;
  final supabaseAnonKey = EnvConfig.supabaseAnonKey;
  
  debugPrint('Main: SUPABASE_URL loaded: ${supabaseUrl.isNotEmpty ? "YES" : "NO"}');
  debugPrint('Main: SUPABASE_ANON_KEY loaded: ${supabaseAnonKey.isNotEmpty ? "YES" : "NO"}');
  
  try {
    // Init Supabase with timeout — required before app starts
    await SupabaseManager.init(
      url: supabaseUrl.isNotEmpty ? supabaseUrl : null,
      anonKey: supabaseAnonKey.isNotEmpty ? supabaseAnonKey : null,
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        debugPrint('Main: Supabase init timed out after 3s, continuing...');
      },
    );
    
    debugPrint('Main: Supabase ready, launching app immediately...');
  } catch (e) {
    debugPrint('Supabase init failed: $e');
    // Continue anyway, app will work with limited functionality
  }
  
  // Start the app IMMEDIATELY — don't wait for settings/currency
  runApp(const CompatibiliteApp());

  // Load settings and currency in background (non-blocking, fire-and-forget)
  // These will be available by the time the user interacts
  _loadBackgroundData();

  // Track app open event (fire-and-forget)
  AnalyticsService.instance.logAppOpen();
}

/// Background data loading — runs after runApp so splash disappears fast
Future<void> _loadBackgroundData() async {
  try {
    await AppSettingsService.instance.fetchSettings();
    debugPrint('Main: Settings loaded (background)');
  } catch (e) {
    debugPrint('Main: Settings load error: $e');
  }
  try {
    await CurrencyService.instance.loadCurrency();
    debugPrint('Main: Currency loaded (background)');
  } catch (e) {
    debugPrint('Main: Currency load error: $e');
  }
}

class CompatibiliteApp extends StatelessWidget {
  const CompatibiliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compatibilit\u00e9 & Guidance',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Use onGenerateRoute to handle payment callback for web
      onGenerateRoute: (settings) {
        // Check for payment callback route (FedaPay redirect)
        if (settings.name != null && settings.name!.contains('payment-callback')) {
          // Extract transaction ID from URL if present
          String? transactionId;
          final uri = Uri.tryParse(settings.name!);
          if (uri != null) {
            transactionId = uri.queryParameters['id'] ?? 
                           uri.queryParameters['transaction_id'];
          }
          
          return MaterialPageRoute(
            builder: (_) => PaymentCallbackScreen(
              transactionId: transactionId,
              onSuccess: () {
                debugPrint('FedaPay payment verified successfully');
              },
              onFailure: () {
                debugPrint('FedaPay payment verification failed');
              },
            ),
          );
        }
        
        // Default route
        return MaterialPageRoute(builder: (_) => _buildHomeScreen());
      },
      home: _buildHomeScreen(),
    );
  }

  static Widget _buildHomeScreen() {
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
