import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_rich_text.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';

class HadithContentCard extends StatelessWidget {
  final DailyHadithModel data;
  const HadithContentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.secondaryBackground,
            ColorsManager.primaryPurple.withOpacity(0.2),
         //   ColorsManager.primaryGold.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
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
          // Islamic pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
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
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              child: Icon(
                Icons.format_quote,
                color: ColorsManager.primaryPurple.withOpacity(0.6),
                size: 24.sp,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hadith content label
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
                        "متن الحديث",
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

                // Hadith content
                HadithRichText(
                  hadith: data.data?.hadith ?? "",
                  wordsMeanings: data.data?.wordsMeanings ?? [],
                ),
              ],
            ),
          ),

          // Bottom decorative element
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: ColorsManager.primaryGold.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              child: Icon(
                Icons.star,
                color: ColorsManager.primaryGold.withOpacity(0.4),
                size: 28.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
