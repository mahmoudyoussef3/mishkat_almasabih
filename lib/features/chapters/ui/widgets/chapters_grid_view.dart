import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/features/chapters/ui/widgets/build_chapter_card.dart';
import 'package:mishkat_almasabih/features/chapters/ui/widgets/chapter_card_shimmer.dart';
import 'package:mishkat_almasabih/features/ahadith/logic/cubit/ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/screens/ahadith_screen.dart';

class ResponsiveChapterList extends StatelessWidget {
  const ResponsiveChapterList({
    super.key,
    required this.items,
    required this.primaryPurple,
    this.isLoading = false,
    required this.bookName,
    required this.writerName,
    required this.bookSlug,
  });

  final List<dynamic> items;
  final Color primaryPurple;
  final bool isLoading;
  final String bookName;
  final String writerName;
  final String bookSlug;
  bool checkBookSlug(String bookSlug) {
    if (bookSlug == 'sahih-bukhari' ||
        bookSlug == 'sahih-muslim' ||
        bookSlug == 'al-tirmidhi' ||
        bookSlug == 'abu-dawood' ||
        bookSlug == 'ibn-e-majah' ||
        bookSlug == 'sunan-nasai' ||
        bookSlug == 'mishkat') {
      return false;
    } else {
      return true;
    }
  }

  bool checkThreeBooks(String bookSlug) {
    if (bookSlug == 'qudsi40' ||
        bookSlug == 'nawawi40' ||
        bookSlug == 'shahwaliullah40') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const crossAxisCount = 2;
    final spacing = 12 * (crossAxisCount - 1);
    final itemWidth = (screenWidth - spacing) / crossAxisCount;
    final itemHeight = itemWidth * 0.4;
    final aspectRatio = itemWidth / itemHeight;

    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ChapterCardShimmer(),
          );
        }
        return InkWell(
          onTap: () {
            log(bookSlug);
            log(bookName);
            log(writerName);
            log(items[index].chapterNumber.toString());
            log(items[index].chapterArabic);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider(
                      create:
                          (context) =>
                              getIt<AhadithsCubit>()..emitAhadiths(
                                isArbainBooks: checkThreeBooks(bookSlug),
                                hadithLocal: checkBookSlug(bookSlug),
                                bookSlug: bookSlug,
                                chapterId: items[index].chapterNumber,
                              ),
                      child: ChapterAhadithScreen(
                        bookSlug: bookSlug,
                        bookId: items[index].chapterNumber,
                        arabicBookName: bookName,
                        arabicWriterName: writerName,
                        arabicChapterName: items[index].chapterArabic,
                      ),
                    ),
              ),
            );
          },

          //     onTap: ()=> context.pushNamed(Routes.chapterAhadithsScreen,arguments: ['bulugh_al_maram',items[index].chapterNumber]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ChapterCard(
                  chapterNumber: items[index].chapterNumber,
                  ar: items[index].chapterArabic,
                  primaryPurple: primaryPurple,
                )
                .animate()
                .fadeIn(duration: 1.seconds)
                .scale(duration: 1.seconds, curve: Curves.easeOutBack),
          ),
        );
      }, childCount: isLoading ? 12 : items.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
    );
  }
}