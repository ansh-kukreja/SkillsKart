import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary brand palette (Warm Artisan Terracotta)
  static const Color primaryTerracotta = Color(0xFF8B3E0C);
  static const Color primaryTerracottaDark = Color(0xFF6B2E07);
  static const Color primaryTerracottaLight = Color(0xFFA95319);

  // Legacy aliases for backwards compatibility
  static const Color darkBrown = Color(0xFF8B3E0C);
  static const Color mediumBrown = Color(0xFFA95319);
  static const Color lightBrown = Color(0xFFD48B55);

  // Background & Surfaces
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color creamBg = Color(0xFFFAF7F2);
  static const Color cream = Color(0xFFFAF7F2);
  static const Color surfaceWarm = Color(0xFFF4EFEA);
  static const Color chipInactiveBg = Color(0xFFFFFFFF);
  static const Color searchBarBg = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color borderWarm = Color(0xFFEAE2D8);
  static const Color borderLight = Color(0xFFF2ECE4);

  // Typography
  static const Color textDark = Color(0xFF2B1B12);
  static const Color textBody = Color(0xFF4A3B32);
  static const Color textMuted = Color(0xFF8A7B70);
  static const Color textLight = Color(0xFFFFFFFF);

  // Accent & Status
  static const Color forestGreen = Color(0xFF4C7B1E);
  static const Color forestGreenLight = Color(0xFFEDF5E5);
  static const Color forestGreenDark = Color(0xFF335811);
  static const Color badgeDarkGreen = Color(0xFF1E3A15);
  static const Color amberStar = Color(0xFFE5881C);
  static const Color notificationRed = Color(0xFFE53935);
  static const Color cartFloatingBg = Color(0xFF823706);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.creamBg,
      primaryColor: AppColors.primaryTerracotta,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTerracotta,
        onPrimary: AppColors.primaryWhite,
        secondary: AppColors.forestGreen,
        onSecondary: AppColors.primaryWhite,
        surface: AppColors.primaryWhite,
        onSurface: AppColors.textDark,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.fraunces(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textDark,
          fontSize: 15,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textBody,
          fontSize: 13,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 11,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryTerracotta,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryWhite),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.primaryWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTerracotta,
          foregroundColor: AppColors.primaryWhite,
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.primaryWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderWarm, width: 1),
        ),
      ),
    );
  }
}