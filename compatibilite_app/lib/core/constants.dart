/// Core constants for the Compatibilité & Guidance app
library;

import 'package:flutter/material.dart';

/// App color palette - Mystical dark theme
class AppColors {
  AppColors._();
  
  // Primary colors
  static const Color primary = Color(0xFF14D5C2);
  static const Color secondary = Color(0xFF16786C);
  
  // Background colors
  static const Color background = Color(0xFF142933);
  static const Color block = Color(0xFF1E3B48);
  
  // Text colors
  static const Color textLight = Color(0xFFF2E6C4);
  static const Color textMuted = Color(0xFFB6C4CC);
  static const Color accentText = Color(0xFFFAF6E8);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
}

/// API configuration
class ApiConfig {
  ApiConfig._();
  
  // Supabase configuration - loaded from .env
  static String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  
  // Payment providers
  static const String kkiapayPublicKeyEnv = 'KKIAPAY_PUBLIC_KEY';
  static const String fedapayPublicKeyEnv = 'FEDAPAY_PUBLIC_KEY';
  static const String fedapaySecretKeyEnv = 'FEDAPAY_SECRET_KEY';
}

/// App-wide constants
class AppConstants {
  AppConstants._();
  
  static const String appName = 'Compatibilité & Guidance';
  static const String appVersion = '2.0.0';
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Numerology constants
  static const List<int> masterNumbers = [11, 22, 33];
  static const int maxLifePathNumber = 9;
}
