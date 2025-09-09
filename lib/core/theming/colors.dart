import 'package:flutter/material.dart';

/// ColorsManager provides a comprehensive color palette for the Mishkat Al-Masabih app.
///
/// This class implements an Islamic-themed color scheme with:
/// - Primary Islamic colors (purple and gold)
/// - Semantic colors for different states
/// - Background and surface colors
/// - Text colors for various contexts
/// - Legacy color support for backward compatibility
///
/// All colors are designed to work together harmoniously and provide
/// excellent contrast for accessibility.
class ColorsManager {
  static const Color primaryPurple = Color(0xFF7440E9);

  static const Color secondaryPurple = Color(0xFF9D7BF0);

  static const Color primaryGold = Color(0xFFFFB300);

  // ==================== SECONDARY COLOR VARIATIONS ====================

  /// Lighter purple for subtle backgrounds and overlays
  static const Color lightPurple = Color(0xFFB39DDB);

  /// Darker purple for shadows and depth
  static const Color darkPurple = Color(0xFF5E35B1);

  /// Accent purple for interactive elements
  static const Color accentPurple = Color(0xFF7C4DFF);

  // ==================== BACKGROUND COLORS ====================

  /// Primary background color - Light cream/off-white
  /// Main app background for comfortable reading
  static const Color primaryBackground = Color(0xFFFAFAFA);

  /// Secondary background - Pure white
  /// Used for cards and elevated surfaces
  static const Color secondaryBackground = Color(0xFFFFFFFF);

  /// Card background - White cards
  /// Default background for card components
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Semi-transparent overlay for modals and dialogs
  static const Color overlayBackground = Color(0x80000000);

  // ==================== NEUTRAL COLORS ====================

  /// Pure white for text and icons on dark backgrounds
  static const Color white = Color(0xFFFFFFFF);

  /// Off-white for subtle backgrounds
  static const Color offWhite = Color(0xFFFAFAFA);

  /// Light gray for borders and subtle backgrounds
  static const Color lightGray = Color(0xFFF5F5F5);

  /// Medium gray for disabled states and borders
  static const Color mediumGray = Color(0xFFE0E0E0);

  /// Standard gray for secondary text
  static const Color gray = Color(0xFF9E9E9E);

  /// Dark gray for emphasis and borders
  static const Color darkGray = Color(0xFF616161);

  /// Near black for primary text
  static const Color black = Color(0xFF212121);

  // ==================== TEXT COLORS ====================

  /// Primary text color - Dark grey for main content
  /// Used for headings and important text
  static const Color primaryText = Color(0xFF212121);

  /// Secondary text color - Medium grey for supporting content
  /// Used for descriptions and less important text
  static const Color secondaryText = Color(0xFF757575);

  /// Disabled text color - Light grey for inactive content
  /// Used for disabled buttons and inactive elements
  static const Color disabledText = Color(0xFFBDBDBD);

  /// Inverse text color - White text on dark backgrounds
  /// Used for text on colored backgrounds
  static const Color inverseText = Color(0xFFFFFFFF);

  /// Purple text for highlights and links
  /// Used for interactive text elements
  static const Color purpleText = Color(0xFF7440E9);

  // ==================== SEMANTIC COLORS ====================

  /// Success color - Green for positive actions
  /// Used for success messages and confirmations
  static const Color success = Color(0xFF4CAF50);

  /// Warning color - Orange for caution
  /// Used for warning messages and alerts
  static const Color warning = Color(0xFFFF9800);

  /// Error color - Red for errors and failures
  /// Used for error messages and destructive actions
  static const Color error = Color(0xFFE53935);

  /// Info color - Blue for informational content
  /// Used for info messages and help text
  static const Color info = Color(0xFF2196F3);

  // ==================== HADITH-SPECIFIC COLORS ====================

  /// Color for authentic hadiths (صحيح)
  /// Green color indicating highest authenticity
  static const Color hadithAuthentic = Color(0xFF4CAF50);

  /// Color for good hadiths (حسن)
  /// Purple color indicating good authenticity
  static const Color hadithGood = Color(0xFF9C27B0);

  /// Color for weak hadiths (ضعيف)
  /// Orange color indicating lower authenticity
  static const Color hadithWeak = Color(0xFFFF9800);

  // ==================== LEGACY COLOR SUPPORT ====================
  // These colors maintain backward compatibility with existing code
  // while mapping to the new Islamic color scheme

  /// Legacy primary green - now maps to primaryPurple
  /// @deprecated Use primaryPurple instead
  static const Color primaryGreen = primaryPurple;

  /// Legacy secondary green - now maps to secondaryPurple
  /// @deprecated Use secondaryPurple instead
  static const Color secondaryGreen = secondaryPurple;

  /// Legacy primary navy - now maps to darkPurple
  /// @deprecated Use darkPurple instead
  static const Color primaryNavy = darkPurple;

  /// Legacy accent orange - now maps to primaryGold
  /// @deprecated Use primaryGold instead
  static const Color accentOrange = primaryGold;

  /// Legacy main blue - now maps to primaryPurple
  /// @deprecated Use primaryPurple instead
  static const Color mainBlue = primaryPurple;

  /// Legacy light blue - now maps to lightPurple
  /// @deprecated Use lightPurple instead
  static const Color lightBlue = lightPurple;

  /// Legacy dark blue - now maps to darkPurple
  /// @deprecated Use darkPurple instead
  static const Color darkBlue = darkPurple;

  // ==================== DARK MODE COLORS ====================

  /// Dark mode primary background - Deep dark gray
  static const Color darkPrimaryBackground = Color(0xFF121212);

  /// Dark mode secondary background - Slightly lighter dark gray
  static const Color darkSecondaryBackground = Color(0xFF1E1E1E);

  /// Dark mode card background - Dark gray for cards
  static const Color darkCardBackground = Color(0xFF2D2D2D);

  /// Dark mode surface color - For elevated surfaces
  static const Color darkSurface = Color(0xFF2D2D2D);

  /// Dark mode primary text - Light gray for readability
  static const Color darkPrimaryText = Color(0xFFE0E0E0);

  /// Dark mode secondary text - Medium light gray
  static const Color darkSecondaryText = Color(0xFFB0B0B0);

  /// Dark mode disabled text - Dark gray for disabled elements
  static const Color darkDisabledText = Color(0xFF757575);

  /// Dark mode border color - Subtle gray for borders
  static const Color darkBorder = Color(0xFF404040);

  /// Dark mode divider color - Subtle separator
  static const Color darkDivider = Color(0xFF333333);

  /// Dark mode shadow color - Dark shadow for depth
  static const Color darkShadow = Color(0x40000000);

  /// Dark mode overlay background - Semi-transparent dark
  static const Color darkOverlayBackground = Color(0x80000000);

  // ==================== THEME-AWARE COLOR METHODS ====================

  /// Get background color based on theme brightness
  static Color getBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkPrimaryBackground
        : primaryBackground;
  }

  /// Get card background color based on theme brightness
  static Color getCardBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkCardBackground : cardBackground;
  }

  /// Get primary text color based on theme brightness
  static Color getPrimaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkPrimaryText : primaryText;
  }

  /// Get secondary text color based on theme brightness
  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkSecondaryText : secondaryText;
  }

  /// Get border color based on theme brightness
  static Color getBorderColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkBorder : mediumGray;
  }

  /// Get divider color based on theme brightness
  static Color getDividerColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkDivider : lightGray;
  }

  /// Get shadow color based on theme brightness
  static Color getShadowColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkShadow : black.withOpacity(0.1);
  }

  // ==================== UTILITY METHODS ====================

  /// Creates a color with opacity for overlays and backgrounds
  ///
  /// [color] - The base color to modify
  /// [opacity] - Opacity value between 0.0 and 1.0
  ///
  /// Returns a new color with the specified opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Gets a list of primary colors for gradient generation
  ///
  /// Returns a list of primary colors suitable for gradients
  static List<Color> get primaryColors => [
    primaryPurple,
    secondaryPurple,
    accentPurple,
  ];

  /// Gets a list of accent colors for highlights
  ///
  /// Returns a list of accent colors for UI highlights
  static List<Color> get accentColors => [
    primaryGold,
    hadithAuthentic,
    hadithGood,
  ];

  /// Gets a list of dark mode colors for gradients
  ///
  /// Returns a list of colors suitable for dark mode gradients
  static List<Color> get darkModeColors => [
    darkPrimaryBackground,
    darkSecondaryBackground,
    darkCardBackground,
  ];
}
