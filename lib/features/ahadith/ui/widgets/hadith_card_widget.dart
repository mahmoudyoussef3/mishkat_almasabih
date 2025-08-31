import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({
    super.key,
    required this.number,
    required this.text,
    this.narrator,
    this.grade,
    this.reference,
    required this.bookName,
  });

  final String number;
  final String text;
  final String? narrator;
  final String? grade;
  final String? reference;
  final String bookName;

  Color _gradeColor(String? g) {
    switch (g?.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return ColorsManager.hadithAuthentic;
      case "hasan":
      case "حسن":
        return ColorsManager.hadithGood;
      case "daif":
      case "ضعيف":
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.hadithAuthentic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _gradeColor(grade);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.secondaryBackground,
            ColorsManager.offWhite,
            ColorsManager.lightGray.withOpacity(0.3),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: gradeColor.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gradeColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Islamic pattern overlay
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.03),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Enhanced header with Islamic design
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                gradeColor.withOpacity(0.1),
                                gradeColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.menu_book,
                            color: gradeColor,
                            size: 20.r,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'نص الحديث',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorsManager.primaryText,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),

                    // Enhanced grade badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            gradeColor.withOpacity(0.15),
                            gradeColor.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: gradeColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        grade ?? "",
                        style: TextStyle(
                          color: gradeColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Enhanced hadith text
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.white.withOpacity(0.8),
                        ColorsManager.offWhite.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: gradeColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    text,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      color: ColorsManager.primaryText,
                      fontSize: 17.sp,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                // Enhanced book and chapter pills
                Row(
                  children: [
                    Flexible(
                      child: _buildGradientPill(
                        text: bookName,
                        colors: [
                          ColorsManager.primaryPurple.withOpacity(0.8),
                          ColorsManager.primaryPurple.withOpacity(0.6),
                        ],
                        textColor: ColorsManager.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: _buildGradientPill(
                        text: reference ?? '',
                        colors: [
                          gradeColor.withOpacity(0.8),
                          gradeColor.withOpacity(0.6),
                        ],
                        textColor: ColorsManager.white,
                      ),
                    ),
                  ],
                ),

                // Decorative bottom line
                SizedBox(height: 16.h),
                Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradeColor.withOpacity(0.4),
                        gradeColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientPill({
    required String text,
    required List<Color> colors,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          fontFamily: 'Amiri',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
