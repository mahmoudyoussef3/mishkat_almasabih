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
          create: (context) => getIt<NavigationCubit>()
            ..emitNavigationStates(
              widget.hadithNumber.toString(),
              widget.bookSlug ?? '',
              widget.chapterNumber,
            ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _buildIslamicAppBar(),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: _buildHadithHeader(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              // Hadith Text
              SliverToBoxAdapter(
                child: HadithTextCard(hadithText: widget.hadithText ?? ''),
              ),

              // Grade Section
              if (widget.grade != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: HadithGradeTile(
                      grade: widget.grade!,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.hadithText ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: ColorsManager.success,
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
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

              _buildIslamicDivider(),

              // Book Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: HadithBookSection(
                    bookName: widget.bookName ?? '',
                    author: widget.author,
                    authorDeath: widget.authorDeath,
                    chapter: widget.chapter ?? '',
                  ),
                ),
              ),

              _buildIslamicDivider(),

              // Navigation Section
              if (!widget.isBookMark)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: HadithNavigation(
                      hadithNumber: widget.hadithNumber ?? '',
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

  /// AppBar بسيط وأنيق
  PreferredSizeWidget _buildIslamicAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'تفاصيل الحديث',
        style: TextStyle(
          color: ColorsManager.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      iconTheme: IconThemeData(color: ColorsManager.success),
      actions: [
        IconButton(
          color: ColorsManager.primaryGreen,
          onPressed: () async {
            await Share.share(widget.hadithText ?? '', subject: "شارك الحديث");
          },
          icon: Icon(Icons.share, size: 22.sp),
        ),
        if (!widget.isBookMark)
          IconButton(
            icon: Icon(Icons.favorite_border, color: ColorsManager.primaryGreen, size: 22.sp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => getIt<GetCollectionsBookmarkCubit>()),
                    BlocProvider(create: (context) => getIt<AddCubitCubit>()),
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
          ),
      ],
    );
  }

  /// Header أنيق وبسيط
  Widget _buildHadithHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote, color: ColorsManager.primaryGreen, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حديث رقم ${widget.hadithNumber}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'من ${widget.bookName ?? "المصدر"}',
                  style: TextStyle(
                    fontSize: 13.sp,
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

  /// Divider بسيط بلمسة إسلامية
  Widget _buildIslamicDivider() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(child: Divider(color: ColorsManager.primaryGreen, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Icon(Icons.star, color: ColorsManager.primaryGold, size: 16.sp),
            ),
            Expanded(child: Divider(color: ColorsManager.primaryGreen, thickness: 1)),
          ],
        ),
      ),
    );
  }
}
