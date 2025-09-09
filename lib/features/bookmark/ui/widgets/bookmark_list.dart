import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mishkat_almasabih/core/helpers/functions.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/chapter_ahadith_card.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/core/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/bookmark_empty_state.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';

class BookmarkList extends StatefulWidget {
  final String selectedCollection;

  const BookmarkList({super.key, required this.selectedCollection});

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDateArabic(String utcString) {
    DateTime utcTime = DateTime.parse(utcString);
    DateTime localTime = utcTime.toLocal();
    return DateFormat('d MMMM yyyy - h:mm a', 'ar').format(localTime);
  }

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

          final List<Bookmark> filteredCollection =
              widget.selectedCollection == "الكل"
                  ? bookmarks
                  : bookmarks
                      .where((b) => b.collection == widget.selectedCollection)
                      .toList();

          final List<Bookmark> filteredSearch =
              filteredCollection.where((b) {
                final text = (b.hadithText ?? "").toLowerCase();
                final notes = (b.notes ?? "").toLowerCase();
                return text.contains(_query.toLowerCase()) ||
                    notes.contains(_query.toLowerCase());
              }).toList();

          return SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "ابحث بنص الحديث أو الملاحظات...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorsManager.primaryPurple,
                      ),
                      suffixIcon:
                          _query.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = "");
                                },
                              )
                              : null,
                      filled: true,
                      fillColor: ColorsManager.secondaryBackground,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: ColorsManager.primaryPurple.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: ColorsManager.primaryPurple.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: ColorsManager.primaryPurple,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                                Container(
                                  
                                          margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),

                                  child: _buildIslamicSeparator()),


                if (filteredSearch.isEmpty)
                  const BookmarkEmptyState()
                else
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredSearch.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          color: ColorsManager.primaryPurple.withOpacity(0.3),
                          indent: 20.w,
                          endIndent: 20.w,
                        ),
                    itemBuilder: (context, index) {
                      final hadith = filteredSearch[index];
                      String createdAT = hadith.createdAt ?? '';

                      return InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        splashColor: ColorsManager.primaryPurple.withOpacity(
                          0.1,
                        ),
                        highlightColor: ColorsManager.primaryPurple.withOpacity(
                          0.05,
                        ),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => HadithDetailScreen(
                                      isLocal: false,
                                      showNavigation: false,
                                      chapterNumber:
                                          hadith.chapterNumber.toString(),
                                      bookName: hadith.bookName,
                                      isBookMark: true,
                                      hadithText: hadith.hadithText,
                                      chapter: hadith.chapterName,
                                      hadithNumber: hadith.id.toString(),
                                      bookSlug: hadith.bookSlug,
                                      narrator: '',
                                      grade: '',
                                      author: '',
                                      authorDeath: '',
                                    ),
                              ),
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChapterAhadithCard(
                              grade: convertToArabicNumber(index + 1),
                              reference: formatDateArabic(createdAT),
                              number: hadith.hadithNumber ?? '',
                              text: hadith.hadithText ?? "",
                              bookName: hadith.bookName ?? "",
                            ),
                            SizedBox(height: 3.h),
                            if ((hadith.notes ?? "").isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: ColorsManager.mediumGray.withOpacity(
                                      0.4,
                                    ),
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
                  ),
              ],
            ),
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

  Widget _buildIslamicSeparator() {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryPurple.withOpacity(0.3),
            ColorsManager.primaryGold.withOpacity(0.6),
            ColorsManager.primaryPurple.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(1.r),
      ),
    );
  }

  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
    );
  }
}
