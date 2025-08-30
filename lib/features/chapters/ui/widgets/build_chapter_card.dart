import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    required this.chapterNumber,
    required this.ar,
    required this.primaryPurple,
  });

  final int? chapterNumber;
  final String? ar;
  final Color primaryPurple;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: [
            ColorsManager.white.withOpacity(0.98),
            ColorsManager.offWhite.withOpacity(0.95),
            ColorsManager.lightGray.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primaryPurple.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Islamic pattern overlay
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: primaryPurple.withOpacity(0.03),
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Enhanced chapter number container
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryPurple,
                        primaryPurple.withOpacity(0.8),
                        primaryPurple.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "الباب $chapterNumber",
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Enhanced chapter content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ar!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: ColorsManager.primaryText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          fontFamily: 'Amiri',
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Decorative line
                      Container(
                        width: 40.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryPurple.withOpacity(0.6),
                              primaryPurple.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ],
                  ),
                ),

                // Decorative corner element
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16.r,
                    color: primaryPurple.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
