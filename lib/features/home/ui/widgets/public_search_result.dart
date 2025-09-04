import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_widget.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/search/logic/cubit/enhanced_search_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/logic/cubit/search_with_filters_cubit.dart';
import '../../../search/home_screen/logic/cubit/public_search_cubit.dart';

class PublicSearchResultScreen extends StatelessWidget {
  const PublicSearchResultScreen({super.key, required this.searchQuery});
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(
              title: "نتائج البحث عن",
              description: searchQuery??"",
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            //            BlocBuilder<PublicSearchCubit, PublicSearchState>(
            BlocBuilder<EnhancedSearchCubit, EnhancedSearchState>(
              builder: (context, state) {
                if (state is EnhancedSearchLoading) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const HadithCardShimmer(),
                      childCount: 6,
                    ),
                  );
                } else if (state is EnhancedSearchLoaded) {
                  final hadiths =
                      state.enhancedSearch.results??[];
                  if (hadiths.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "لا توجد نتائج",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: hadiths.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          color: ColorsManager.primaryNavy,
                          endIndent: 30.h,
                          indent: 30.h,
                        ),
                    itemBuilder: (context, index) {
                      final hadith = hadiths[index];
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HadithDetailScreen(
                                      isBookMark: false,
                                      showNavigation: true,
                                    
                                      isLocal: false,
                                      chapterNumber:
                                        '',
                                      bookSlug:'',
                                      bookName:  '',
                                      author: '',
                                      chapter:
                                    '',
                                      hadithNumber: '',
                                      hadithText: hadith.hadeeth ?? '',
                                      narrator: hadith.attribution ?? '',
                                      grade: hadith.grade ?? '',
                                      authorDeath:
                                        '',
                                    ),
                              ),
                            ),
                        child: HadithCard(
                          number: hadith.id??'',
                          bookName: hadith.reference??'',
                        
                          text: hadith.hadeeth ?? '',
                          narrator: hadith.attribution ?? '',
                          grade:
                              hadith.grade != null
                                  ? gradeStringArabic(hadith.grade??'')
                                  : '${index + 1}',
                          reference: hadith.reference ??'',
                        ),
                      );
                    },
                  );
                } else if (state is EnhancedSearchError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("خطأ: ${state.message}")),
                  );
                }

                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  Color gradeColor(String? g) {
    switch (g?.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return ColorsManager.hadithAuthentic;
      case "hasan":
      case "حسن":
        return ColorsManager.hadithGood;
      case "daif":
      case "ضعيف":
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.hadithAuthentic;
    }
  }

  String gradeStringArabic(String grade) {
    switch (grade.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return 'صحيح';
      case "hasan":
      case "حسن":
        return "حسن";
      case "daif":
      case "ضعيف":
        return "ضعيف";
      default:
        return '';
    }
  }
}
