import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:shimmer/shimmer.dart';

class HadithOfTheDayCard extends StatefulWidget {
  const HadithOfTheDayCard({super.key});

  @override
  State<HadithOfTheDayCard> createState() => _HadithOfTheDayCardState();
}

class _HadithOfTheDayCardState extends State<HadithOfTheDayCard> {
  DailyHadithModel? hadith;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getHadith();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getHadith() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    
    try {
      final newHadith = await SaveHadithDailyRepo().getHadith();
      if (mounted) {
        setState(() {
          hadith = newHadith;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startPeriodicUpdate() {
    // تحديث كل 15 ثانية للتأكد من عرض آخر داتا
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _getHadith();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmer();
    }

    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.hadithOfTheDay,
        arguments: hadith,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    "assets/images/moon-light-shine-through-window-into-islamic-mosque-interior.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 20.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with enhanced styling
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_stories,
                        color: ColorsManager.secondaryBackground,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "حديث اليوم",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.secondaryBackground,
                        ),
                      ),
                    ],
                  ),

                  Flexible(
                    child: Text(
                      hadith?.data?.hadith ?? "حديث اليوم",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorsManager.secondaryBackground,
                      ),
                    ),
                  ),

                  // Enhanced call-to-action button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Text(
                        "اقرأ الحديث",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.secondaryBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Decorative corner element
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.r),
                    bottomLeft: Radius.circular(24.r),
                  ),
                ),
                child: Icon(
                  Icons.format_quote,
                  color: ColorsManager.secondaryBackground,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsManager.primaryGreen,
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }
}