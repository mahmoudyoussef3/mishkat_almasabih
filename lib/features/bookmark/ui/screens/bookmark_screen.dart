import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/delete_cubit/cubit/delete_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_mark_hadith_card.dart';
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
                    List<Bookmark> mybookmarks = state.bookmarks;

                    if (mybookmarks.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            "لا توجد أحاديث محفوظة",
                            style: TextStyle(
                              color: ColorsManager.primaryText,
                              fontSize: 16.sp,
                            ),
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
                          child: BookmarkHadithCard(
                            bookName:
                                mybookmarks[index].bookName ??
                                'كتاب غير معروف',
                            hadithNumber: mybookmarks[index].id!,
                            hadithText:
                                mybookmarks[index].hadithText ?? 'الحديث فاضي',
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
            ],
          ),
        ),
      ),
    );
  }
}
