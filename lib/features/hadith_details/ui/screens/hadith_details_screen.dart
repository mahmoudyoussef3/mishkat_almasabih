import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class HadithDetailScreen extends StatelessWidget {
  final String? hadithText;
  final String? narrator;
  final String? grade;
  final String? bookName;
  final String? author;
  final String? chapter;
  final String? authorDeath;
  final String? hadithNumber;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  final String? bookSlug;
  final bool isBookMark;

  const HadithDetailScreen({
    super.key,
    required this.hadithText,
    this.narrator,
    this.grade,
    this.bookName,
    this.author,
    required this.chapter,
    this.authorDeath,
    required this.hadithNumber,
    this.onNext,
    this.onPrev,
    required this.bookSlug,
    this.isBookMark = false,
  });

  String gradeArabic(String g) {
    switch (g.toLowerCase()) {
      case 'sahih':
        return " حديث صحيح ";
      case 'good':
        return " حديث حسن ";
      case "daif":
        return " حديث صعيف ";
      default:
        return '';
    }
  }

  Color _gradeColor(String g) {
    switch (gradeArabic(g)) {
      case " حديث صحيح ":
        return ColorsManager.hadithAuthentic;
      case " حديث حسن ":
        return ColorsManager.hadithGood;
      case " حديث ضعيف ":
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddCubitCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              BuildHeaderAppBar(title: 'تفاصيل الحديث'),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.secondaryPurple.withOpacity(0.15),
                        ColorsManager.white,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    hadithText ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1.8,
                      color: ColorsManager.primaryText,
                      fontFamily: 'Amiri',
                    ),
                  ),
                ),
              ),
              if (grade != null) SliverToBoxAdapter(child: _buildInfoTile()),
              SliverToBoxAdapter(
                child: Divider(
                  color: ColorsManager.primaryNavy,
                  endIndent: 30.h,
                  indent: 30.h,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),

              SliverToBoxAdapter(
                child: _buildSectionCard(
                  title: "عن الكتاب",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookRow("📖 اسم الكتاب", bookName ?? ''),
                      SizedBox(height: 8.h),
                      _buildBookRow("✍️ المؤلف", author ?? "غير متوفر"),
                      SizedBox(height: 8.h),
                      author != null
                          ? _buildBookRow(
                            'وفاة $author ',
                            authorDeath ?? 'غير متوفر',
                          )
                          : SizedBox.shrink(),
                      SizedBox(height: 8.h),
                      _buildBookRow("📌 الباب", chapter ?? ""),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 10.h)),

              SliverToBoxAdapter(
                child: Divider(
                  color: ColorsManager.primaryNavy,
                  endIndent: 30.h,
                  indent: 30.h,
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
                              ClipboardData(text: hadithText ?? ""),
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
                              hadithText ?? "",
                              subject: "شارك الحديث",
                            );
                          },
                        ),
                        if (!isBookMark)
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
                                   showDialog(
    context: context,
    builder: (context) => const AddToFavoritesDialog(),
  );
                                  /*
                                  context.read<AddCubitCubit>().addBookmark(
                                    Bookmark(
                                      bookName: bookName,
                                      chapterName: chapter,
                                      hadithId: hadithNumber,
                                      hadithText: hadithText,

                                      type: 'hadith',
                                      bookSlug: bookSlug,
                                      id: int.parse(hadithNumber!),
                                    ),
                                  );
                                  */
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 10.h)),

              SliverToBoxAdapter(
                child: Divider(
                  color: ColorsManager.primaryNavy,
                  endIndent: 30.h,
                  indent: 30.h,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              if (!isBookMark)
                SliverPadding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  sliver: SliverToBoxAdapter(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: onPrev,
                          ),
                          Text(
                            "الحديث رقم $hadithNumber",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryPurple,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: onNext,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
            ],
          ),
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

  Widget _buildInfoTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _gradeColor(grade ?? '').withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              gradeArabic(grade ?? ""),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: _gradeColor(grade ?? ""),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryPurple,
              ),
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBookRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.darkGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
