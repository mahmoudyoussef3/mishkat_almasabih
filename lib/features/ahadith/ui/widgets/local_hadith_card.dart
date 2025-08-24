import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';

class LocalHadithCard extends StatelessWidget {
  const LocalHadithCard({
    super.key,
    required this.hadith,
    required this.bookName,
    required this.chapterName,
  });

  final LocalHadith hadith;
  final String bookName;
  final String chapterName;

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
            SizedBox(height: 10.h),

            // HADITH TEXT
            Text(
              hadith.arabic ?? hadith.english?.text ?? "",
              textAlign: TextAlign.right,
              maxLines: 4,
              style: TextStyle(
                fontFamily: 'Amiri',
                color: ColorsManager.primaryText,
                fontSize: 16.sp,
                height: 1.8,
              ),
            ),
            SizedBox(height: 12.h),

            // BOOK + REFERENCE PILLS
            Row(
              children: [
                Flexible(
                  child: _buildGradientPill(
                    text: bookName,
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
                    text: chapterName,
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
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
