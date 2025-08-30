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

            // Enhanced header section
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: _buildDailyHadithHeader(),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data?.title != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: HadithTitle(title: data!.title!),
                      ),

                    if (data?.hadith != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: HadithContentCard(data: widget.dailyHadithModel),
                      ),

                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      child: HadithAttributionAndGrade(
                        data: widget.dailyHadithModel,
                      ),
                    ),

                    // Enhanced tabs section
                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      child: _buildEnhancedTabsSection(),
                    ),

                    HadithTabContent(
                      selectedTab: selectedTab,
                      data: widget.dailyHadithModel,
                    ),
                  ],
                ),
              ),
            ),

            // Enhanced actions section
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: _buildEnhancedActionsSection(),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyHadithHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.primaryPurple.withOpacity(0.1),
            ColorsManager.primaryGold.withOpacity(0.05),
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
              Icons.auto_stories,
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
                  'حديث اليوم',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'نص حديث نبوي شريف مع شرحه',
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

  Widget _buildEnhancedTabsSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: HadithTabs(
        selectedTab: selectedTab,
        onTabSelected: (tab) {
          setState(() => selectedTab = tab);
        },
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
            ColorsManager.primaryGold.withOpacity(0.1),
            ColorsManager.primaryPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorsManager.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: ColorsManager.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.share,
                  color: ColorsManager.primaryGold,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'إجراءات الحديث',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          HadithActionsRow(hadith: widget.dailyHadithModel.data?.hadith ?? ""),
        ],
      ),
    );
  }
}
