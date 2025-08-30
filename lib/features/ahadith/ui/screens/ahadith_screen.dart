import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/logic/cubit/ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_widget.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';

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
  final _controller = TextEditingController();
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
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            _buildEnhancedSearchBar(context, _controller),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            BlocBuilder<AhadithsCubit, AhadithsState>(
              builder: (context, state) {
                if (state is AhadithsSuccess) {
                  return state.filteredAhadith.isEmpty
                      ? _buildEnhancedEmptyState()
                      : SliverList.separated(
                        itemCount: state.filteredAhadith.length,
                        separatorBuilder: (_, __) => _buildIslamicSeparator(),
                        itemBuilder: (context, index) {
                          var myAhadith = state.filteredAhadith;
                          final hadith = myAhadith[index];
                          return InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HadithDetailScreen(
                                          chapterNumber:
                                              hadith.chapterId.toString(),
                                          bookSlug: widget.bookSlug,
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
                                              hadith.chapter?.chapterArabic ??
                                              '',
                                          hadithNumber:
                                              hadith.hadithNumber.toString(),
                                        ),
                                  ),
                                ),
                            child: HadithCard(
                              bookName: widget.arabicBookName,
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
                  log(
                    state.localHadithResponse.hadiths?.data.toString() ??
                        [].toString(),
                  );
                  final list = state.localHadithResponse.hadiths?.data ?? [];
                  debugPrint("Local hadith count: ${list.length}");
                  if (list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _buildEnhancedEmptyState(),
                    );
                  }
                  return SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => _buildIslamicSeparator(),
                    itemBuilder: (context, index) {
                      final hadith = list[index];
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HadithDetailScreen(
                                      chapterNumber:
                                          hadith.chapterId.toString(),
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
                } else if (state is AhadithsFailure) {
                  return SliverToBoxAdapter(
                    child: _buildEnhancedErrorState(state.error),
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

  Color gradeColor(String? g) {
    switch (g?.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return ColorsManager.hadithAuthentic;
      case "hasan":
      case "حسن":
        return ColorsManager.hadithGood;
      case "daif":
      case "ضعيف":
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.hadithAuthentic;
    }
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
          hintText: 'ابحث في الأحاديث...',
          controller: controller,
          onSearch: (query) {
            context.read<AhadithsCubit>().filterAhadith(query);
          },
        ),
      ),
    );
  }

  Widget _buildIslamicSeparator() {
    return Container(
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
              Icons.format_quote,
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

  Widget _buildEnhancedErrorState(String error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
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
          color: ColorsManager.hadithWeak.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.hadithWeak.withOpacity(0.08),
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
              color: ColorsManager.hadithWeak.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Icon(
              Icons.error_outline,
              size: 40.r,
              color: ColorsManager.hadithWeak,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: ColorsManager.primaryText,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsManager.secondaryText,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
