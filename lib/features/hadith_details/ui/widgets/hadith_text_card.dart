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
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.secondaryBackground,
            ColorsManager.primaryPurple.withOpacity(0.1),
            //   ColorsManager.primaryGold.withOpacity(0.02),
          ],
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
          Positioned.fill(
            child: Opacity(
              opacity: 0.0005,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  'assets/images/islamic_pattern.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hadith label
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                  fontSize: 20.sp,
                  height: 1.8,
                  color: ColorsManager.primaryText,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
