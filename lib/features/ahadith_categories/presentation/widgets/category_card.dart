import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/domain/entities_temp/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onExploreSubcategories;
  final VoidCallback onViewAllHadiths;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onExploreSubcategories,
    required this.onViewAllHadiths,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.secondaryBackground,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onViewAllHadiths,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: ColorsManager.primaryPurple.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: ColorsManager.primaryPurple,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.titleLarge.copyWith(
                        color: ColorsManager.primaryText,
                        fontWeight: FontWeight.bold,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'اضغط لعرض الأحاديث المرتبطة بهذا التصنيف',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bodySmall.copyWith(
                        color: ColorsManager.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              _HadithCountChip(count: category.hadeethsCount),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorsManager.secondaryText,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HadithCountChip extends StatelessWidget {
  final int count;

  const _HadithCountChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 58.w),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryGold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorsManager.primaryGold.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.labelLarge.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'حديث',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.labelSmall.copyWith(
              color: ColorsManager.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
