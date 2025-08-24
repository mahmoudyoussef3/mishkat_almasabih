import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/chapters/logic/cubit/chapters_cubit.dart';
import 'package:mishkat_almasabih/features/chapters/ui/widgets/build_error_view_book_chapters.dart';
import 'package:mishkat_almasabih/features/chapters/ui/widgets/chapters_grid_view.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

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

              SliverToBoxAdapter(
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
              ),
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
            message: state.errorMessage?.toString() ?? 'حدث خطأ',
            onRetry:
                () =>
                    context.read<ChaptersCubit>().emitGetBookChapters(bookSlug),
          );
        }

        if (state is ChaptersSuccess) {
          final chapters = state.bookChaptersModel.chapters ?? [];

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

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(Spacing.screenHorizontal),
                    child: Row(
                      children: [
                        Expanded(
                          child: BuildBookDataStateCard(
                            icon: Icons.folder,
                            title: 'الأبواب',
                            value: '${bookData['noOfChapters']}',

                            color: ColorsManager.hadithAuthentic.withOpacity(
                              0.7,
                            ),
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
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    color: ColorsManager.primaryNavy,
                    endIndent: 30.h,
                    indent: 30.h,
                  ),
                ),

                ResponsiveChapterList(
                  items: chapters,
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
}
