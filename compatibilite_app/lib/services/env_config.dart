import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Conditional import for web-specific config
import 'web_config_stub.dart' if (dart.library.html) 'web_config.dart';

/// Centralized environment configuration
/// Priority: 1. Build-time variables, 2. window.flutterConfig (web), 3. dotenv (local dev)
class EnvConfig {
  // Build-time variables (compiled into the app)
  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String _kkiapayPublicKey = String.fromEnvironment('KKIAPAY_PUBLIC_KEY');
  static const String _fedapayPublicKey = String.fromEnvironment('FEDAPAY_PUBLIC_KEY');
  static const String _fedapaySecretKey = String.fromEnvironment('FEDAPAY_SECRET_KEY');
  static const String _fedapaySandbox = String.fromEnvironment('FEDAPAY_SANDBOX', defaultValue: 'false');
  static const String _kkiapaySandbox = String.fromEnvironment('KKIAPAY_SANDBOX', defaultValue: 'false');
  static const String _fedapayCallbackUrl = String.fromEnvironment('FEDAPAY_CALLBACK_URL');
  
  /// Get environment variable - prioritize build-time, then web config, fallback to dotenv
  static String get(String key) {
    // First try build-time variables (always available when built with --dart-define-from-file)
    final buildTimeValue = _getBuildTimeValue(key);
    if (buildTimeValue.isNotEmpty) return buildTimeValue;
    
    // On web, try window.flutterConfig (from env_config.js)
    if (kIsWeb) {
      final webValue = getWebConfigValue(key);
      if (webValue.isNotEmpty) return webValue;
    }
    
    // Fallback to dotenv (for local development)
    if (!kIsWeb) {
      return dotenv.env[key] ?? '';
    }
    
    return '';
  }
  
  static String _getBuildTimeValue(String key) {
    switch (key) {
      case 'SUPABASE_URL':
        return _supabaseUrl;
      case 'SUPABASE_ANON_KEY':
        return _supabaseAnonKey;
      case 'KKIAPAY_PUBLIC_KEY':
        return _kkiapayPublicKey;
      case 'FEDAPAY_PUBLIC_KEY':
        return _fedapayPublicKey;
      case 'FEDAPAY_SECRET_KEY':
        return _fedapaySecretKey;
      case 'FEDAPAY_SANDBOX':
        return _fedapaySandbox;
      case 'KKIAPAY_SANDBOX':
        return _kkiapaySandbox;
      case 'FEDAPAY_CALLBACK_URL':
        return _fedapayCallbackUrl;
      default:
        return '';
    }
  }
  
  // Convenience getters
  static String get supabaseUrl => get('SUPABASE_URL');
  static String get supabaseAnonKey => get('SUPABASE_ANON_KEY');
  static String get kkiapayPublicKey => get('KKIAPAY_PUBLIC_KEY');
  static String get fedapayPublicKey => get('FEDAPAY_PUBLIC_KEY');
  static String get fedapaySecretKey => get('FEDAPAY_SECRET_KEY');
  static bool get fedapaySandbox => get('FEDAPAY_SANDBOX').toLowerCase() == 'true';
  static bool get kkiapaySandbox => get('KKIAPAY_SANDBOX').toLowerCase() == 'true';
  static String get fedapayCallbackUrl => get('FEDAPAY_CALLBACK_URL');
}
