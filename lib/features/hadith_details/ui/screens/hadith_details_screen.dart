import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_books_section.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_grade_title.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_navigation.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_text_card.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';
import 'package:share_plus/share_plus.dart';

class HadithDetailScreen extends StatefulWidget {
  final String? hadithText;
  final String? narrator;
  final String? grade;
  final String? bookName;
  final String? author;
  final String? chapter;
  final String? authorDeath;
  final String? hadithNumber;
  final String? bookSlug;
  final bool isBookMark;
  final String chapterNumber;

  const HadithDetailScreen({
    super.key,
    required this.hadithText,
    required this.chapterNumber,
    this.narrator,
    this.grade,
    this.bookName,
    this.author,
    required this.chapter,
    this.authorDeath,
    required this.hadithNumber,
    required this.bookSlug,
    this.isBookMark = false,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddCubitCubit>()),
        BlocProvider(
          create:
              (context) =>
                  getIt<NavigationCubit>()..emitNavigationStates(
                    widget.hadithNumber.toString(),
                    widget.bookSlug ?? '',
                    widget.chapterNumber,
                  ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _buildEnhancedAppBar(),
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              // Enhanced header section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: _buildHadithHeader(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              // Enhanced hadith text card
              SliverToBoxAdapter(
                child: HadithTextCard(hadithText: widget.hadithText!),
              ),

              // Enhanced grade section
              if (widget.grade != null)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: HadithGradeTile(
                      grade: widget.grade!,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.hadithText ?? ''),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: ColorsManager.success,
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  "تم نسخ الحديث بنجاح",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              _buildEnhancedDivider(),

              // Enhanced book section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: HadithBookSection(
                    bookName: widget.bookName ?? '',
                    author: widget.author,
                    authorDeath: widget.authorDeath,
                    chapter: widget.chapter ?? "",
                  ),
                ),
              ),

              _buildEnhancedDivider(),

              // Enhanced navigation section
              if (!widget.isBookMark)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: HadithNavigation(
                      hadithNumber: widget.hadithNumber ?? "",
                      bookSlug: widget.bookSlug ?? '',
                      chapterNumber: widget.chapterNumber,
                    ),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      foregroundColor: ColorsManager.primaryPurple,
      centerTitle: true,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorsManager.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'تفاصيل الحديث',
          style: TextStyle(
            color: ColorsManager.primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      backgroundColor: ColorsManager.secondaryBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      actions: [
        // Enhanced share button
        Container(
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            color: ColorsManager.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            color: ColorsManager.primaryGold,
            onPressed: () async {
              await Share.share(widget.hadithText!, subject: "شارك الحديث");
            },
            icon: Icon(Icons.share, size: 22.sp),
          ),
        ),

        // Enhanced bookmark button
        if (!widget.isBookMark)
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create:
                                (context) =>
                                    getIt<GetCollectionsBookmarkCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<AddCubitCubit>(),
                          ),
                        ],
                        child: AddToFavoritesDialog(
                          bookName: widget.bookName ?? '',
                          bookSlug: widget.bookSlug ?? '',
                          chapter: widget.chapter ?? '',
                          hadithNumber: widget.hadithNumber ?? '',
                          hadithText: widget.hadithText ?? '',
                          id: widget.hadithNumber ?? '',
                        ),
                      ),
                );
              },
              icon: Icon(
                Icons.favorite,
                color: ColorsManager.primaryPurple,
                size: 22.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHadithHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.primaryPurple.withOpacity(0.1),
            ColorsManager.secondaryPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorsManager.primaryPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.format_quote,
              color: ColorsManager.primaryPurple,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حديث رقم ${widget.hadithNumber}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'من ${widget.bookName ?? "المصدر"}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDivider() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 2.h,
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
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: ColorsManager.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.star,
                color: ColorsManager.primaryGold,
                size: 16.sp,
              ),
            ),
            Expanded(
              child: Container(
                height: 2.h,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
