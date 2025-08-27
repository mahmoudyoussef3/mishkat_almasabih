import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_mark_hadith_card.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  String selectedCollection = "الكل"; 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GetBookmarksCubit>()..getUserBookmarks(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<GetCollectionsBookmarkCubit>()..getBookMarkCollections(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.secondaryBackground,
          body: CustomScrollView(
            slivers: [
              BuildHeaderAppBar(title: "الأحاديث المحفوظة"),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),

              /// 🔹 Collections Row
              SliverToBoxAdapter(
                child: BlocBuilder<GetCollectionsBookmarkCubit,
                    GetCollectionsBookmarkState>(
                  builder: (context, state) {
                    if (state is GetCollectionsBookmarkLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetCollectionsBookmarkSuccess) {
                      final collections = state.collectionsResponse.collections;
                      final allCollections = ["الكل", ...collections!.map((e) => e.collection )];

                      return SizedBox(
                        height: 46.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount: allCollections.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            final c = allCollections[index];
                            final isSelected = selectedCollection == c;

                            return ChoiceChip(
                              label: Text(
                                c!,
                                style: TextStyle(
                                  color: isSelected
                                      ? ColorsManager.inverseText
                                      : ColorsManager.primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: ColorsManager.primaryPurple,
                              backgroundColor: ColorsManager.lightGray,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelected: (_) {
                                setState(() => selectedCollection = c);
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12.h)),

              BlocBuilder<GetBookmarksCubit, GetBookmarksState>(
                builder: (context, state) {
                  if (state is GetBookmarksLoading) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const HadithCardShimmer(),
                        childCount: 6,
                      ),
                    );
                  } else if (state is UserBookmarksSuccess) {
                    List<Bookmark> allBookmarks = state.bookmarks;

                    List<Bookmark> filtered = selectedCollection == "الكل"
                        ? allBookmarks
                        : allBookmarks
                            .where((b) => b.collection == selectedCollection)
                            .toList();

                    if (filtered.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Text(
                              "لا توجد أحاديث في هذه المجموعة",
                              style: TextStyle(
                                color: ColorsManager.secondaryText,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        color: ColorsManager.primaryNavy,
                        endIndent: 30.h,
                        indent: 30.h,
                      ),
                      itemBuilder: (context, index) {
                        final hadith = filtered[index];
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HadithDetailScreen(
                                bookName: hadith.bookName ?? "كتاب غير معروف",
                                isBookMark: true,
                                hadithText: hadith.hadithText ?? "الحديث غير متوفر",
                                chapter: hadith.chapterName,
                                hadithNumber: hadith.id.toString(),
                                bookSlug: hadith.bookSlug ?? "كتاب غير معروف",
                              ),
                            ),
                          ),
                          child: BookmarkHadithCard(
                            chapterName: hadith.chapterName,
                            bookName: hadith.bookName ?? "كتاب غير معروف",
                            hadithNumber: hadith.id!,
                            hadithText: hadith.hadithText ?? "الحديث",
                          ),
                        );
                      },
                    );
                  } else if (state is GetBookmarksFailure) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: 46.h)),
            ],
          ),
        ),
      ),
    );
  }
}
