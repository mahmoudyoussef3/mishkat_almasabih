import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/functions.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/domain/entities_temp/hadith_entity.dart';

class HadithCategoryCard extends StatelessWidget {
  final HadithEntity hadith;
  final int index;

  const HadithCategoryCard({
    super.key,
    required this.hadith,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.secondaryBackground,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(14.w, 14.h, 14.w, 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _IndexBadge(index: index),
                const Spacer(),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 9.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 14.sp,
                        color: ColorsManager.primaryGold,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'حديث',
                        style: TextStyles.labelSmall.copyWith(
                          color: ColorsManager.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              hadith.title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.hadithText.copyWith(
                fontSize: 16.sp,
                height: 1.8,
                color: ColorsManager.primaryText,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: ColorsManager.mediumGray),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  'عرض التفاصيل',
                  style: TextStyles.labelLarge.copyWith(
                    color: ColorsManager.primaryPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 13.sp,
                  color: ColorsManager.primaryPurple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  final int index;

  const _IndexBadge({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorsManager.primaryPurple.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.tag_rounded,
            size: 14.sp,
            color: ColorsManager.primaryPurple,
          ),
          SizedBox(width: 6.w),
          Text(
            convertToArabicNumber(index),
            style: TextStyles.labelMedium.copyWith(
              color: ColorsManager.primaryPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
