import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class HadithDailyScreen extends StatefulWidget {
  const HadithDailyScreen({super.key});

  @override
  State<HadithDailyScreen> createState() => _HadithDailyScreenState();
}

class _HadithDailyScreenState extends State<HadithDailyScreen> {
  @override
  void initState() {
    super.initState();
    getHadithDaily();
  }

  Future<void> getHadithDaily() async {
    await context.read<DailyHadithCubit>().emitHadithDaily();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: BlocBuilder<DailyHadithCubit, DailyHadithState>(
          builder: (context, state) {
            if (state is DailyHaditLoading) {
              return loadingProgressIndicator();
            } else if (state is DailyHadithSuccess) {
              final data = state.dailyHadithModel.data;

              return CustomScrollView(
                slivers: [
                  BuildHeaderAppBar(
                    title: 'حديث اليوم',
                    description: 'مكتبة مشكاة الإسلامية',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.screenHorizontal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Title
                          if (data?.title != null)
                            Text(
                              data!.title!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primaryPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(height: 16.h),

                          /// Hadith
                          if (data?.hadith != null)
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: ColorsManager.secondaryBackground,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.darkPurple.withOpacity(
                                      0.05,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                data!.hadith!,
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(height: 16.h),

                          /// Attribution
                          if (data?.attribution != null)
                            Text(
                              "📖 ${data!.attribution!}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: ColorsManager.accentPurple,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(height: 10.h),

                          /// Grade
                          if (data?.grade != null)
                            Center(
                              child: Chip(
                                backgroundColor: gradeColor(
                                  data?.grade!,
                                ).withOpacity(0.1),
                                label: Text(
                                  " ${data!.grade!}",
                                  style: TextStyle(
                                    color: gradeColor(data.grade!),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 20.h),
                          Divider(
                            color: ColorsManager.lightPurple,
                            thickness: .8,
                          ),

                          /// Explanation
                          if (data?.explanation != null) ...[
                            sectionTitle("📌 الشرح:"),
                            SizedBox(height: 6.h),
                            Text(
                              data!.explanation!,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 20.h),
                            Divider(
                              color: ColorsManager.lightPurple,
                              thickness: .8,
                            ),
                          ],

                          /// Hints
                          if (data?.hints != null &&
                              data!.hints!.isNotEmpty) ...[
                            sectionTitle("🔑 فوائد الحديث:"),
                            SizedBox(height: 6.h),
                            ...data.hints!.map(
                              (hint) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "• ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        hint,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Divider(
                              color: ColorsManager.lightPurple,
                              thickness: .8,
                            ),
                          ],

                          /// Words Meanings
                          if (data?.wordsMeanings != null &&
                              data!.wordsMeanings!.isNotEmpty) ...[
                            sectionTitle("📘 معاني الكلمات:"),
                            SizedBox(height: 6.h),
                            ...data.wordsMeanings!.map(
                              (wm) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wm.word ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsManager.darkPurple,
                                      ),
                                    ),
                                    const Text(": "),
                                    Expanded(
                                      child: Text(
                                        wm.meaning ?? "",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 64.h)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Reusable Section Title
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorsManager.primaryGold,
      ),
    );
  }

  /// Grade Color Mapping
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
}
