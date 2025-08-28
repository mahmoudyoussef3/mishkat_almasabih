import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_actions.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_books_section.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_grade_title.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_navigation.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_text_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';

class HadithDetailScreen extends StatelessWidget {
  final String? hadithText;
  final String? narrator;
  final String? grade;
  final String? bookName;
  final String? author;
  final String? chapter;
  final String? authorDeath;
  final String? hadithNumber;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
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
    this.onNext,
    this.onPrev,
    required this.bookSlug,
    this.isBookMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddCubitCubit>()),
        BlocProvider(
          create: (context) => getIt<NavigationCubit>()
            ..emitNavigationStates(
              hadithNumber.toString(),
              bookSlug ?? '',
              chapterNumber,
            ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              const BuildHeaderAppBar(title: 'تفاصيل الحديث'),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              SliverToBoxAdapter(
                child: HadithTextCard(hadithText: hadithText ?? ""),
              ),

              if (grade != null)
                SliverToBoxAdapter(
                  child: SizedBox(child: HadithGradeTile(grade: grade!)),
                ),

              _buildDivider(),

              SliverToBoxAdapter(
                child: HadithBookSection(
                  bookName: bookName ?? '',
                  author: author,
                  authorDeath: authorDeath,
                  chapter: chapter ?? "",
                ),
              ),

              _buildDivider(),

              SliverToBoxAdapter(
                child: HadithActions(
                  hadithText: hadithText ?? "",
                  isBookMark: isBookMark,
                  bookName: bookName ?? '',
                  bookSlug: bookSlug ?? '',
                  chapter: chapter ?? '',
                  hadithNumber: hadithNumber ?? '',
                ),
              ),

              _buildDivider(),

              if (!isBookMark)
                SliverToBoxAdapter(
                  child: HadithNavigation(
                    hadithNumber: hadithNumber ?? "",
                    bookSlug: bookSlug ?? '',
                    chapterNumber: chapterNumber,
                    onNext: onNext,
                    onPrev: onPrev,
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Divider(
            color: ColorsManager.primaryNavy,
            endIndent: 30.h,
            indent: 30.h,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
