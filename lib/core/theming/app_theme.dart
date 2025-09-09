import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'colors.dart';
import 'styles.dart';

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
/// - Professional dark mode implementation
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
      dialogTheme: _buildDialogTheme(),
      bottomSheetTheme: _buildBottomSheetTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      tabBarTheme: _buildTabBarTheme(),
      drawerTheme: _buildDrawerTheme(),
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
      scaffoldBackgroundColor: ColorsManager.darkPrimaryBackground,
      cardColor: ColorsManager.darkCardBackground,

      // Component themes (dark mode specific)
      appBarTheme: _buildDarkAppBarTheme(),
      cardTheme: _buildDarkCardTheme(),
      elevatedButtonTheme: _buildDarkElevatedButtonTheme(),
      outlinedButtonTheme: _buildDarkOutlinedButtonTheme(),
      textButtonTheme: _buildDarkTextButtonTheme(),
      inputDecorationTheme: _buildDarkInputDecorationTheme(),
      bottomNavigationBarTheme: _buildDarkBottomNavigationBarTheme(),
      floatingActionButtonTheme: _buildDarkFloatingActionButtonTheme(),
      dividerTheme: _buildDarkDividerTheme(),
      iconTheme: _buildDarkIconTheme(),
      primaryIconTheme: _buildDarkPrimaryIconTheme(),
      chipTheme: _buildDarkChipTheme(),
      listTileTheme: _buildDarkListTileTheme(),
      progressIndicatorTheme: _buildDarkProgressIndicatorTheme(),
      switchTheme: _buildDarkSwitchTheme(),
      checkboxTheme: _buildDarkCheckboxTheme(),
      radioTheme: _buildDarkRadioTheme(),
      sliderTheme: _buildDarkSliderTheme(),
      dialogTheme: _buildDarkDialogTheme(),
      bottomSheetTheme: _buildDarkBottomSheetTheme(),
      snackBarTheme: _buildDarkSnackBarTheme(),
      tabBarTheme: _buildDarkTabBarTheme(),
      drawerTheme: _buildDarkDrawerTheme(),
    );
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Builds the light color scheme with Islamic colors
  static ColorScheme _buildLightColorScheme() {
    return const ColorScheme.light(
      primary: ColorsManager.primaryPurple,
      onPrimary: ColorsManager.white,
      secondary: ColorsManager.primaryGold,
      onSecondary: ColorsManager.primaryText,
      tertiary: ColorsManager.hadithAuthentic,
      onTertiary: ColorsManager.white,
      surface: ColorsManager.cardBackground,
      onSurface: ColorsManager.primaryText,
      background: ColorsManager.primaryBackground,
      onBackground: ColorsManager.primaryText,
      error: ColorsManager.error,
      onError: ColorsManager.white,
      outline: ColorsManager.mediumGray,
      shadow: ColorsManager.black,
    );
  }

  /// Builds the dark color scheme with Islamic colors
  static ColorScheme _buildDarkColorScheme() {
    return const ColorScheme.dark(
      primary: ColorsManager.primaryPurple,
      onPrimary: ColorsManager.white,
      secondary: ColorsManager.primaryGold,
      onSecondary: ColorsManager.darkPrimaryText,
      tertiary: ColorsManager.hadithAuthentic,
      onTertiary: ColorsManager.white,
      surface: ColorsManager.darkCardBackground,
      onSurface: ColorsManager.darkPrimaryText,
      background: ColorsManager.darkPrimaryBackground,
      onBackground: ColorsManager.darkPrimaryText,
      error: ColorsManager.error,
      onError: ColorsManager.white,
      outline: ColorsManager.darkBorder,
      shadow: ColorsManager.black,
    );
  }

  // ==================== LIGHT THEME COMPONENTS ====================

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
      shape: RoundedRectangleBorder(
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
        borderSide: BorderSide(color: ColorsManager.mediumGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: BorderSide(color: ColorsManager.mediumGray),
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
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.white;
        }
        return ColorsManager.gray;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return ColorsManager.mediumGray;
      }),
    );
  }

  /// Builds the checkbox theme
  static CheckboxThemeData _buildCheckboxTheme() {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(ColorsManager.cardBackground),
      side: const BorderSide(color: ColorsManager.mediumGray, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  /// Builds the radio theme
  static RadioThemeData _buildRadioTheme() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
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

  /// Builds the dialog theme
  static DialogTheme _buildDialogTheme() {
    return DialogTheme(
      backgroundColor: ColorsManager.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyles.headlineSmall,
      contentTextStyle: TextStyles.bodyMedium,
    );
  }

  /// Builds the bottom sheet theme
  static BottomSheetThemeData _buildBottomSheetTheme() {
    return BottomSheetThemeData(
      backgroundColor: ColorsManager.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  /// Builds the snack bar theme
  static SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      backgroundColor: ColorsManager.darkGray,
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: ColorsManager.white,
      ),
      actionTextColor: ColorsManager.primaryPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  /// Builds the tab bar theme
  static TabBarTheme _buildTabBarTheme() {
    return TabBarTheme(
      labelColor: ColorsManager.primaryPurple,
      unselectedLabelColor: ColorsManager.gray,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: ColorsManager.primaryPurple, width: 2),
      ),
      labelStyle: TextStyles.labelLarge,
      unselectedLabelStyle: TextStyles.labelMedium,
    );
  }

  /// Builds the drawer theme
  static DrawerThemeData _buildDrawerTheme() {
    return DrawerThemeData(
      backgroundColor: ColorsManager.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
    );
  }

  // ==================== DARK THEME COMPONENTS ====================

  /// Builds the dark app bar theme
  static AppBarTheme _buildDarkAppBarTheme() {
    return AppBarTheme(
      backgroundColor: ColorsManager.darkSecondaryBackground,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  /// Builds the dark card theme
  static CardThemeData _buildDarkCardTheme() {
    return CardThemeData(
      color: ColorsManager.darkCardBackground,
      elevation: 4,
      shadowColor: ColorsManager.primaryPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      margin: EdgeInsets.all(Spacing.cardMargin),
    );
  }

  /// Builds the dark elevated button theme
  static ElevatedButtonThemeData _buildDarkElevatedButtonTheme() {
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

  /// Builds the dark outlined button theme
  static OutlinedButtonThemeData _buildDarkOutlinedButtonTheme() {
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

  /// Builds the dark text button theme
  static TextButtonThemeData _buildDarkTextButtonTheme() {
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

  /// Builds the dark input decoration theme
  static InputDecorationTheme _buildDarkInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkCardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: BorderSide(color: ColorsManager.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.inputRadius),
        borderSide: BorderSide(color: ColorsManager.darkBorder),
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
        color: ColorsManager.darkSecondaryText,
      ),
      labelStyle: TextStyles.labelLarge.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      errorStyle: TextStyles.bodySmall.copyWith(color: ColorsManager.error),
    );
  }

  /// Builds the dark bottom navigation bar theme
  static BottomNavigationBarThemeData _buildDarkBottomNavigationBarTheme() {
    return const BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.darkSecondaryBackground,
      selectedItemColor: ColorsManager.primaryPurple,
      unselectedItemColor: ColorsManager.darkSecondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
    );
  }

  /// Builds the dark floating action button theme
  static FloatingActionButtonThemeData _buildDarkFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: ColorsManager.primaryPurple,
      foregroundColor: ColorsManager.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  /// Builds the dark divider theme
  static DividerThemeData _buildDarkDividerTheme() {
    return const DividerThemeData(
      color: ColorsManager.darkDivider,
      thickness: 1,
      space: 1,
    );
  }

  /// Builds the dark icon theme
  static IconThemeData _buildDarkIconTheme() {
    return const IconThemeData(color: ColorsManager.primaryPurple, size: 24);
  }

  /// Builds the dark primary icon theme
  static IconThemeData _buildDarkPrimaryIconTheme() {
    return const IconThemeData(color: ColorsManager.primaryPurple, size: 24);
  }

  /// Builds the dark chip theme
  static ChipThemeData _buildDarkChipTheme() {
    return ChipThemeData(
      backgroundColor: ColorsManager.darkBorder,
      selectedColor: ColorsManager.primaryPurple,
      disabledColor: ColorsManager.darkSecondaryText,
      labelStyle: TextStyles.labelMedium.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  /// Builds the dark list tile theme
  static ListTileThemeData _buildDarkListTileTheme() {
    return ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.listItemPadding,
        vertical: Spacing.sm,
      ),
      titleTextStyle: TextStyles.titleMedium.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      subtitleTextStyle: TextStyles.bodyMedium.copyWith(
        color: ColorsManager.darkSecondaryText,
      ),
      leadingAndTrailingTextStyle: TextStyles.bodySmall.copyWith(
        color: ColorsManager.darkSecondaryText,
      ),
      tileColor: ColorsManager.darkCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
    );
  }

  /// Builds the dark progress indicator theme
  static ProgressIndicatorThemeData _buildDarkProgressIndicatorTheme() {
    return const ProgressIndicatorThemeData(
      color: ColorsManager.primaryPurple,
      linearTrackColor: ColorsManager.darkBorder,
      circularTrackColor: ColorsManager.darkBorder,
    );
  }

  /// Builds the dark switch theme
  static SwitchThemeData _buildDarkSwitchTheme() {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.white;
        }
        return ColorsManager.darkSecondaryText;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return ColorsManager.darkBorder;
      }),
    );
  }

  /// Builds the dark checkbox theme
  static CheckboxThemeData _buildDarkCheckboxTheme() {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(ColorsManager.white),
      side: const BorderSide(color: ColorsManager.darkBorder, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  /// Builds the dark radio theme
  static RadioThemeData _buildDarkRadioTheme() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsManager.primaryPurple;
        }
        return ColorsManager.darkBorder;
      }),
    );
  }

  /// Builds the dark slider theme
  static SliderThemeData _buildDarkSliderTheme() {
    return SliderThemeData(
      activeTrackColor: ColorsManager.primaryPurple,
      inactiveTrackColor: ColorsManager.darkBorder,
      thumbColor: ColorsManager.primaryPurple,
      overlayColor: ColorsManager.primaryPurple.withOpacity(0.2),
      valueIndicatorColor: ColorsManager.primaryPurple,
      valueIndicatorTextStyle: TextStyles.labelMedium.copyWith(
        color: ColorsManager.white,
      ),
    );
  }

  /// Builds the dark dialog theme
  static DialogTheme _buildDarkDialogTheme() {
    return DialogTheme(
      backgroundColor: ColorsManager.darkCardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyles.headlineSmall.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: ColorsManager.darkSecondaryText,
      ),
    );
  }

  /// Builds the dark bottom sheet theme
  static BottomSheetThemeData _buildDarkBottomSheetTheme() {
    return BottomSheetThemeData(
      backgroundColor: ColorsManager.darkCardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  /// Builds the dark snack bar theme
  static SnackBarThemeData _buildDarkSnackBarTheme() {
    return SnackBarThemeData(
      backgroundColor: ColorsManager.darkSecondaryBackground,
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      actionTextColor: ColorsManager.primaryPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  /// Builds the dark tab bar theme
  static TabBarTheme _buildDarkTabBarTheme() {
    return TabBarTheme(
      labelColor: ColorsManager.primaryPurple,
      unselectedLabelColor: ColorsManager.darkSecondaryText,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: ColorsManager.primaryPurple, width: 2),
      ),
      labelStyle: TextStyles.labelLarge.copyWith(
        color: ColorsManager.darkPrimaryText,
      ),
      unselectedLabelStyle: TextStyles.labelMedium.copyWith(
        color: ColorsManager.darkSecondaryText,
      ),
    );
  }

  /// Builds the dark drawer theme
  static DrawerThemeData _buildDarkDrawerTheme() {
    return DrawerThemeData(
      backgroundColor: ColorsManager.darkCardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
    );
  }
}
