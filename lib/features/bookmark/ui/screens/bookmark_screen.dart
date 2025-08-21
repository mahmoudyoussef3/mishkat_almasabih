import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_mark_hadith_card.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: ColorsManager.secondaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(title: "الأحاديث المحفوظة"),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            BlocBuilder<UserBookmarksCubit, UserBookmarksState>(
              builder: (context, state) {
                if (state is UserBookmarksLoading) {
                  return SliverList.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => const HadithCardShimmer(),
                  );
                } else if (state is UserBookmarksSuccess) {
                  List<Bookmark> mybookmarks = state.bookmarks;

                  return SliverList.separated(
                    itemCount: mybookmarks.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          color: ColorsManager.primaryNavy,
                          endIndent: 30.h,
                          indent: 30.h,
                        ),
                    itemBuilder: (context, index) {
                      /// final hadith = list[index];
                      return InkWell(
                        child: BookmarkHadithCard(
                          bookName: mybookmarks[index].book_name ?? '',
                          hadithNumber:
                              mybookmarks[index].hadith_number.toString(),
                          hadithText: mybookmarks[index].hadith_text ?? '',
                        ),
                      );
                    },
                  );
                } else if (state is UserBookmarksFailure) {
                  return Center(child: Text(state.message));
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
