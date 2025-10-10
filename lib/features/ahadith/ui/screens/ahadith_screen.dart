import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/logic/cubit/ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/bookmark_listener.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/chapter_ahadith_search_bar.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/chapter_appbar.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_list_builder.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/local_hadith_list_builder.dart';
import 'package:mishkat_almasabih/core/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/core/widgets/error_dialg.dart';


class ChapterAhadithScreen extends StatelessWidget {
  ChapterAhadithScreen({
    super.key,
    required this.bookSlug,
    required this.bookId,
    required this.arabicBookName,
    required this.arabicWriterName,
    required this.arabicChapterName,
    required this.narrator,
    required this.grade,
    required this.authorDeath,
    required this.chapterNumber,
  });

  final String bookSlug;
  final String arabicBookName;
  final String arabicWriterName;
  final String arabicChapterName;
  final int bookId;
  final String? narrator;
  final String? grade;
  final String? authorDeath;
  final int? chapterNumber;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              ChapterAppBar(
                arabicBookName: arabicBookName,
                arabicChapterName: arabicChapterName,
                bookSlug: bookSlug,
                chapterNumber: chapterNumber,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              AhadithSearchBar(controller: _controller),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              // BlocListener for bookmarks
              const SliverToBoxAdapter(
                child: BookmarkListener(),
              ),

              // Main Hadith builder
              BlocBuilder<AhadithsCubit, AhadithsState>(
                builder: (context, state) {
                  if (state is AhadithsSuccess) {
                    return HadithListBuilder(
                      arabicBookName: arabicBookName,
                      bookSlug: bookSlug,
                      state: state,
                    );
                  } else if (state is AhadithsLoading) {
                    return SliverList.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) =>
                          const HadithCardShimmer(),
                    );
                  } else if (state is LocalAhadithsSuccess) {
                    return LocalHadithListBuilder(
                      arabicBookName: arabicBookName,
                      arabicWriterName: arabicWriterName,
                      arabicChapterName: arabicChapterName,
                      authorDeath: authorDeath,
                      grade: grade,
                      narrator: narrator,
                      bookSlug: bookSlug,
                      state: state,
                    );
                  } else if (state is AhadithsFailure) {
                    return SliverToBoxAdapter(
                      child: ErrorState(error: state.error),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
