import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/delete_cubit/cubit/delete_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_mark_hadith_card.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GetBookmarksCubit>()..getUserBookmarks(),
        ),

        BlocProvider(
          create:
              (context) =>
                  getIt<GetCollectionsBookmarkCubit>()
                    ..getBookMarkCollections(),
        ),
        BlocProvider(create: (context) => getIt<DeleteCubitCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,

        child: Scaffold(
          backgroundColor: ColorsManager.secondaryBackground,
          body: CustomScrollView(
            slivers: [
              BuildHeaderAppBar(title: "الأحاديث المحفوظة"),
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
                    context
                        .read<GetCollectionsBookmarkCubit>()
                        .getBookMarkCollections();
                    List<Bookmark> mybookmarks = state.bookmarks;

                    if (mybookmarks.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 40.h,
                            horizontal: 16.w,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border_rounded,
                                size: 80.sp,
                                color: ColorsManager.primaryGreen.withOpacity(
                                  0.7,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "لا توجد أحاديث محفوظة",
                                style: TextStyle(
                                  color: ColorsManager.primaryText,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "يمكنك حفظ الأحاديث المفضلة للرجوع إليها لاحقاً",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorsManager.secondaryText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.pushNamed(
                                    Routes.mainNavigationScreen,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 12.h,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "استكشف الأحاديث",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList.separated(
                      itemCount: mybookmarks.length,
                      separatorBuilder:
                          (_, __) => Divider(
                            color: ColorsManager.primaryNavy,
                            endIndent: 30.h,
                            indent: 30.h,
                          ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => HadithDetailScreen(
                                        bookName:
                                            mybookmarks[index].bookName ??
                                            'كتاب غير معروف',

                                        isBookMark: true,

                                        hadithText:
                                            mybookmarks[index].hadithText ??
                                            'الحديث غير متوفر ',
                                        chapter: mybookmarks[index].chapterName,
                                        hadithNumber:
                                            mybookmarks[index].id.toString(),
                                        bookSlug:
                                            mybookmarks[index].bookName ??
                                            'كتاب غير معروف',
                                      ),
                                ),
                              ),
                          child: InkWell(
                            child: BookmarkHadithCard(
                              chapterName: mybookmarks[index].chapterName,
                              bookName:
                                  mybookmarks[index].bookName ??
                                  'كتاب غير معروف',
                              hadithNumber: mybookmarks[index].id!,
                              hadithText:
                                  mybookmarks[index].hadithText ?? 'الحديث ',
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetBookmarksFailure) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  }

                  // Default: لازم يكون Sliver
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
