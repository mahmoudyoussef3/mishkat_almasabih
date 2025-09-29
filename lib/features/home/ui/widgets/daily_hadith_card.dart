import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:transparent_image/transparent_image.dart';

class HadithOfTheDayCard extends StatefulWidget {
  const HadithOfTheDayCard({super.key});

  @override
  State<HadithOfTheDayCard> createState() => _HadithOfTheDayCardState();
}

class _HadithOfTheDayCardState extends State<HadithOfTheDayCard> {
  @override
  void initState() {
          context.read<DailyHadithCubit>().fetchHadith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                color: ColorsManager.primaryGreen,
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
              margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              height: 220.h,
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
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: AssetImage(
                            "assets/images/moon-light-shine-through-window-into-islamic-mosque-interior.jpg",
                          ),
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 700),
                        ),
                      ),
                    ),
                  ),
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
//                        SizedBox(height: 8.h),

                        Flexible(
                          child: Text(
                            state.dailyHadithModel.data?.hadith ?? "حديث اليوم",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
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
        } else if (state is DailyHadithFailure) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Text(
                state.errMessage,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
