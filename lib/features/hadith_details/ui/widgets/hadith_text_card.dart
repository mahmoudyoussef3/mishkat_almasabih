import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithTextCard extends StatelessWidget {
  final String hadithText;
  const HadithTextCard({super.key, required this.hadithText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.secondaryPurple.withOpacity(0.08),
            ColorsManager.white,
            ColorsManager.primaryPurple.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ColorsManager.primaryPurple.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative corner elements
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: ColorsManager.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.r),
                  bottomLeft: Radius.circular(24.r),
                ),
              ),
              child: Icon(
                Icons.format_quote,
                color: ColorsManager.primaryGold.withOpacity(0.6),
                size: 20.sp,
              ),
            ),
          ),

          // Main text content
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hadith label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: ColorsManager.primaryPurple.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_stories,
                        color: ColorsManager.primaryPurple,
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "نص الحديث",
                        style: TextStyle(
                          color: ColorsManager.primaryPurple,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Hadith text with enhanced typography
                Text(
                  hadithText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.sp,
                    height: 1.8,
                    color: ColorsManager.primaryText,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Bottom decorative element
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorsManager.primaryGold.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.r),
                  bottomLeft: Radius.circular(24.r),
                ),
              ),
              child: Icon(
                Icons.star,
                color: ColorsManager.primaryGold.withOpacity(0.5),
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
