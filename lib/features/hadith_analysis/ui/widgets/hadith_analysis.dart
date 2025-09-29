import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/logic/cubit/hadith_analysis_cubit.dart';
import 'package:shimmer/shimmer.dart';

class HadithAnalysis extends StatelessWidget {
  HadithAnalysis({
    super.key,
    required this.attribution,
    required this.hadith,
    required this.grade,
    required this.reference,
  });

  final String attribution;
  final String hadith;
  final String grade;
  final String reference;
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AnalyzeButton(
              onTap: () {
                tapped = true;
                context.read<HadithAnalysisCubit>().analyzeHadith(
                  attribution: attribution,
                  hadith: hadith,
                  grade: grade,
                  reference: reference,
                );
              },
            ),
            SizedBox(height: 20.h),
            BlocConsumer<HadithAnalysisCubit, HadithAnalysisState>(
              listenWhen: (prev, curr) => curr is HadithAnalysisError,
              listener: (context, state) {},
              buildWhen:
                  (prev, curr) =>
                      curr is HadithAnalysisLoading ||
                      curr is HadithAnalysisLoaded ||
                      curr is HadithAnalysisError,
              builder: (context, state) {
                if (state is HadithAnalysisLoading) {
                  return _ShimmerResultCard();
                } else if (state is HadithAnalysisLoaded) {
                  return tapped
                      ? _ResultCard(
                        icon: FontAwesomeIcons.bookOpen,
                        title: "تحليل الحديث",
                        text:
                            state.response.analysis ??
                            "لا يوجد تحليل متاح في الوقت الحالي.",
                      )
                      : _ResultCard(
                        icon: FontAwesomeIcons.lightbulb,
                        title: "معلومة",
                        text:
                            "يمكنك الآن الحصول على تحليل سريع للحديث باستخدام الذكاء الاصطناعي.\nاضغط على الزر أعلاه للبدء.",
                        color: ColorsManager.lightPurple,
                        textColor: Colors.black87,
                      );
                } else if (state is HadithAnalysisError) {
                  return tapped
                      ? _ResultCard(
                        icon: FontAwesomeIcons.circleExclamation,
                        title: "خطأ",
                        text: state.message,
                        color: Colors.red.withOpacity(0.08),
                        textColor: Colors.red.shade700,
                      )
                      : _ResultCard(
                        icon: FontAwesomeIcons.lightbulb,
                        title: "معلومة",
                        text:
                            "يمكنك الآن الحصول على تحليل سريع للحديث باستخدام الذكاء الاصطناعي.\nاضغط على الزر أعلاه للبدء.",
                        color: ColorsManager.lightPurple,
                        textColor: Colors.black87,
                      );
                } else {
                  return _ResultCard(
                    icon: FontAwesomeIcons.lightbulb,
                    title: "معلومة",
                    text:
                        "يمكنك الآن الحصول على تحليل سريع للحديث باستخدام الذكاء الاصطناعي.\nاضغط على الزر أعلاه للبدء.",
                    color: ColorsManager.lightPurple,
                    textColor: Colors.black87,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzeButton extends StatefulWidget {
  const _AnalyzeButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_AnalyzeButton> createState() => _AnalyzeButtonState();
}

class _AnalyzeButtonState extends State<_AnalyzeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color:
              _pressed
                  ? ColorsManager.primaryGreen.withOpacity(0.85)
                  : ColorsManager.primaryGreen,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primaryGreen.withOpacity(0.4),
              blurRadius: _pressed ? 2 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.wandMagicSparkles,
              color: ColorsManager.secondaryBackground,
              size: 18.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              "تحليل سريع للحديث",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: ColorsManager.secondaryBackground,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.icon,
    required this.title,
    required this.text,
    this.color,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: ColorsManager.primaryGreen.withOpacity(0.05),
      ),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: textColor ?? ColorsManager.hadithWeak,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? ColorsManager.primaryGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16.sp,
                height: 1.5,
                color: textColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }}
  class _ShimmerResultCard extends StatelessWidget {
  const _ShimmerResultCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 120.w,
                    height: 18.h,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                height: 14.h,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 14.h,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 200.w,
                height: 14.h,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


