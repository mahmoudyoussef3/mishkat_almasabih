import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bookmark/data/models/book_mark_model.dart';
import '../../../bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';

class HadithDailyScreen extends StatefulWidget {
  const HadithDailyScreen({super.key});

  @override
  State<HadithDailyScreen> createState() => _HadithDailyScreenState();
}

class _HadithDailyScreenState extends State<HadithDailyScreen> {
  String selectedTab = "شرح"; // الافتراضي

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
                          SizedBox(height: 8.h),

                          /// Attribution
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                            children: [
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
                          ],),
                      
                          SizedBox(height: 8.h),
                           
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: ColorsManager.primaryGreen)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                tabButton("شرح"),
                                tabButton("الدروس المستفادة"),
                                tabButton("معاني الكلمات"),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),

                          /// Container يظهر حسب الاختيار
                          Container(
                            width: double.infinity,
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
                            child: buildSelectedContent(data),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                     SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorsManager.primaryPurple.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy,
                          label: "نسخ",
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: data?.hadith ?? ""),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم نسخ الحديث")),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.share,
                          label: "مشاركة",
                          onTap: () async {
                            await Share.share(
                              data?.hadith ?? "",
                              subject: "شارك الحديث",
                            );
                          },
                        ),
                          BlocConsumer<AddCubitCubit, AddCubitState>(
                            listener: (context, state) {
                              if (state is AddLoading) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ColorsManager.primaryGreen,
                                    content: loadingProgressIndicator(
                                      size: 30,
                                      color: ColorsManager.offWhite,
                                    ),
                                  ),
                                );
                              } else if (state is AddSuccess) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ColorsManager.primaryGreen,
                                    content: Text(
                                      'تم اضافة الحديث إلي المحفوظات',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else if (state is AddFailure) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ColorsManager.primaryGreen,
                                    content: Text(
                                      'حدث خطأ. حاول مرة اخري',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return _buildActionButton(
                                icon: Icons.bookmark,
                                label: "حفظ",
                                onTap: () async {
                                  context.read<AddCubitCubit>().addBookmark(
                                    Bookmark(
                                      bookName: '',
                                      chapterName: '',
                                      hadithId: '',
                                      hadithText: data?.hadith,
                                      type: 'hadith',
                                      bookSlug: '',
                                      
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 100.h,),)
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsManager.primaryPurple.withOpacity(0.1),
            child: Icon(icon, color: ColorsManager.primaryPurple),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: ColorsManager.darkGray),
          ),
        ],
      ),
    );
  }
  /// زر تبويب
  Widget tabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? ColorsManager.primaryPurple.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ColorsManager.primaryPurple : Colors.black87,
          ),
        ),
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

  /// محتوى حسب التبويب
  Widget buildSelectedContent(data) {
    switch (selectedTab) {
      case "شرح":
        return Text(
          data?.explanation ?? "لا يوجد شرح",
          style: const TextStyle(fontSize: 16, height: 1.6),
          textAlign: TextAlign.justify,
        );
      case "الدروس المستفادة":
        if (data?.hints != null && data.hints!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                data.hints!
                    .map<Widget>(
                      (hint) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "• $hint",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
          );
        } else {
          return const Text("لا توجد فوائد");
        }
      case "معاني الكلمات":
        if (data?.wordsMeanings != null && data.wordsMeanings!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                data.wordsMeanings!
                    .map<Widget>(
                      (wm) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: wm.word ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.darkPurple,
                                ),
                              ),
                              const TextSpan(
                                text: ": ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.darkPurple,
                                ),
                              ),
                              TextSpan(
                                text: wm.meaning ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          );
        } else {
          return const Text("لا توجد معاني");
        }
      default:
        return const SizedBox.shrink();
    }
  }
}
