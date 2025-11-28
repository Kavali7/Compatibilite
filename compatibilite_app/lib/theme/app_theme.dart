import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF14d5c2);
  static const Color secondary = Color(0xFF16786c);
  static const Color background = Color(0xFF142933);
  static const Color block = Color(0xFF1e3b48);
  static const Color textLight = Color(0xFFF2E6C4);
  static const Color textMuted = Color(0xFFB6C4CC);
  static const Color accentText = Color(0xFFFAF6E8);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.block,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.openSansTextTheme().apply(
      bodyColor: AppColors.accentText,
      displayColor: AppColors.accentText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: GoogleFonts.philosopher(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.block,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.4),
      ),
      labelStyle: const TextStyle(color: AppColors.textLight),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
  );
}
