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
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsManager.primaryGreen,
                borderRadius: BorderRadius.circular(20.r),
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
              margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: ColorsManager.accentPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 🔹 صورة بخلفية شفافة
                  Opacity(
                    opacity: 0.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        "assets/images/moon-light-shine-through-window-into-islamic-mosque-interior.jpg",
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // محتوى البطاقة
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان فرعي
                        Row(
                          children: [
                            Icon(
                              Icons.auto_stories,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "حديث اليوم",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4.r,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // نص الحديث
                        Text(
                          state.dailyHadithModel.data?.title ?? "حديث اليوم",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.4,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 6.r,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // زر للعرض
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: Colors.white70),
                            ),
                            child: Text(
                              "اضغط للعرض",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
