import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';

import 'colors.dart';
import 'styles.dart';
/*
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'YaModernPro',
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        
        primary: ColorsManager.primaryGreen,
        onPrimary: ColorsManager.white,
        secondary: ColorsManager.primaryGold,
        onSecondary: ColorsManager.black,
        tertiary: ColorsManager.primaryNavy,
        onTertiary: ColorsManager.white,
        surface: ColorsManager.cardBackground,
        onSurface: ColorsManager.primaryText,
        background: ColorsManager.primaryBackground,
        onBackground: ColorsManager.primaryText,
        error: ColorsManager.error,
        onError: ColorsManager.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: ColorsManager.primaryBackground,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsManager.white,
        foregroundColor: ColorsManager.primaryText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyles.headlineMedium.copyWith(
          color: ColorsManager.primaryText,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: ColorsManager.primaryText,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: ColorsManager.cardBackground,
        elevation: 2,
        shadowColor: ColorsManager.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
        margin: EdgeInsets.all(Spacing.cardMargin),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryGreen,
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
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsManager.primaryGreen,
          side: const BorderSide(color: ColorsManager.primaryGreen, width: 1.5),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.buttonPadding,
            vertical: Spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
          textStyle: TextStyles.buttonText.copyWith(
            color: ColorsManager.primaryGreen,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorsManager.primaryGreen,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          textStyle: TextStyles.linkText,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsManager.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: BorderSide(color: ColorsManager.mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: BorderSide(color: ColorsManager.mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: const BorderSide(
            color: ColorsManager.primaryGreen,
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
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorsManager.white,
        selectedItemColor: ColorsManager.primaryGreen,
        unselectedItemColor: ColorsManager.gray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorsManager.primaryGreen,
        foregroundColor: ColorsManager.white,
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: ColorsManager.lightGray,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: ColorsManager.primaryText,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: ColorsManager.primaryGreen,
        size: 24,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: ColorsManager.lightGray,
        selectedColor: ColorsManager.primaryGreen,
        disabledColor: ColorsManager.mediumGray,
        labelStyle: TextStyles.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
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
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorsManager.primaryGreen,
        linearTrackColor: ColorsManager.lightGray,
        circularTrackColor: ColorsManager.lightGray,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorsManager.white;
          }
          return ColorsManager.gray;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorsManager.primaryGreen;
          }
          return ColorsManager.mediumGray;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorsManager.primaryGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(ColorsManager.cardBackground),
        side: const BorderSide(color: ColorsManager.mediumGray, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorsManager.primaryGreen;
          }
          return ColorsManager.mediumGray;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: ColorsManager.primaryGreen,
        inactiveTrackColor: ColorsManager.lightGray,
        thumbColor: ColorsManager.primaryGreen,
        overlayColor: ColorsManager.primaryGreen.withOpacity(0.2),
        valueIndicatorColor: ColorsManager.primaryGreen,
        valueIndicatorTextStyle: TextStyles.labelMedium.copyWith(
          color: ColorsManager.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'YaModernPro',

      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme for dark theme
      colorScheme: const ColorScheme.dark(
        primary: ColorsManager.primaryGreen,
        onPrimary: ColorsManager.white,
        secondary: ColorsManager.primaryGold,
        onSecondary: ColorsManager.black,
        tertiary: ColorsManager.primaryNavy,
        onTertiary: ColorsManager.white,
        surface: Color(0xFF1E1E1E),
        onSurface: ColorsManager.white,
        background: Color(0xFF121212),
        onBackground: ColorsManager.white,
        error: ColorsManager.error,
        onError: ColorsManager.white,
      ),

      // Override other theme properties for dark mode
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),

      // You can add more dark theme customizations here
    );
  }
}
*/