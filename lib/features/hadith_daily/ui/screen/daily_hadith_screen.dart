import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_action_row.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_title.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_content_card.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_attribution_and_grade.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_tabs.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_tab_content.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class HadithDailyScreen extends StatefulWidget {
  const HadithDailyScreen({super.key, required this.dailyHadithModel});
  final DailyHadithModel dailyHadithModel;

  @override
  State<HadithDailyScreen> createState() => _HadithDailyScreenState();
}

class _HadithDailyScreenState extends State<HadithDailyScreen> {
  String selectedTab = "شرح";

  @override
  Widget build(BuildContext context) {
    final data = widget.dailyHadithModel.data;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            const BuildHeaderAppBar(
              title: 'حديث اليوم',
              description: 'مكتبة مشكاة الإسلامية',
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data?.title != null) HadithTitle(title: data!.title!),
                    SizedBox(height: 16.h),

                    if (data?.hadith != null)
                      HadithContentCard(data: widget.dailyHadithModel),

                    SizedBox(height: 12.h),

                    HadithAttributionAndGrade(data: widget.dailyHadithModel),
                    SizedBox(height: 16.h),

                    HadithTabs(
                      selectedTab: selectedTab,
                      onTabSelected: (tab) {
                        setState(() => selectedTab = tab);
                      },
                    ),
                    SizedBox(height: 12.h),

                    HadithTabContent(
                      selectedTab: selectedTab,
                      data: widget.dailyHadithModel,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: HadithActionsRow(hadith: data?.hadith ?? ""),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}
