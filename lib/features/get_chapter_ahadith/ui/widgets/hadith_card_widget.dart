import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithCard extends StatefulWidget {
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

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard> {
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
    final gradeColor = _gradeColor(widget.grade);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsManager.secondaryBackground, ColorsManager.offWhite],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: ColorsManager.primaryGreen,
                      size: 18.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'نص الحديث',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.primaryText,
                      ),
                    ),
                  ],
                ),
                // Grade Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: gradeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    widget.grade ?? "",
                    style: TextStyle(
                      color: gradeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Text(
              widget.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'FodaFree',
                color: ColorsManager.primaryText,
                fontSize: 16.sp,
                height: 1.8,
              ),
            ),

            SizedBox(height: 12.h),

            // BOOK + CHAPTER PILLS
            Row(
              children: [
                Flexible(
                  child: _buildGradientPill(
                    text: widget.bookName,
                    colors: [
                      ColorsManager.primaryGreen.withOpacity(0.7),
                      ColorsManager.primaryGreen.withOpacity(0.5),
                    ],
                    textColor: ColorsManager.offWhite,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: _buildGradientPill(
                    text: widget.reference ?? '',
                    colors: [
                      ColorsManager.hadithAuthentic.withOpacity(0.7),
                      ColorsManager.hadithAuthentic.withOpacity(0.5),
                    ],
                    textColor: ColorsManager.offWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientPill({
    required String text,
    required List<Color> colors,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
