import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/features/chapters/ui/widgets/chapters_grid_view.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';

import '../../../../core/theming/colors.dart';
import '../../../home/ui/widgets/build_header_app_bar.dart';
import '../../logic/cubit/chapters_cubit.dart';
import 'build_error_view_book_chapters.dart';

class GetBookChaptersBlocBuilder extends StatelessWidget {
  const GetBookChaptersBlocBuilder({
    super.key,
    required this.bookSlug,
    required this.bookData,
  });

  final String bookSlug;
  final Map<String, dynamic> bookData;

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    return BlocBuilder<ChaptersCubit, ChaptersState>(
      builder: (context, state) {
        if (state is ChaptersLoading) {
          return CustomScrollView(
            slivers: [
              BuildHeaderAppBar(
                title: bookData['bookName'],
                description: bookData['writerName'],
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              _buildEnhancedStatsCards(),
              _buildEnhancedSearchBar(context, _controller),
              _buildIslamicSeparator(),
              ResponsiveChapterList(
                isLoading: true,
                items: [],
                primaryPurple: ColorsManager.primaryPurple,
                bookName: '',
                writerName: '',
                bookSlug: '',
              ),
            ],
          );
        }

        if (state is ChaptersFailure) {
          return ErrorView(
            message: state.errorMessage ?? 'حدث خطأ',
            onRetry:
                () =>
                    context.read<ChaptersCubit>().emitGetBookChapters(bookSlug),
          );
        }

        if (state is ChaptersSuccess) {
          return RefreshIndicator(
            color: ColorsManager.primaryPurple,
            onRefresh: () async {
              context.read<ChaptersCubit>().emitGetBookChapters(bookSlug);
            },
            child: CustomScrollView(
              slivers: [
                BuildHeaderAppBar(
                  title: bookData['bookName'],
                  description: bookData['writerName'],
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                _buildEnhancedStatsCards(),
                _buildIslamicSeparator(),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                _buildEnhancedSearchBar(context, _controller),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                state.filteredChapters.isEmpty
                    ? _buildEnhancedEmptyState()
                    : ResponsiveChapterList(
                      items: state.filteredChapters,
                      primaryPurple: ColorsManager.primaryPurple,
                      bookName: bookData['bookName'],
                      writerName: bookData['writerName'],
                      bookSlug: bookSlug,
                    ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  SliverToBoxAdapter _buildEnhancedStatsCards() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.primaryPurple.withOpacity(0.05),
              ColorsManager.primaryPurple.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: BuildBookDataStateCard(
                icon: Icons.folder,
                title: 'الأبواب',
                value: '${bookData['noOfChapters']}',
                color: ColorsManager.primaryPurple.withOpacity(0.8),
              ),
            ),
            SizedBox(width: Spacing.md),
            Expanded(
              child: BuildBookDataStateCard(
                icon: Icons.format_quote,
                title: 'الأحاديث',
                value: '${bookData['noOfHadith']}',
                color: ColorsManager.primaryGold.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildEnhancedSearchBar(
    BuildContext context,
    TextEditingController controller,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.primaryPurple.withOpacity(0.05),
              ColorsManager.primaryPurple.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SearchBarWidget(
          hintText: 'ابحث في الأبواب...',
          controller: controller,
          onSearch: (query) {
            context.read<ChaptersCubit>().filterChapters(query);
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildIslamicSeparator() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsManager.primaryPurple.withOpacity(0.3),
                      ColorsManager.primaryPurple.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.menu_book,
                color: ColorsManager.primaryPurple,
                size: 20.r,
              ),
            ),
            Expanded(
              child: Container(
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsManager.primaryPurple.withOpacity(0.1),
                      ColorsManager.primaryPurple.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorsManager.white,
                ColorsManager.offWhite.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: ColorsManager.primaryPurple.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.primaryPurple.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 8.h),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  Icons.search_off,
                  size: 40.r,
                  color: ColorsManager.primaryPurple,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'لا توجد نتائج',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: ColorsManager.primaryText,
                  fontFamily: 'Amiri',
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'حاول بكلمة أبسط أو مختلفة',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsManager.secondaryText,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
