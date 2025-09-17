import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/font_weight_helper.dart';

/// TextStyles provides a comprehensive typography system for the Mishkat Al-Masabih app.
///
/// This class implements a hierarchical text styling system with:
/// - Display styles for large headings
/// - Headline styles for section headers
/// - Title styles for card titles and navigation
/// - Body styles for main content
/// - Label styles for form elements and buttons
/// - Special Islamic-themed styles
/// - Legacy styles for backward compatibility
///
/// All styles use responsive sizing with ScreenUtil and maintain
/// consistent typography hierarchy throughout the app.
class TextStyles {
  // ==================== DISPLAY STYLES ====================
  // Large, prominent text for main headings and hero sections

  /// Largest display text - 32sp, bold weight
  /// Used for main page titles and hero sections
  static TextStyle displayLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
    letterSpacing: -0.5,
  );

  /// Medium display text - 28sp, bold weight
  /// Used for major section headings
  static TextStyle displayMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
    letterSpacing: -0.25,
  );

  /// Small display text - 24sp, bold weight
  /// Used for section headings and important titles
  static TextStyle displaySmall = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
  );

  // ==================== HEADLINE STYLES ====================
  // Section headers and important text for content organization

  /// Large headline - 22sp, bold weight
  /// Used for main section headers
  static TextStyle headlineLarge = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
  );

  /// Medium headline - 20sp, semi-bold weight
  /// Used for subsection headers
  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );

  /// Small headline - 18sp, semi-bold weight
  /// Used for minor section headers
  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );

  // ==================== TITLE STYLES ====================
  // Card titles, navigation items, and prominent text

  /// Large title - 16sp, semi-bold weight
  /// Used for card titles and navigation headers
  static TextStyle titleLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );

  /// Medium title - 15sp, medium weight
  /// Used for list item titles and secondary headers
  static TextStyle titleMedium = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );

  /// Small title - 14sp, medium weight
  /// Used for minor titles and labels
  static TextStyle titleSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );

  // ==================== BODY STYLES ====================
  // Main content text with optimal readability

  /// Large body text - 16sp, regular weight, 1.5 line height
  /// Used for main content and important text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.5,
  );

  /// Medium body text - 14sp, regular weight, 1.4 line height
  /// Used for standard content and descriptions
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.4,
  );

  /// Small body text - 12sp, regular weight, 1.3 line height
  /// Used for captions and secondary information
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.secondaryText,
    height: 1.3,
  );

  // ==================== LABEL STYLES ====================
  // Form labels, buttons, and interactive elements

  /// Large label - 14sp, medium weight
  /// Used for form labels and button text
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );

  /// Medium label - 12sp, medium weight
  /// Used for secondary labels and small buttons
  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );

  /// Small label - 11sp, medium weight
  /// Used for micro labels and captions
  static TextStyle labelSmall = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.secondaryText,
  );

  // ==================== ISLAMIC-THEMED STYLES ====================
  // Special styles for Islamic content and cultural elements

  /// Arabic title style with Islamic color and enhanced spacing
  /// Used for Arabic text headers and titles
  static TextStyle arabicTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryPurple,
    letterSpacing: 0.5,
  );

  /// Hadith text style with italic emphasis and optimal line height
  /// Used for displaying hadith content
  static TextStyle hadithText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  /// Quran text style with enhanced readability
  /// Used for Quran verses and religious text
  static TextStyle quranText = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.darkPurple,
    height: 1.7,
  );

  /// Author name style with gold accent
  /// Used for displaying author names and attributions
  static TextStyle authorName = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryGold,
  );

  /// Category label style with secondary color
  /// Used for category tags and labels
  static TextStyle categoryLabel = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.secondaryPurple,
    letterSpacing: 0.5,
  );

  // ==================== INTERACTIVE STYLES ====================
  // Button text and interactive element styles

  /// Button text style with white color and enhanced spacing
  /// Used for primary buttons and call-to-action elements
  static TextStyle buttonText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.white,
    letterSpacing: 0.5,
  );

  /// Link text style with purple color and underline
  /// Used for clickable links and navigation elements
  static TextStyle linkText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryPurple,
    decoration: TextDecoration.underline,
  );

  // ==================== LEGACY STYLES ====================
  // Backward compatibility styles for existing code
  // These will be gradually replaced with the new system

  /// Legacy 24sp black bold text
  /// @deprecated Use displaySmall.copyWith(color: ColorsManager.black) instead
  static TextStyle font24BlackBold = displaySmall.copyWith(
    color: ColorsManager.black,
  );

  /// Legacy 32sp blue bold text
  /// @deprecated Use displayLarge.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font32BlueBold = displayLarge.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 13sp blue semi-bold text
  /// @deprecated Use labelLarge.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font13BlueSemiBold = labelLarge.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 13sp dark blue medium text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font13DarkBlueMedium = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 13sp dark blue regular text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font13DarkBlueRegular = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 24sp blue bold text
  /// @deprecated Use displaySmall.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font24BlueBold = displaySmall.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 16sp white semi-bold text
  /// @deprecated Use bodyLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.semiBold) instead
  static TextStyle font16WhiteSemiBold = bodyLarge.copyWith(
    color: ColorsManager.white,
    fontWeight: FontWeightHelper.semiBold,
  );

  /// Legacy 13sp gray regular text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.gray) instead
  static TextStyle font13GrayRegular = bodyMedium.copyWith(
    color: ColorsManager.gray,
  );

  /// Legacy 12sp gray regular text
  /// @deprecated Use bodySmall.copyWith(color: ColorsManager.gray) instead
  static TextStyle font12GrayRegular = bodySmall.copyWith(
    color: ColorsManager.gray,
  );

  /// Legacy 12sp gray medium text
  /// @deprecated Use bodySmall.copyWith(fontWeight: FontWeightHelper.medium) instead
  static TextStyle font12GrayMedium = bodySmall.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  /// Legacy 12sp dark blue regular text
  /// @deprecated Use bodySmall.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font12DarkBlueRegular = bodySmall.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 12sp blue regular text
  /// @deprecated Use bodySmall.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font12BlueRegular = bodySmall.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 13sp blue regular text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font13BlueRegular = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 14sp gray regular text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.gray) instead
  static TextStyle font14GrayRegular = bodyMedium.copyWith(
    color: ColorsManager.gray,
  );

  /// Legacy 14sp light gray regular text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.lightGray) instead
  static TextStyle font14LightGrayRegular = bodyMedium.copyWith(
    color: ColorsManager.lightGray,
  );

  /// Legacy 14sp dark blue medium text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple, fontWeight: FontWeightHelper.medium) instead
  static TextStyle font14DarkBlueMedium = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
    fontWeight: FontWeightHelper.medium,
  );

  /// Legacy 14sp dark blue bold text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple, fontWeight: FontWeightHelper.bold) instead
  static TextStyle font14DarkBlueBold = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
    fontWeight: FontWeightHelper.bold,
  );

  /// Legacy 16sp white medium text
  /// @deprecated Use bodyLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.medium) instead
  static TextStyle font16WhiteMedium = bodyLarge.copyWith(
    color: ColorsManager.white,
    fontWeight: FontWeightHelper.medium,
  );

  /// Legacy 14sp blue semi-bold text
  /// @deprecated Use bodyMedium.copyWith(color: ColorsManager.darkPurple, fontWeight: FontWeightHelper.semiBold) instead
  static TextStyle font14BlueSemiBold = bodyMedium.copyWith(
    color: ColorsManager.darkPurple,
    fontWeight: FontWeightHelper.semiBold,
  );

  /// Legacy 15sp dark blue medium text
  /// @deprecated Use bodyMedium.copyWith(fontSize: 15.sp, color: ColorsManager.darkPurple, fontWeight: FontWeightHelper.medium) instead
  static TextStyle font15DarkBlueMedium = bodyMedium.copyWith(
    fontSize: 15.sp,
    color: ColorsManager.darkPurple,
    fontWeight: FontWeightHelper.medium,
  );

  /// Legacy 18sp dark blue bold text
  /// @deprecated Use headlineSmall.copyWith(color: ColorsManager.darkPurple) instead
  static TextStyle font18DarkBlueBold = headlineSmall.copyWith(
    color: ColorsManager.darkPurple,
  );

  /// Legacy 18sp dark blue semi-bold text
  /// @deprecated Use headlineSmall.copyWith(fontWeight: FontWeightHelper.semiBold) instead
  static TextStyle font18DarkBlueSemiBold = headlineSmall.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  /// Legacy 18sp white medium text
  /// @deprecated Use headlineSmall.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.medium) instead
  static TextStyle font18WhiteMedium = headlineSmall.copyWith(
    color: ColorsManager.white,
    fontWeight: FontWeightHelper.medium,
  );
}
