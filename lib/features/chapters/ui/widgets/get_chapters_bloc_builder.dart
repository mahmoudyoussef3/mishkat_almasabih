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
    final controller = TextEditingController();

    return BlocBuilder<ChaptersCubit, ChaptersState>(
      builder: (context, state) {
        if (state is ChaptersLoading) {
          return CustomScrollView(
            slivers: [
              BuildHeaderAppBar(
                title: bookData['bookName'],
                description: bookData['writerName'],
              ),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              _buildStatsCards(),
              _buildSearchBar(context, controller),
              SliverToBoxAdapter(
                child: Divider(
                  color: ColorsManager.primaryNavy,
                  endIndent: 30.h,
                  indent: 30.h,
                ),
              ),
              ResponsiveChapterList(
                isLoading: true,
                items: [],
                primaryPurple: ColorsManager.primaryGreen,
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
            color: ColorsManager.primaryGreen,
            onRefresh: () async {
              context.read<ChaptersCubit>().emitGetBookChapters(bookSlug);
            },
            child: CustomScrollView(
              slivers: [
                BuildHeaderAppBar(
                  title: bookData['bookName'],
                  description: bookData['writerName'],
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                _buildStatsCards(),
                SliverToBoxAdapter(
                  child: Divider(
                    color: ColorsManager.primaryNavy,
                    endIndent: 30.h,
                    indent: 30.h,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                _buildSearchBar(context, controller),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                state.filteredChapters.isEmpty
                    ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: ColorsManager.primaryNavy,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد نتائج',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsManager.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'حاول بكلمة أبسط أو مختلفة',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    : ResponsiveChapterList(
                      items: state.filteredChapters,
                      primaryPurple: ColorsManager.primaryGreen,
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

  SliverToBoxAdapter _buildStatsCards() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(Spacing.screenHorizontal),
        child: Row(
          children: [
            Expanded(
              child: BuildBookDataStateCard(
                icon: Icons.folder,
                title: 'الأبواب',
                value: '${bookData['noOfChapters']}',
                color: ColorsManager.hadithAuthentic.withOpacity(0.7),
              ),
            ),
            SizedBox(width: Spacing.md),
            Expanded(
              child: BuildBookDataStateCard(
                icon: Icons.format_quote,
                title: 'الأحاديث',
                value: '${bookData['noOfHadith']}',
                color: ColorsManager.primaryGold.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(
    BuildContext context,
    TextEditingController controller,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
        child: SearchBarWidget(
          hintText: 'ابحث في الكتب...',
          controller: controller,
          onSearch: (query) {
            context.read<ChaptersCubit>().filterChapters(query);
          },
        ),
      ),
    );
  }
}
