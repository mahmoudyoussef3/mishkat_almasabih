import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/domain/entities_temp/category_entity.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/section_card.dart';

class HadithCategoriesSection extends StatelessWidget {
  final List<String> categoryIds;
  final List<CategoryEntity> categories;

  const HadithCategoriesSection({
    super.key,
    required this.categoryIds,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final categoryById = {
      for (final category in categories) category.id: category,
    };
    final matchedCategories =
        categoryIds
            .map(
              (id) =>
                  categoryById[id] ??
            CategoryEntity(id: id, title: 'تصنيف مرتبط', hadeethsCount: 0),
            )
            .toList();

    if (matchedCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsManager.primaryPurple.withOpacity(0.16),
                      ColorsManager.secondaryPurple.withOpacity(0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.sell_rounded,
                  color: ColorsManager.primaryPurple,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التصنيفات المرتبطة',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: ColorsManager.primaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'اضغط على أي تصنيف لاستعراض الأحاديث الخاصة به',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsManager.secondaryText,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children:
                matchedCategories
                    .map(
                      (category) => _CategoryChip(
                        title: category.title,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.ahadithListScreen,
                            arguments: {
                              'categoryId': category.id,
                              'categoryTitle': category.title,
                            },
                          );
                        },
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorsManager.primaryPurple.withOpacity(0.12),
                ColorsManager.secondaryPurple.withOpacity(0.08),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: ColorsManager.primaryPurple.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.primaryPurple.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 14.sp,
                  color: ColorsManager.primaryPurple,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.primaryText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'عرض الأحاديث',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: ColorsManager.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}