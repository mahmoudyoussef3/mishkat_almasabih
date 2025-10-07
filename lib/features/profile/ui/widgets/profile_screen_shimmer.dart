import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theming/colors.dart';

class ProfileShimmerScreen extends StatelessWidget {
  const ProfileShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: CustomScrollView(
        slivers: [
          /// Header Shimmer
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Row(
                children: [
                  _shimmerCircle(70.w, 70.w),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(120.w, 16.h),
                        SizedBox(height: 8.h),
                        _shimmerBox(80.w, 14.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
    
          /// Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _shimmerSection(),
                  ),
                ),
              ),
            ),
          ),
    
          /// Footer Shimmer
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.primaryPurple,
                    Colors.deepPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _shimmerCircle(120.w, 120.w),
                  SizedBox(height: 10.h),
                  _shimmerBox(200.w, 14.h),
                  SizedBox(height: 10.h),
                  _shimmerBox(150.w, 12.h),
                  SizedBox(height: 20.h),
    
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 18.w,
                    children: List.generate(
                      5,
                      (_) => _shimmerCircle(50.w, 50.w),
                    ),
                  ),
                  SizedBox(height: 20.h),
    
                  _shimmerBox(250.w, 12.h),
                  SizedBox(height: 10.h),
                  _shimmerBox(220.w, 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height) {
    return Shimmer.fromColors(
      baseColor: ColorsManager.gray.withOpacity(0.3),
      highlightColor: ColorsManager.white.withOpacity(0.6),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double width, double height) {
    return Shimmer.fromColors(
      baseColor: ColorsManager.gray.withOpacity(0.3),
      highlightColor: ColorsManager.white.withOpacity(0.6),
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _shimmerSection() {
    return Shimmer.fromColors(
      baseColor: ColorsManager.gray.withOpacity(0.3),
      highlightColor: ColorsManager.white.withOpacity(0.6),
      child: Container(
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}
