import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header Section Shimmer
        _buildHeaderShimmer(),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        
        // Search Section Shimmer
        //_buildSearchSectionShimmer(),
        
        // Daily Hadith Shimmer
        _buildDailyHadithShimmer(),
        
        // Divider Shimmer
        _buildDividerShimmer(),
        
        // Statistics Section Shimmer
        _buildStatisticsSectionShimmer(),
        
        // Divider Shimmer
        _buildDividerShimmer(),
        
        // Categories Section Shimmer
        _buildCategoriesSectionShimmer(),
      ],
    );
  }

  // Header Shimmer
  Widget _buildHeaderShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.primaryGreen,
              ColorsManager.primaryGreen.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(height: 100.h),
                    _buildShimmerContainer(160.w, 32.h),
                  ],
                ),
 
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search Section Shimmer
  Widget _buildSearchSectionShimmer() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Card(
          color: ColorsManager.secondaryBackground,
          elevation: 5,
          child: Column(
            children: [
              // Search bar shimmer
              Padding(
                padding: EdgeInsets.all(16.w),
                child: _buildShimmerContainer(
                  double.infinity, 
                  50.h, 
                  borderRadius: 25.r
                ),
              ),
              // Search history shimmer
              SizedBox(
                height: 150.h,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  separatorBuilder: (context, index) => Divider(
                    endIndent: 30.w,
                    indent: 30.w,
                    height: 1.h,
                    color: Colors.grey[300],
                  ),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w, 
                      vertical: 8.h
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildShimmerContainer(120.w, 16.h),
                              SizedBox(height: 4.h),
                              _buildShimmerContainer(80.w, 12.h),
                            ],
                          ),
                        ),
                        _buildShimmerContainer(24.w, 24.h, circular: true),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Daily Hadith Shimmer
  Widget _buildDailyHadithShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        height: 180.h,
        width: double.infinity,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
      ),
    );
  }

  // Statistics Section Shimmer
  Widget _buildStatisticsSectionShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // Statistics Header Shimmer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryPurple.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildShimmerContainer(48.w, 48.h, circular: true),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerContainer(150.w, 20.h),
                        SizedBox(height: 8.h),
                        _buildShimmerContainer(200.w, 14.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            
            // Statistics Cards Shimmer
            Row(
              children: [
                Expanded(child: _buildStatisticsCardShimmer()),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatisticsCardShimmer()),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatisticsCardShimmer()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Statistics Card Shimmer
  Widget _buildStatisticsCardShimmer() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildShimmerContainer(32.w, 32.h, circular: true),
          SizedBox(height: 12.h),
          _buildShimmerContainer(60.w, 24.h),
          SizedBox(height: 8.h),
          _buildShimmerContainer(40.w, 14.h),
        ],
      ),
    );
  }

  // Categories Section Shimmer
  Widget _buildCategoriesSectionShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Header Shimmer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryPurple.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildShimmerContainer(40.w, 40.h, circular: true),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerContainer(120.w, 20.h),
                        SizedBox(height: 8.h),
                        _buildShimmerContainer(180.w, 14.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Category Cards Shimmer
            Column(
              children: [
                _buildCategoryCardShimmer(),
                SizedBox(height: 20.h),
                _buildCategoryCardShimmer(),
                SizedBox(height: 20.h),
                _buildCategoryCardShimmer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Category Card Shimmer
  Widget _buildCategoryCardShimmer() {
    return Container(
      height: 140.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerContainer(100.w, 20.h),
                    SizedBox(height: 8.h),
                    _buildShimmerContainer(80.w, 14.h),
                    SizedBox(height: 12.h),
                    _buildShimmerContainer(150.w, 12.h),
                  ],
                ),
                Row(
                  children: [
                    _buildShimmerContainer(60.w, 16.h),
                    SizedBox(width: 8.w),
                    _buildShimmerContainer(24.w, 16.h, circular: true),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            children: [
              _buildShimmerContainer(60.w, 60.h, circular: true),
              SizedBox(height: 12.h),
              _buildShimmerContainer(40.w, 24.h),
            ],
          ),
        ],
      ),
    );
  }

  // Divider Shimmer
  Widget _buildDividerShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 2.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build shimmer containers
  Widget _buildShimmerContainer(
    double width, 
    double height, {
    bool circular = false,
    double? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: circular 
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(borderRadius ?? 8.r),
        ),
      ),
    );
  }
}