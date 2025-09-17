import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

/// AppTheme provides comprehensive theming for the Mishkat Al-Masabih app.
///
/// This class follows Material Design 3 principles and implements an Islamic-themed
/// color scheme with consistent component styling across the application.
///
/// Features:
/// - Light and dark theme support
/// - Islamic color palette (purple and gold)
/// - Consistent component theming
/// - Responsive design considerations
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration with Islamic design elements
  static ThemeData get lightTheme {
    return ThemeData(
      // Core theme properties
      fontFamily: 'Amiri', // Islamic-friendly Arabic font
      useMaterial3: true, // Latest Material Design
      brightness: Brightness.light,

      // Color scheme configuration
      colorScheme: _buildLightColorScheme(),

      // Scaffold and background theming
      scaffoldBackgroundColor: ColorsManager.primaryBackground,

      // Component themes
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),
      dividerTheme: _buildDividerTheme(),
      iconTheme: _buildIconTheme(),
      primaryIconTheme: _buildPrimaryIconTheme(),
      chipTheme: _buildChipTheme(),
      listTileTheme: _buildListTileTheme(),
      progressIndicatorTheme: _buildProgressIndicatorTheme(),
      switchTheme: _buildSwitchTheme(),
      checkboxTheme: _buildCheckboxTheme(),
      radioTheme: _buildRadioTheme(),
      sliderTheme: _buildSliderTheme(),
    );
  }

  /// Dark theme configuration with Islamic design elements
  static ThemeData get darkTheme {
    return ThemeData(
      // Core theme properties
      fontFamily: 'Amiri',
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme configuration
      colorScheme: _buildDarkColorScheme(),

      // Scaffold and background theming
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),

      // Component themes (dark mode specific)
      appBarTheme: _buildDarkAppBarTheme(),
      cardTheme: _buildDarkCardTheme(),
    );
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Builds the light color scheme with Islamic colors
  static ColorScheme _buildLightColorScheme() {
    return const ColorScheme.light(
      primary: ColorsManager.primaryPurple,
      secondary: ColorsManager.primaryGold,
      onSecondary: ColorsManager.primaryText,
      tertiary: ColorsManager.hadithAuthentic,
      onTertiary: ColorsManager.white,
      onSurface: ColorsManager.primaryText,
      error: ColorsManager.error,
    );
  }

  /// Builds the dark color scheme with Islamic colors
  static ColorScheme _buildDarkColorScheme() {
    return const ColorScheme.dark(
      primary: ColorsManager.primaryPurple,
      onPrimary: ColorsManager.white,
      secondary: ColorsManager.primaryGold,
      onSecondary: ColorsManager.white,
      tertiary: ColorsManager.hadithAuthentic,
      onTertiary: ColorsManager.white,
      surface: Color(0xFF1E1E1E),
      error: ColorsManager.error,
      onError: ColorsManager.white,
    );
  }

  /// Builds the app bar theme with Islamic styling
  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: ColorsManager.white,
      foregroundColor: ColorsManager.primaryPurple,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyles.headlineMedium.copyWith(
        color: ColorsManager.primaryPurple,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: ColorsManager.primaryPurple,
        size: 24,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  /// Builds the dark app bar theme
  static AppBarTheme _buildDarkAppBarTheme() {
    return AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: ColorsManager.primaryPurple,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyles.headlineMedium.copyWith(
        color: ColorsManager.primaryPurple,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: ColorsManager.primaryPurple,
        size: 24,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  /// Builds the card theme with enhanced shadows
  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: ColorsManager.cardBackground,
      elevation: 4,
      shadowColor: ColorsManager.primaryPurple.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      margin: EdgeInsets.all(Spacing.cardMargin),
    );
  }

  /// Builds the dark card theme
  static CardThemeData _buildDarkCardTheme() {
    return CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: ColorsManager.primaryPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      margin: EdgeInsets.all(Spacing.cardMargin),
    );
  }

  /// Builds the elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primaryPurple,
        foregroundColor: ColorsManager.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.buttonPadding,
          vertical: Spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.buttonRadius),
        ),
        textStyle: TextStyles.buttonText,
      ),
    );
  }

  /// Builds the outlined button theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorsManager.primaryPurple,
        side: const BorderSide(color: ColorsManager.primaryPurple, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.buttonPadding,
          vertical: Spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.buttonRadius),
        ),
        textStyle: TextStyles.buttonText.copyWith(
          color: ColorsManager.primaryPurple,
        ),
      ),
    );
  }

  /// Builds the text button theme
  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorsManager.primaryPurple,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        textStyle: TextStyles.linkText,
      ),
    );
  }

  /// Builds the input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: const BorderSide(color: ColorsManager.mediumGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: const BorderSide(color: ColorsManager.mediumGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: const BorderSide(
          color: ColorsManager.primaryPurple,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: const BorderSide(color: ColorsManager.error, width: 2),
      ),
      contentPadding: EdgeInsets.all(Spacing.inputPadding),
      hintStyle: TextStyles.bodyMedium.copyWith(
        color: ColorsManager.secondaryText,
      ),
      labelStyle: TextStyles.labelLarge,
      errorStyle: TextStyles.bodySmall.copyWith(color: ColorsManager.error),
    );
  }

  /// Builds the bottom navigation bar theme
  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme() {
    return const BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.white,
      selectedItemColor: ColorsManager.primaryPurple,
      unselectedItemColor: ColorsManager.gray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
    );
  }

  /// Builds the floating action button theme
  static FloatingActionButtonThemeData _buildFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: ColorsManager.primaryPurple,
      foregroundColor: ColorsManager.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  /// Builds the divider theme
  static DividerThemeData _buildDividerTheme() {
    return const DividerThemeData(
      color: ColorsManager.lightGray,
      thickness: 1,
      space: 1,
    );
  }

  /// Builds the icon theme
  static IconThemeData _buildIconTheme() {
    return const IconThemeData(color: ColorsManager.primaryPurple, size: 24);
  }

  /// Builds the primary icon theme
  static IconThemeData _buildPrimaryIconTheme() {
    return const IconThemeData(color: ColorsManager.primaryPurple, size: 24);
  }

  /// Builds the chip theme
  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: ColorsManager.lightGray,
      selectedColor: ColorsManager.primaryPurple,
      disabledColor: ColorsManager.mediumGray,
      labelStyle: TextStyles.labelMedium,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  /// Builds the list tile theme
  static ListTileThemeData _buildListTileTheme() {
    return ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.listItemPadding,
        vertical: Spacing.sm,
      ),
      titleTextStyle: TextStyles.titleMedium,
      subtitleTextStyle: TextStyles.bodyMedium,
      leadingAndTrailingTextStyle: TextStyles.bodySmall,
      tileColor: ColorsManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
    );
  }

  /// Builds the progress indicator theme
  static ProgressIndicatorThemeData _buildProgressIndicatorTheme() {
    return const ProgressIndicatorThemeData(
      color: ColorsManager.primaryPurple,
      linearTrackColor: ColorsManager.lightGray,
      circularTrackColor: ColorsManager.lightGray,
    );
  }

  /// Builds the switch theme
  static SwitchThemeData _buildSwitchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsManager.white;
        }
        return ColorsManager.gray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return ColorsManager.mediumGray;
      }),
    );
  }

  /// Builds the checkbox theme
  static CheckboxThemeData _buildCheckboxTheme() {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return Colors.transparent;
      }),
      checkColor: const WidgetStatePropertyAll(ColorsManager.cardBackground),
      side: const BorderSide(color: ColorsManager.mediumGray, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  /// Builds the radio theme
  static RadioThemeData _buildRadioTheme() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return ColorsManager.mediumGray;
      }),
    );
  }

  /// Builds the slider theme
  static SliderThemeData _buildSliderTheme() {
    return SliderThemeData(
      activeTrackColor: ColorsManager.primaryPurple,
      inactiveTrackColor: ColorsManager.lightGray,
      thumbColor: ColorsManager.primaryPurple,
      overlayColor: ColorsManager.primaryPurple.withOpacity(0.2),
      valueIndicatorColor: ColorsManager.primaryPurple,
      valueIndicatorTextStyle: TextStyles.labelMedium.copyWith(
        color: ColorsManager.white,
      ),
    );
  }
}
