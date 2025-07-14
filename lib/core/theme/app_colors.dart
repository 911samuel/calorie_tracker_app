import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryNeon = Color(0xFFD2FF00);
  static const Color darkBackground = Color(0xFF0C0C0C);
  static const Color cardGray = Color(0xFF2B2B2B);
  static const Color accentGreen = Color(0xFFC0FF00);

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLightGray = Color(0xFFCCCCCC);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryNeon, accentGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static Color primaryShadow = primaryNeon.withValues(alpha: 0.3);
  static Color accentShadow = accentGreen.withValues(alpha: 0.3);
  static Color cardShadow = Colors.black.withValues(alpha: 0.2);

  // Disabled Colors
  static const Color disabled = Color(0xFF666666);
  static const Color disabledLight = Color(0xFF999999);
}
