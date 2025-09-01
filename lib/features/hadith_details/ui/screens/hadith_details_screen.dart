import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_action_row.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_books_section.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_grade_title.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_text_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';
import 'package:mishkat_almasabih/features/navigation/logic/local/cubit/local_hadith_navigation_cubit.dart';

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
  final bool isLocal;
  bool showNavigation;

  HadithDetailScreen({
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
    required this.isLocal,
    this.showNavigation = true,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  bool prev = false;
  bool isNavigated = false;
  String newTextOfHadith = '';
  String newHadithId = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddCubitCubit>()),
        BlocProvider(create: (context) => getIt<NavigationCubit>()),
        BlocProvider(create: (context) => getIt<LocalHadithNavigationCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.secondaryBackground,
          body: CustomScrollView(
            slivers: [
              const BuildHeaderAppBar(title: 'تفاصيل الحديث'),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 16.h,
                  ),
                  child: _buildHadithHeader(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              SliverToBoxAdapter(
                child: HadithTextCard(
                  hadithText:
                      isNavigated
                          ? newTextOfHadith
                          : widget.hadithText ?? "الحديث غير متوفر",
                ),
              ),
              _buildDividerSection(),

              if (widget.grade != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              _buildDividerSection(),

              // Book Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 0.h,
                  ),
                  child: HadithBookSection(
                    bookName: widget.bookName ?? '',
                    author: widget.author,
                    authorDeath: widget.authorDeath,
                    chapter: widget.chapter ?? '',
                  ),
                ),
              ),

              _buildDividerSection(),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: _buildEnhancedActionsSection(),
                ),
              ),
              _buildDividerSection(),

              // Navigation Section
              if (!widget.isBookMark)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child:
                        widget.isLocal
                            ? BlocConsumer<
                              LocalHadithNavigationCubit,
                              LocalHadithNavigationState
                            >(
                              listener: (context, state) {
                                if (state is LocalHadithNavigationFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: ColorsManager.error,

                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        state.errMessage,
                                        style: TextStyle(
                                          color:
                                              ColorsManager.secondaryBackground,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (state is LocalHadithNavigationSuccess) {
                                  setState(() {
                                    isNavigated = true;
                                    final hadith =
                                        prev
                                            ? state
                                                .navigationHadithResponse
                                                .prevHadith
                                            : state
                                                .navigationHadithResponse
                                                .nextHadith;

                                    newTextOfHadith =
                                        hadith?.title ?? "الحديث غير متوفر";
                                    newHadithId =
                                        hadith?.id.toString() ??
                                        "الحديث غير متوفر";
                                  });
                                }
                              },
                              builder: (context, state) {
                                if (state is NavigationLoading) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorsManager.primaryPurple
                                            .withOpacity(0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              loadingProgressIndicator(
                                                size: 16,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                "الحديث رقم $newHadithId",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ColorsManager
                                                          .primaryPurple,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (state
                                    is LocalHadithNavigationSuccess) {
                                  isNavigated = true;
                                  final localHadith =
                                      prev
                                          ? state
                                              .navigationHadithResponse
                                              .prevHadith
                                          : state
                                              .navigationHadithResponse
                                              .nextHadith;

                                  newTextOfHadith =
                                      localHadith?.title ?? "الحديث غير متوفر";
                                  newHadithId =
                                      localHadith?.id.toString() ??
                                      "الحديث غير متوفر";

                                  log(newTextOfHadith);

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorsManager.primaryPurple
                                            .withOpacity(0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                            ),
                                            onPressed: () {
                                              prev = true;
                                              context
                                                  .read<
                                                    LocalHadithNavigationCubit
                                                  >()
                                                  .emitLocalNavigation(
                                                    localHadith?.id
                                                            .toString() ??
                                                        widget.hadithNumber ??
                                                        "",
                                                    widget.bookSlug ?? "",
                                                  );
                                            },
                                          ),
                                          Text(
                                            "الحديث رقم ${localHadith?.id ?? 'غير متوفر'}",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsManager.primaryPurple,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                            onPressed: () {
                                              prev = false;
                                              context
                                                  .read<LocalHadithNavigationCubit>()
                                                  .emitLocalNavigation(
                                                    localHadith?.id
                                                            .toString() ??
                                                        widget.hadithNumber ??
                                                        "",
                                                    widget.bookSlug ?? "",
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorsManager.primaryPurple
                                          .withOpacity(0.1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                          onPressed: () {
                                            prev = true;
                                            context
                                                .read<
                                                  LocalHadithNavigationCubit
                                                >()
                                                .emitLocalNavigation(
                                                  widget.hadithNumber ?? "",
                                                  widget.bookSlug ?? "",
                                                );
                                          },
                                        ),
                                        Text(
                                          "الحديث رقم ",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsManager.primaryPurple,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                          ),
                                          onPressed: () {
                                            prev = false;
                                            context
                                                .read<
                                                  LocalHadithNavigationCubit
                                                >()
                                                .emitLocalNavigation(
                                                  widget.hadithNumber ?? "",
                                                  widget.bookSlug ?? "",
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                            : BlocConsumer<NavigationCubit, NavigationState>(
                              listener: (context, state) {
                                if (state is NavigationFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: ColorsManager.error,

                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        state.errMessage,
                                        style: TextStyle(
                                          color:
                                              ColorsManager.secondaryBackground,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (state is NavigationSuccess) {
                                  setState(() {
                                    isNavigated = true;
                                    final hadith =
                                        prev
                                            ? state
                                                .navigationHadithResponse
                                                .prevHadith
                                            : state
                                                .navigationHadithResponse
                                                .nextHadith;

                                    newTextOfHadith =
                                        hadith?.title ?? "الحديث غير متوفر";
                                    newHadithId =
                                        hadith?.id ?? "الحديث غير متوفر";
                                  });
                                }
                              },
                              builder: (context, state) {
                                if (state is NavigationLoading) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorsManager.primaryPurple
                                            .withOpacity(0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              loadingProgressIndicator(
                                                size: 16,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                "الحديث رقم $newHadithId",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ColorsManager
                                                          .primaryPurple,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (state is NavigationSuccess) {
                                  isNavigated = true;
                                  final hadith =
                                      prev
                                          ? state
                                              .navigationHadithResponse
                                              .prevHadith
                                          : state
                                              .navigationHadithResponse
                                              .nextHadith;

                                  newTextOfHadith =
                                      hadith?.title ?? "الحديث غير متوفر";
                                  newHadithId =
                                      hadith?.id ?? "الحديث غير متوفر";

                                  log(newTextOfHadith);

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorsManager.primaryPurple
                                            .withOpacity(0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                            ),
                                            onPressed: () {
                                              prev = true;
                                              context
                                                  .read<NavigationCubit>()
                                                  .emitNavigationStates(
                                                    hadith?.id ??
                                                        widget.hadithNumber ??
                                                        "",
                                                    widget.bookSlug ?? "",
                                                    widget.chapterNumber,
                                                  );
                                            },
                                          ),
                                          Text(
                                            "الحديث رقم ${hadith?.id ?? 'غير متوفر'}",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsManager.primaryPurple,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                            onPressed: () {
                                              prev = false;
                                              context
                                                  .read<NavigationCubit>()
                                                  .emitNavigationStates(
                                                    hadith?.id ??
                                                        widget.hadithNumber ??
                                                        "",
                                                    widget.bookSlug ?? "",
                                                    widget.chapterNumber,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorsManager.primaryPurple
                                          .withOpacity(0.1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                          onPressed: () {
                                            prev = true;
                                            context
                                                .read<NavigationCubit>()
                                                .emitNavigationStates(
                                                  widget.hadithNumber ?? "",
                                                  widget.bookSlug ?? "",
                                                  widget.chapterNumber,
                                                );
                                          },
                                        ),
                                        Text(
                                          "الحديث رقم ",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsManager.primaryPurple,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                          ),
                                          onPressed: () {
                                            prev = false;
                                            context
                                                .read<NavigationCubit>()
                                                .emitNavigationStates(
                                                  widget.hadithNumber ?? "",
                                                  widget.bookSlug ?? "",
                                                  widget.chapterNumber,
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

  Widget _buildEnhancedActionsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.primaryGreen.withOpacity(0.1),
            ColorsManager.primaryPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorsManager.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: HadithActionsRow(hadith: widget.hadithText ?? ""),
    );
  }

  /// Header أنيق وبسيط
  ///
  Widget _buildHadithHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12),
      decoration: BoxDecoration(
        color: ColorsManager.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote,
            color: ColorsManager.primaryGreen,
            size: 28.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNavigated
                      ? 'حديث رقم $newHadithId'
                      : 'حديث رقم ${widget.hadithNumber}',
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

  Widget _buildIslamicSeparator() {
    return Container(
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
