import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_shimer.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/hadith_card_widget.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/screens/hadith_details_screen.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import '../../../search/home_screen/logic/cubit/public_search_cubit.dart';

class PublicSearchResultScreen extends StatelessWidget {
  const PublicSearchResultScreen({super.key, required this.searchQuery});
  final String searchQuery;

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
              description: searchQuery,
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            BlocBuilder<PublicSearchCubit, PublicSearchState>(
              builder: (context, state) {
                if (state is PublicSearchLoading) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const HadithCardShimmer(),
                      childCount: 6,
                    ),
                  );
                } else if (state is PublicSearchSuccess) {
                  final hadiths =
                      state.searchResponse.search?.results?.data ?? [];
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
                                      showNavigation: true,
                                      isLocal: false,
                                      chapterNumber: hadith.chapter?.id.toString()??'',
                                      bookSlug: hadith.book?.bookSlug ?? '',
                                      bookName: hadith.book?.bookName ?? '',
                                      author: hadith.book?.writerName ?? '',
                                      chapter:
                                          hadith.chapter?.chapterArabic ?? '',
                                      hadithNumber: hadith.hadithNumber ?? '',
                                      hadithText: hadith.hadithArabic ?? '',
                                      narrator: hadith.englishNarrator ?? '',
                                      grade: hadith.status ?? '',
                                      authorDeath:
                                          hadith.book?.writerDeath ?? '',
                                    ),
                              ),
                            ),
                        child: HadithCard(
                          bookName: hadith.book?.bookName ?? '',
                          number: hadith.hadithNumber ?? '',
                          text: hadith.hadithArabic ?? '',
                          narrator: hadith.book?.writerName ?? '',
                          grade:
                              hadith.status != null
                                  ? gradeStringArabic(hadith.status!)
                                  : '${index + 1}',
                          reference: hadith.chapter?.chapterArabic ?? '',
                        ),
                      );
                    },
                  );
                } else if (state is PublicSearchFailure) {
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
