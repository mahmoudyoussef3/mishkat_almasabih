import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/logic/cubit/hadith_analysis_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_action_row.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/ui/widgets/hadith_analysis.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_books_section.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_grade_title.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_text_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';
import 'package:mishkat_almasabih/features/navigation/logic/local/cubit/local_hadith_navigation_cubit.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';

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
    required this.narrator,
    required this.grade,
    required this.bookName,
    required this.author,
    required this.chapter,
    required this.authorDeath,
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

  bool _isValid(String? text) => text != null && text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddCubitCubit>()),
        BlocProvider(create: (context) => getIt<NavigationCubit>()),
        BlocProvider(create: (context) => getIt<LocalHadithNavigationCubit>()),
        BlocProvider(
          create:
              (context) =>
                  getIt<HadithAnalysisCubit>()..analyzeHadith(
                    hadith: widget.hadithText ?? '',
                    attribution: widget.author ?? '',
                    grade: widget.grade ?? '',
                    reference: widget.bookName ?? '',
                  ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
   floatingActionButton: Builder(
  builder: (context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.pushNamed(
          Routes.serag,
          arguments: SeragRequestModel(
            hadith: Hadith(
              sharh: context.read<HadithAnalysisCubit>().sharhHadith,
              hadeeth: widget.hadithText ?? '',
              grade_ar: widget.grade ?? '',
              source: widget.bookName ?? '',
              takhrij_ar: widget.narrator ?? '',
            ),
            messages: [Message(role: 'user', content: '')],
          ),
        );
      },
      backgroundColor: ColorsManager.primaryPurple,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: CircleAvatar(
        radius: 20.r, 
        backgroundImage: const AssetImage('assets/images/serag_logo.jpg'),
        backgroundColor: Colors.transparent,
      ),
      label: Text(
        "اسأل سراج",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: ColorsManager.secondaryBackground,
        ),
      ),
    );
  },
),

          backgroundColor: ColorsManager.secondaryBackground,
          body: CustomScrollView(
            slivers: [
              BuildHeaderAppBar(title: 'تفاصيل الحديث'),

              if (_isValid(widget.hadithNumber) || _isValid(widget.bookName))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 16.h,
                    ),
                    child: _buildHadithHeader(),
                  ),
                ),

              if (_isValid(widget.hadithText))
                SliverToBoxAdapter(
                  child: HadithTextCard(
                    hadithText:
                        isNavigated
                            ? newTextOfHadith
                            : widget.hadithText ?? "الحديث غير متوفر",
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              HadithAnalysis(
                attribution: widget.narrator ?? '',
                hadith: widget.hadithText ?? '',
                grade: widget.grade ?? '',
                reference: widget.bookName ?? '',
              ),

              if (_isValid(widget.grade))
               _buildDividerSection(),

              if (_isValid(widget.grade))
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

              if (_isValid(widget.bookName) ||
                  _isValid(widget.author) ||
                  _isValid(widget.chapter))
                _buildDividerSection(),

              if (_isValid(widget.bookName) ||
                  _isValid(widget.author) ||
                  _isValid(widget.chapter))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: HadithBookSection(
                      bookName: widget.bookName ?? '',
                      author: widget.author,
                      authorDeath: widget.authorDeath,
                      chapter: widget.chapter ?? '',
                    ),
                  ),
                ),

              _buildDividerSection(),

              /// Actions Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: _buildEnhancedActionsSection(),
                ),
              ),

              /// Navigation Section
              if (widget.showNavigation && !widget.isBookMark)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child:
                        widget.isLocal
                            ? _buildLocalNavigation()
                            : _buildRemoteNavigation(),
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
      child: HadithActionsRow(
      
        author: widget.author ?? "",
        authorDeath: widget.authorDeath ?? "",
        grade: widget.grade ?? "",
        isBookmarked: widget.isBookMark,
        bookName: widget.bookName ?? "",
        bookSlug: widget.bookSlug ?? "",
        chapter: widget.chapterNumber,
        hadithNumber: widget.hadithNumber ?? "",
        id: widget.hadithNumber ?? "",
        hadith: widget.hadithText ?? "",
      ),
    );
  }

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
                if (_isValid(widget.hadithNumber) || isNavigated)
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
                if (_isValid(widget.bookName))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                        Divider(endIndent: 60.w),

                      Text(
                        'من ${widget.bookName}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ColorsManager.secondaryText,
                        ),
                      ),
                    ],
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

  /// Local Navigation
  Widget _buildLocalNavigation() {
    return BlocConsumer<LocalHadithNavigationCubit, LocalHadithNavigationState>(
      listener: (context, state) {
        if (state is LocalHadithNavigationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorsManager.error,
              behavior: SnackBarBehavior.floating,
              content: Text(
                state.errMessage,
                style: TextStyle(color: ColorsManager.secondaryBackground),
              ),
            ),
          );
        }
        if (state is LocalHadithNavigationSuccess) {
          setState(() {
            isNavigated = true;
            final hadith =
                prev
                    ? state.navigationHadithResponse.prevHadith
                    : state.navigationHadithResponse.nextHadith;

            newTextOfHadith = hadith?.title ?? "الحديث غير متوفر";
            newHadithId = hadith?.id.toString() ?? "الحديث غير متوفر";
          });
        }
      },
      builder: (context, state) {
        return _buildNavigationContainer(
          isLoading: state is NavigationLoading,
          hadithId: newHadithId,
          onPrev: () {
            prev = true;
            context.read<LocalHadithNavigationCubit>().emitLocalNavigation(
              widget.hadithNumber ?? "",
              widget.bookSlug ?? "",
            );
          },
          onNext: () {
            prev = false;
            context.read<LocalHadithNavigationCubit>().emitLocalNavigation(
              widget.hadithNumber ?? "",
              widget.bookSlug ?? "",
            );
          },
        );
      },
    );
  }

  /// Remote Navigation
  Widget _buildRemoteNavigation() {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state is NavigationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorsManager.error,
              behavior: SnackBarBehavior.floating,
              content: Text(
                state.errMessage,
                style: TextStyle(color: ColorsManager.secondaryBackground),
              ),
            ),
          );
        }
        if (state is NavigationSuccess) {
          setState(() {
            isNavigated = true;
            final hadith =
                prev
                    ? state.navigationHadithResponse.prevHadith
                    : state.navigationHadithResponse.nextHadith;

            newTextOfHadith = hadith?.title ?? "الحديث غير متوفر";
            newHadithId = hadith?.id ?? "الحديث غير متوفر";
          });
        }
      },
      builder: (context, state) {
        return _buildNavigationContainer(
          isLoading: state is NavigationLoading,
          hadithId: newHadithId,
          onPrev: () {
            prev = true;
            context.read<NavigationCubit>().emitNavigationStates(
              widget.hadithNumber ?? "",
              widget.bookSlug ?? "",
              widget.chapterNumber,
            );
          },
          onNext: () {
            prev = false;
            context.read<NavigationCubit>().emitNavigationStates(
              widget.hadithNumber ?? "",
              widget.bookSlug ?? "",
              widget.chapterNumber,
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationContainer({
    required bool isLoading,
    required String hadithId,
    required VoidCallback onPrev,
    required VoidCallback onNext,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorsManager.primaryPurple.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: onPrev),
          isLoading
              ? Row(
                children: [
                  loadingProgressIndicator(size: 16),
                  SizedBox(width: 8.w),
                  Text(
                    "جاري التحميل...",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryPurple,
                    ),
                  ),
                ],
              )
              : Text(
                "الحديث رقم $hadithId",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryPurple,
                ),
              ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
