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
    return Container(
      margin: EdgeInsetsDirectional.only(top: 6.h, bottom: 6.h),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.cardBackground,
            ColorsManager.primaryPurple.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: ColorsManager.primaryPurple.withAlpha(18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withAlpha(8),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: Container(
              height: 3.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.primaryPurple.withOpacity(0.85),
                    ColorsManager.secondaryPurple.withOpacity(0.7),
                    ColorsManager.primaryGold.withOpacity(0.55),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.r),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 8.h,
            end: 2.w,
            child: Icon(
              Icons.format_quote,
              size: 40.sp,
              color: ColorsManager.primaryPurple.withAlpha(22),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IndexBadge(index: index),
                  const Spacer(),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryPurple.withAlpha(12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14.sp,
                          color: ColorsManager.primaryPurple,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'عرض الحديث',
                          style: TextStyles.labelMedium.copyWith(
                            color: ColorsManager.primaryPurple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                hadith.title,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: TextStyles.hadithText.copyWith(
                  fontSize: 16.5.sp,
                  height: 1.95,
                  color: ColorsManager.primaryText,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 15.sp,
                    color: ColorsManager.primaryPurple,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'اضغط لفتح التفاصيل',
                    style: TextStyles.font12GrayRegular.copyWith(
                      color: ColorsManager.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryPurple.withAlpha(220),
            ColorsManager.secondaryPurple.withAlpha(210),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withAlpha(35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.bookmark, size: 14.sp, color: ColorsManager.white),
          SizedBox(width: 6.w),
          Text(
            convertToArabicNumber(index),
            style: TextStyles.labelMedium.copyWith(
              color: ColorsManager.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
