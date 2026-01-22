import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized environment configuration
/// Prioritizes build-time variables (--dart-define-from-file) over runtime dotenv
class EnvConfig {
  // Build-time variables (compiled into the app)
  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String _kkiapayPublicKey = String.fromEnvironment('KKIAPAY_PUBLIC_KEY');
  static const String _fedapayPublicKey = String.fromEnvironment('FEDAPAY_PUBLIC_KEY');
  static const String _fedapaySecretKey = String.fromEnvironment('FEDAPAY_SECRET_KEY');
  static const String _fedapaySandbox = String.fromEnvironment('FEDAPAY_SANDBOX', defaultValue: 'false');
  static const String _kkiapaySandbox = String.fromEnvironment('KKIAPAY_SANDBOX', defaultValue: 'false');
  
  /// Get environment variable - prioritize build-time, fallback to dotenv
  static String get(String key) {
    // First try build-time variables (always available, even on web)
    switch (key) {
      case 'SUPABASE_URL':
        if (_supabaseUrl.isNotEmpty) return _supabaseUrl;
        break;
      case 'SUPABASE_ANON_KEY':
        if (_supabaseAnonKey.isNotEmpty) return _supabaseAnonKey;
        break;
      case 'KKIAPAY_PUBLIC_KEY':
        if (_kkiapayPublicKey.isNotEmpty) return _kkiapayPublicKey;
        break;
      case 'FEDAPAY_PUBLIC_KEY':
        if (_fedapayPublicKey.isNotEmpty) return _fedapayPublicKey;
        break;
      case 'FEDAPAY_SECRET_KEY':
        if (_fedapaySecretKey.isNotEmpty) return _fedapaySecretKey;
        break;
      case 'FEDAPAY_SANDBOX':
        if (_fedapaySandbox.isNotEmpty) return _fedapaySandbox;
        break;
      case 'KKIAPAY_SANDBOX':
        if (_kkiapaySandbox.isNotEmpty) return _kkiapaySandbox;
        break;
    }
    
    // Fallback to dotenv (for local development on non-web platforms)
    if (!kIsWeb) {
      return dotenv.env[key] ?? '';
    }
    
    return '';
  }
  
  // Convenience getters
  static String get supabaseUrl => get('SUPABASE_URL');
  static String get supabaseAnonKey => get('SUPABASE_ANON_KEY');
  static String get kkiapayPublicKey => get('KKIAPAY_PUBLIC_KEY');
  static String get fedapayPublicKey => get('FEDAPAY_PUBLIC_KEY');
  static String get fedapaySecretKey => get('FEDAPAY_SECRET_KEY');
  static bool get fedapaySandbox => get('FEDAPAY_SANDBOX').toLowerCase() == 'true';
  static bool get kkiapaySandbox => get('KKIAPAY_SANDBOX').toLowerCase() == 'true';
}
