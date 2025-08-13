import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle displayLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
    letterSpacing: -0.5,
  );
  
  static TextStyle displayMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
    letterSpacing: -0.25,
  );
  
  static TextStyle displaySmall = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
  );

  // Headline Styles - Section headers and important text
  static TextStyle headlineLarge = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );

  // Title Styles - Card titles and navigation
  static TextStyle titleLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle titleMedium = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle titleSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );

  // Body Styles - Main content text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.5,
  );
  
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.4,
  );
  
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.secondaryText,
    height: 1.3,
  );

  // Label Styles - Form labels, buttons, captions
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryText,
  );
  
  static TextStyle labelSmall = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.secondaryText,
  );

  // Special Islamic-themed styles
  static TextStyle arabicTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryGreen,
    letterSpacing: 0.5,
  );
  
  static TextStyle hadithText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryText,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );
  
  static TextStyle quranText = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryNavy,
    height: 1.7,
  );
  
  static TextStyle authorName = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryGold,
  );
  
  static TextStyle categoryLabel = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.secondaryGreen,
    letterSpacing: 0.5,
  );

  // Button and Interactive Styles
  static TextStyle buttonText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.white,
    letterSpacing: 0.5,
  );
  
  static TextStyle linkText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryGreen,
    decoration: TextDecoration.underline,
  );

  // Legacy styles for backward compatibility
  static TextStyle font24BlackBold = displaySmall.copyWith(color: ColorsManager.black);
  static TextStyle font32BlueBold = displayLarge.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font13BlueSemiBold = labelLarge.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font13DarkBlueMedium = bodyMedium.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font13DarkBlueRegular = bodyMedium.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font24BlueBold = displaySmall.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font16WhiteSemiBold = bodyLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.semiBold);
  static TextStyle font13GrayRegular = bodyMedium.copyWith(color: ColorsManager.gray);
  static TextStyle font12GrayRegular = bodySmall.copyWith(color: ColorsManager.gray);
  static TextStyle font12GrayMedium = bodySmall.copyWith(fontWeight: FontWeightHelper.medium);
  static TextStyle font12DarkBlueRegular = bodySmall.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font12BlueRegular = bodySmall.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font13BlueRegular = bodyMedium.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font14GrayRegular = bodyMedium.copyWith(color: ColorsManager.gray);
  static TextStyle font14LightGrayRegular = bodyMedium.copyWith(color: ColorsManager.lightGray);
  static TextStyle font14DarkBlueMedium = bodyMedium.copyWith(color: ColorsManager.primaryNavy, fontWeight: FontWeightHelper.medium);
  static TextStyle font14DarkBlueBold = bodyMedium.copyWith(color: ColorsManager.primaryNavy, fontWeight: FontWeightHelper.bold);
  static TextStyle font16WhiteMedium = bodyLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.medium);
  static TextStyle font14BlueSemiBold = bodyMedium.copyWith(color: ColorsManager.primaryNavy, fontWeight: FontWeightHelper.semiBold,fontFamily: '');
  static TextStyle font15DarkBlueMedium = bodyMedium.copyWith(fontSize: 15.sp, color: ColorsManager.primaryNavy, fontWeight: FontWeightHelper.medium);
  static TextStyle font18DarkBlueBold = headlineSmall.copyWith(color: ColorsManager.primaryNavy);
  static TextStyle font18DarkBlueSemiBold = headlineSmall.copyWith(fontWeight: FontWeightHelper.semiBold);
  static TextStyle font18WhiteMedium = headlineSmall.copyWith(color: ColorsManager.white, fontWeight: FontWeightHelper.medium);
}