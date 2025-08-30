import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/bookmark_empty_state.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_mark_hadith_card.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';

class BookmarkList extends StatelessWidget {
  final String selectedCollection;

  const BookmarkList({super.key, required this.selectedCollection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookmarksCubit, GetBookmarksState>(
      builder: (context, state) {
        if (state is GetBookmarksLoading) {
          return SliverList.builder(
            itemCount: 6,
            itemBuilder:
                (context, _) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 16.w,
                  ),
                  child: const HadithCardShimmer(),
                ),
          );
        } else if (state is UserBookmarksSuccess) {
          final List<Bookmark> bookmarks = state.bookmarks;

          final List<Bookmark> filtered =
              selectedCollection == "الكل"
                  ? bookmarks
                  : bookmarks
                      .where((b) => b.collection == selectedCollection)
                      .toList();

          if (filtered.isEmpty) {
            return const SliverToBoxAdapter(child: BookmarkEmptyState());
          }

          return SliverList.separated(
            itemCount: filtered.length,
            separatorBuilder:
                (_, __) => Divider(
                  color: ColorsManager.primaryNavy,
                  endIndent: 30.h,
                  indent: 30.h,
                ),
            itemBuilder: (context, index) {
              final hadith = filtered[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16.r),
                splashColor: ColorsManager.primaryPurple.withOpacity(0.1),
                highlightColor: ColorsManager.primaryPurple.withOpacity(0.05),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => HadithDetailScreen(
                              chapterNumber: hadith.chapterNumber.toString(),
                              bookName: hadith.bookName ?? "كتاب غير معروف",
                              isBookMark: true,
                              hadithText:
                                  hadith.hadithText ?? "الحديث غير متوفر",
                              chapter: hadith.chapterName,
                              hadithNumber: hadith.id.toString(),
                              bookSlug: hadith.bookSlug ?? "كتاب غير معروف",
                            ),
                      ),
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookmarkHadithCard(
                      chapterName: hadith.chapterName,
                      bookName: hadith.bookName ?? "كتاب غير معروف",
                      hadithNumber: hadith.id!,
                      hadithText: hadith.hadithText ?? "الحديث",
                    ),

                    SizedBox(height: 8.h),

                    /// 🔹 Notes section (if available)
                    if ((hadith.notes ?? "").isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: ColorsManager.lightGray.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "📝 الملاحظات: ${hadith.notes}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: ColorsManager.secondaryText,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        } else if (state is GetBookmarksFailure) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
