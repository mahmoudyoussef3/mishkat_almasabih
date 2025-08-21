import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/logic/cubit/get_chapter_ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/ui/widgets/hadith_card_widget.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

import '../widgets/hadith_card_shimer.dart';
import '../widgets/local_hadith_card.dart';

class ChapterAhadithScreen extends StatefulWidget {
  const ChapterAhadithScreen({
    super.key,
    required this.bookSlug,
    required this.bookId,
    required this.arabicBookName,
    required this.arabicWriterName,
    required this.arabicChapterName,
  });

  final String bookSlug;
  final String arabicBookName;
  final String arabicWriterName;
  final String arabicChapterName;
  final int bookId;

  @override
  State<ChapterAhadithScreen> createState() => _ChapterAhadithScreenState();
}

class _ChapterAhadithScreenState extends State<ChapterAhadithScreen> {
  static const Map<String, String> bookWriters = {
    "Imam Bukhari": "الإمام البخاري",
    "Imam Muslim": "الإمام مسلم",
    "Abu `Isa Muhammad at-Tirmidhi": "الإمام الترمذي",
    "Imam Abu Dawud Sulayman ibn al-Ash'ath as-Sijistani":
        "الإمام أبو داود السجستاني",
    "Imam Muhammad bin Yazid Ibn Majah al-Qazvini": "الإمام ابن ماجه القزويني",
    "Imam Ahmad an-Nasa`i": "الإمام النسائي",
    "Imam Khatib at-Tabrizi": "الإمام الخطيب التبريزي",
    "رياض الصالحين": "الإمام يحيى بن شرف النووي",
    "موطأ مالك": "الإمام مالك بن أنس",
    "سنن الدارمي": "الإمام عبد الرحمن بن الدارمي",
    "بلوغ المرام": "الإمام ابن حجر العسقلاني",
    "الأربعون النووية": "الإمام يحيى بن شرف النووي",
    "الأربعون القدسية": "مجموعة من العلماء",
    "أربعون ولي الله الدهلوي": "الشاه ولي الله الدهلوي",
    "الأدب المفرد": "الإمام البخاري",
    "الشمائل المحمدية": "الإمام الترمذي",
    "حصن المسلم": "سعيد بن علي بن وهف القحطاني",
  };
  /*
  @override
  void initState() {
    super.initState();
    context.read<GetChapterAhadithsCubit>().emitChapterAhadiths(

      bookSlug: widget.bookSlug,
      hadithLocal:true ,
      chapterId: widget.bookId,
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(
              title: widget.arabicBookName,
              description: widget.arabicChapterName,
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            BlocBuilder<GetChapterAhadithsCubit, GetChapterAhadithsState>(
              builder: (context, state) {
                if (state is GetChapterAhadithsSuccess) {
                  final list = state.hadithResponse.hadiths?.data ?? [];
                  return SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          color: ColorsManager.primaryNavy,
                          endIndent: 30.h,
                          indent: 30.h,
                        ),
                    itemBuilder: (context, index) {
                      final hadith = list[index];
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HadithDetailScreen(
                                      authorDeath:
                                          hadith.book?.writerDeath ?? '',
                                      hadithText: hadith.hadithArabic ?? '',
                                      narrator:
                                          bookWriters[hadith
                                              .book
                                              ?.writerName] ??
                                          '',
                                      grade: hadith.status ?? '',
                                      bookName: widget.arabicBookName,
                                      author:
                                          bookWriters[hadith
                                              .book
                                              ?.writerName] ??
                                          '',
                                      chapter:
                                          hadith.chapter?.chapterArabic ?? '',
                                      hadithNumber:
                                          hadith.hadithNumber.toString() ?? '',
                                    ),
                              ),
                            ),
                        child: HadithCard(
                          bookName: widget.arabicBookName,
                          number: hadith.hadithNumber.toString(),
                          text: hadith.hadithArabic ?? "",
                          narrator: hadith.book?.writerName ?? '',
                          grade: '${index + 1}',
                          reference: hadith.chapter?.chapterArabic ?? '',
                        ),
                      );
                    },
                  );
                } else if (state is GetChapterAhadithsLoading) {
                  return SliverList.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => const HadithCardShimmer(),
                  );
                } else if (state is GetLocalChapterAhadithsSuccess) {
                  log(
                    state.localHadithResponse.hadiths?.data.toString() ??
                        [].toString(),
                  );
                  final list = state.localHadithResponse.hadiths?.data ?? [];
                  debugPrint("Local hadith count: ${list.length}");
                  if (list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("❌ لا توجد أحاديث محلية")),
                    );
                  }
                  return SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          color: ColorsManager.primaryNavy,
                          endIndent: 30.h,
                          indent: 30.h,
                        ),
                    itemBuilder: (context, index) {
                      final hadith = list[index];
                      //  debugPrint("Hadith ${index + 1}: ${hadith.hadithArabic}");
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HadithDetailScreen(
                                      bookSlug: widget.bookSlug,
                                      hadithText: hadith.arabic ?? '',
                                      bookName: widget.arabicBookName,
                                      author: widget.arabicWriterName,
                                      chapter: widget.arabicChapterName,
                                      hadithNumber: hadith.idInBook.toString(),
                                      
                                    ),
                              ),
                            ),
                        child: LocalHadithCard(
                          bookName: widget.arabicBookName,
                          chapterName: widget.arabicChapterName,
                          hadith: hadith,
                        ),
                      );
                    },
                  );
                } else if (state is GetChapterAhadithsFailure) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("خطأ: ${state.error}")),
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
}
