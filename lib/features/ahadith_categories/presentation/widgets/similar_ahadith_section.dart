import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/domain/entities_temp/category_entity.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/presentation/cubit/hadith_by_category_cubit/ahadith_by_category_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/presentation/cubit/hadith_by_category_cubit/ahadith_by_category_state.dart';
import 'package:mishkat_almasabih/features/ahadith_categories/presentation/widgets/hadith_category_card.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/section_card.dart';

class SimilarAhadithSection extends StatelessWidget {
  final List<String> categoryIds;
  final List<CategoryEntity> categories;

  const SimilarAhadithSection({
    super.key,
    required this.categoryIds,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final categoryById = {
      for (final category in categories) category.id: category,
    };
    final matchedCategories = categoryIds
        .map((id) => categoryById[id])
        .whereType<CategoryEntity>()
        .toList();

    if (matchedCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: matchedCategories
          .map((category) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _CategorySimilarAhadith(category: category),
          ))
          .toList(),
    );
  }
}

class _CategorySimilarAhadith extends StatefulWidget {
  final CategoryEntity category;

  const _CategorySimilarAhadith({required this.category});

  @override
  State<_CategorySimilarAhadith> createState() => _CategorySimilarAhadithState();
}

class _CategorySimilarAhadithState extends State<_CategorySimilarAhadith> {
  late final HadithByCategoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<HadithByCategoryCubit>()..getAhadithByCategory(widget.category.id);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<HadithByCategoryCubit, HadithByCategoryState>(
        builder: (context, state) {
          if (state is HadithByCategoryLoading || state is HadithByCategoryInitial) {
            return const SizedBox.shrink(); 
          }

          if (state is HadithByCategoryError) {
            return const SizedBox.shrink();
          }

          if (state is HadithByCategoryLoaded) {
            if (state.ahadith.isEmpty) return const SizedBox.shrink();
            
            final ahadithToShow = state.ahadith.take(3).toList();

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
                          Icons.library_books,
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
                              'أحاديث مشابهة في:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsManager.secondaryText,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              widget.category.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: ColorsManager.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  ...ahadithToShow.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hadith = entry.value;
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.shareHadithLink,
                          arguments: hadith.id,
                        );
                      },
                      child: HadithCategoryCard(
                        hadith: hadith,
                        index: index + 1,
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.ahadithListScreen,
                          arguments: {
                            'categoryId': widget.category.id,
                            'categoryTitle': widget.category.title,
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorsManager.primaryPurple,
                        side: BorderSide(color: ColorsManager.primaryPurple.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'عرض المزيد',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
