import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/ui/widgets/build_chapter_card.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/ui/widgets/chapter_card_shimmer.dart';

class ResponsiveChapterList extends StatelessWidget {
  const ResponsiveChapterList({
    super.key,
    required this.items,
    required this.primaryPurple,
    this.isLoading = false,
  });

  final List<dynamic> items;
  final Color primaryPurple;
  final bool isLoading;

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
            onTap: ()=> context.pushNamed(Routes.chapterAhadithsScreen,arguments: ['bulugh_al_maram',items[index].chapterNumber]),
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
