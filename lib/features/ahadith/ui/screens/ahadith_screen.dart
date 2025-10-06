import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/utils/constants.dart';
import 'package:mishkat_almasabih/core/widgets/error_dialg.dart';
import 'package:mishkat_almasabih/features/ahadith/logic/cubit/ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/chapter_ahadith_card.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/chapter_ahadith_search_bar.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/emoty_chapter_ahadith.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/separator.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/core/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/local_hadith_card.dart';

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
  });

  final String bookSlug;
  final String arabicBookName;
  final String arabicWriterName;
  final String arabicChapterName;
  final int bookId;
  final String? narrator;
  final String? grade;
  final String? authorDeath;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(
              title: arabicBookName,
              description: arabicChapterName,
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      
            AhadithSearchBar(controller: _controller),
      
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      
            BlocBuilder<AhadithsCubit, AhadithsState>(
              builder: (context, state) {
                if (state is AhadithsSuccess) {
                  return state.filteredAhadith.isEmpty
                      ? const EmptyState()
                      : SliverList.separated(
                        itemCount: state.filteredAhadith.length,
                        separatorBuilder: (_, __) => const IslamicSeparator(),
                        itemBuilder: (context, index) {
                          final hadith = state.filteredAhadith[index];
                          return GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HadithDetailScreen(
                                          isLocal: false,
                                          chapterNumber:
                                              hadith.chapterId.toString(),
                                          bookSlug: bookSlug,
                                          authorDeath:
                                              hadith.book?.writerDeath ?? '',
                                          hadithText: hadith.hadithArabic ?? '',
                                          narrator:
                                              bookWriters[hadith
                                                  .book
                                                  ?.writerName] ??
                                              '',
                                          grade: hadith.status ?? '',
                                          bookName: arabicBookName,
                                          author:
                                              bookWriters[hadith
                                                  .book
                                                  ?.writerName] ??
                                              '',
                                          chapter:
                                              hadith.chapter?.chapterArabic ??
                                              '',
                                          hadithNumber:
                                              hadith.hadithNumber.toString(),
                                        ),
                                  ),
                                ),
                            child: ChapterAhadithCard(
                              bookName: arabicBookName,
                              number: hadith.hadithNumber.toString(),
                              text: hadith.hadithArabic ?? "",
                              narrator: hadith.book?.writerName ?? '',
                              grade:
                                  hadith.status != null
                                      ? gradeStringArabic(hadith.status!)
                                      : '${index + 1}',
                              reference: hadith.chapter?.chapterArabic ?? '',
                            ),
                          );
                        },
                      );
                } else if (state is AhadithsLoading) {
                  return SliverList.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => const HadithCardShimmer(),
                  );
                } else if (state is LocalAhadithsSuccess) {
                  final list = state.localHadithResponse.hadiths?.data ?? [];
                  debugPrint("Local hadith count: ${list.length}");
                  if (list.isEmpty) {
                    return const SliverToBoxAdapter(child: EmptyState());
                  }
                  return SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const IslamicSeparator(),
                    itemBuilder: (context, index) {
                      final hadith = list[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HadithDetailScreen(
                                      authorDeath: authorDeath ?? "",
                                      grade: grade ?? "",
                                      narrator: narrator ?? "",
                                      isLocal: true,
                                      chapterNumber:
                                          hadith.chapterId.toString(),
                                      bookSlug: bookSlug,
                                      hadithText: hadith.arabic ?? '',
                                      bookName: arabicBookName,
                                      author: arabicWriterName,
                                      chapter: arabicChapterName,
                                      hadithNumber: hadith.id.toString(),
                                    ),
                              ),
                            ),
                        child: LocalHadithCard(
                          bookName: arabicBookName,
                          chapterName: arabicChapterName,
                          hadith: hadith,
                        ),
                      );
                    },
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
    );
  }

  String gradeStringArabic(String grade) {
    switch (grade.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return 'صحيح';
      case "hasan":
      case "حسن":
        return "حسن";
      case "daif":
      case "ضعيف":
        return "ضعيف";
      default:
        return '';
    }
  }
}
