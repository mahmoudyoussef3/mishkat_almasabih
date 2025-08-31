import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';

class HadithOfTheDayCard extends StatelessWidget {
  const HadithOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DailyHadithCubit>().emitHadithDaily();
    return BlocBuilder<DailyHadithCubit, DailyHadithState>(
      builder: (context, state) {
        if (state is DailyHaditLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          );
        } else if (state is DailyHadithSuccess) {
          return GestureDetector(
            onTap:
                () => context.pushNamed(
                  Routes.hadithOfTheDay,
                  arguments: state.dailyHadithModel,
                ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorsManager.primaryPurple,
                    ColorsManager.secondaryPurple,
                    ColorsManager.accentPurple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryPurple.withOpacity(0.3),
                    blurRadius: 20.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Islamic pattern overlay
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.5,
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
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with enhanced styling
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.primaryGold.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: ColorsManager.primaryGold.withOpacity(
                                    0.4,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_stories,
                                    color: ColorsManager.primaryGold,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "حديث اليوم",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Hadith title with enhanced typography
                        Expanded(
                          child: Text(
                            state.dailyHadithModel.data?.title ?? "حديث اليوم",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.4,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 8.r,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Enhanced call-to-action button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: Colors.white70),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "اقرأ الحديث",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsManager.secondaryBackground,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorsManager.secondaryBackground,
                                  size: 16.sp,
                                ),
                              ],
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
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.r),
                          bottomLeft: Radius.circular(24.r),
                        ),
                      ),
                      child: Icon(
                        Icons.format_quote,
                        color: ColorsManager.primaryGold.withOpacity(0.6),
                        size: 28.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
