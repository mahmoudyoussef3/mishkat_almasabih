import 'package:flutter/material.dart';

class ColorsManager {
  // Primary Islamic Colors - Updated to match specifications
  static const Color primaryPurple = Color(0xFF7440E9); // Main brand color
  static const Color secondaryPurple = Color(
    0xFF9D7BF0,
  ); // Light purple for gradients
  static const Color primaryGold = Color(
    0xFFFFB300,
  ); // Islamic gold for decorations

  // Secondary Colors
  static const Color lightPurple = Color(
    0xFFB39DDB,
  ); // Lighter purple variations
  static const Color darkPurple = Color(
    0xFF5E35B1,
  ); // Darker purple for shadows
  static const Color accentPurple = Color(0xFF7C4DFF); // Accent purple

  // Background Colors
  static const Color primaryBackground = Color(
    0xFFFAFAFA,
  ); // Light cream/off-white
  static const Color secondaryBackground = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color overlayBackground = Color(
    0x80000000,
  ); // Semi-transparent overlay

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF616161);
  static const Color black = Color(0xFF212121);

  // Text Colors
  static const Color primaryText = Color(0xFF212121); // Dark grey for main text
  static const Color secondaryText = Color(
    0xFF757575,
  ); // Medium grey for secondary text
  static const Color disabledText = Color(
    0xFFBDBDBD,
  ); // Light grey for disabled
  static const Color inverseText = Color(
    0xFFFFFFFF,
  ); // White text on dark backgrounds
  static const Color purpleText = Color(0xFF7440E9); // Purple for highlights

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Green for authentic hadiths
  static const Color warning = Color(0xFFFF9800); // Orange for weak hadiths
  static const Color error = Color(0xFFE53935); // Red for errors
  static const Color info = Color(0xFF2196F3); // Blue for information

  // Islamic Theme Specific Colors
  static const Color hadithAuthentic = Color(0xFF4CAF50); // صحيح - Green
  static const Color hadithGood = Color(0xFF9C27B0); // حسن - Purple
  static const Color hadithWeak = Color(0xFFFF9800); // ضعيف - Orange

  // Legacy colors for backward compatibility
  static const Color primaryGreen = primaryPurple; // Updated to use purple
  static const Color secondaryGreen = secondaryPurple; // Updated to use purple
  static const Color primaryNavy = darkPurple; // Updated to use dark purple
  static const Color accentOrange = primaryGold; // Updated to use gold
  static const Color mainBlue = primaryPurple; // Updated to use purple
  static const Color lightBlue = lightPurple; // Updated to use light purple
  static const Color darkBlue = darkPurple; // Updated to use dark purple
}
