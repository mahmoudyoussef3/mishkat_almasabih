import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/logic/cubit/get_chapter_ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/ui/widgets/hadith_card_widget.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

import '../widgets/hadith_card_shimer.dart';

class ChapterAhadithScreen extends StatefulWidget {
  const ChapterAhadithScreen({
    super.key,
    required this.bookSlug,
    required this.bookId,
  
  });

  final String bookSlug;

  final int bookId;

  @override
  State<ChapterAhadithScreen> createState() => _ChapterAhadithScreenState();
}

class _ChapterAhadithScreenState extends State<ChapterAhadithScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetChapterAhadithsCubit>().emitChapterAhadiths(
      bookSlug: widget.bookSlug,
      chapterId: widget.bookId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(title: widget.bookSlug),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            BlocBuilder<GetChapterAhadithsCubit, GetChapterAhadithsState>(
              builder: (context, state) {
                if (state is GetChapterAhadithsSuccess) {
                  final list = state.hadithResponse.hadiths.data;
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
                      return HadithCard(
                        number: hadith.idInBook.toString(),
                        text: hadith.arabic,
                        narrator: widget.bookSlug,
                        grade: "${index + 1}",
                        reference: widget.bookSlug,
                      );
                    },
                  );
                } else if (state is GetChapterAhadithsLoading) {
                  return SliverList.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => const HadithCardShimmer(),
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
