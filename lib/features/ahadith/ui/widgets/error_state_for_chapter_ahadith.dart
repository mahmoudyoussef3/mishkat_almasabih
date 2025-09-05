import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class ErrorState extends StatelessWidget {
  final String error;
  const ErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.white,
            ColorsManager.offWhite.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ColorsManager.hadithWeak.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.hadithWeak.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8.h),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: ColorsManager.hadithWeak.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Icon(
              Icons.error_outline,
              size: 40.r,
              color: ColorsManager.hadithWeak,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: ColorsManager.primaryText,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsManager.secondaryText,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
