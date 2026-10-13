// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Deep Ocean Blue
  static const Color primary = Color(0xFF0D47A1);       // Deep Ocean Blue
  static const Color primaryMid = Color(0xFF1565C0);    // Ocean Blue
  static const Color primaryLight = Color(0xFF1976D2);  // Sky Blue
  static const Color primarySurface = Color(0xFFE3F2FD); // Light Blue Surface

  // Secondary - Sky Blue
  static const Color secondary = Color(0xFF29B6F6);     // Sky Blue
  static const Color secondaryLight = Color(0xFF81D4FA); // Light Sky

  // Accent - Seafoam / Turquoise
  static const Color accent = Color(0xFF00BCD4);        // Cyan / Turquoise
  static const Color accentLight = Color(0xFFE0F7FA);   // Light Cyan Surface

  // Backgrounds
  static const Color background = Color(0xFFF0F7FF);    // Soft Blue-White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F9FF);

  // Text
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMedium = Color(0xFF455A64);
  static const Color textLight = Color(0xFF90A4AE);
  static const Color white = Colors.white;

  // Status Colors
  static const Color terkumpul = Color(0xFF1E88E5);     // Blue
  static const Color tersalurkan = Color(0xFF00ACC1);   // Teal
  static const Color terkendali = Color(0xFF43A047);    // Green

  // Utility
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color divider = Color(0xFFE0EAF5);

  // Gradient
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF29B6F6)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
  );

  static const LinearGradient cardGradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF29B6F6)],
  );

  static const LinearGradient cardGradientTeal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00838F), Color(0xFF00BCD4)],
  );

  static const LinearGradient cardGradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
  );
}
