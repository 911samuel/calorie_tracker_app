import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryNeon = Color(0xFF5EC041); // Bright green
  static const Color lightBackground = Color(0xFFFFFFFF); // Pure white
  static const Color darkGreen = Color(0xFF2A6620);

  static const Color cardWhite = Color(0xFFF9F9F9); // Light card color
  static const Color accentGreen = Color(0xFFC0FF00); // Neon accent

  // Text Colors
  static const Color textBlack = Color(0xFF000000); // Main text
  static const Color textGray = Color(0xFF666666); // Secondary text
  static const Color textLightGray = Color(0xFF999999); // Placeholder

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

  // Additional colors for the ring progress bars
  static const Color carbsColor = Color(0xFFC0FF00); // Neon yellow-green
  static const Color proteinColor = Color(0xFFFF9800); // Orange
  static const Color fatColor = Color(0xFFF44336); // Red

  // Background ring colors (lighter versions)
  static const Color carbsBackground = Color(0xFFE8F5E8);
  static const Color proteinBackground = Color(0xFFFFF3E0);
  static const Color fatBackground = Color(0xFFFFEBEE);

  static const LinearGradient lightGradient = LinearGradient(
    colors: [lightBackground, cardWhite],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color primaryShadow = Color.fromRGBO(
    94,
    192,
    65,
    0.3,
  ); // #5EC041 @ 30%
  static const Color accentShadow = Color.fromRGBO(
    192,
    255,
    0,
    0.3,
  ); // #C0FF00 @ 30%
  static const Color cardShadow = Color.fromRGBO(0, 0, 0, 0.1); // Light shadow

  // Disabled Colors
  static const Color disabled = Color(0xFFCCCCCC);
  static const Color disabledLight = Color(0xFFE0E0E0);
}
