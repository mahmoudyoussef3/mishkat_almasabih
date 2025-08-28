import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

/// ----------- Main Screen -----------
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
              const BuildHeaderAppBar(title: 'تفاصيل الحديث'),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              /// نص الحديث
              SliverToBoxAdapter(
                child: HadithTextCard(hadithText: hadithText ?? ""),
              ),

              /// درجة الحديث
              if (grade != null)
                SliverToBoxAdapter(
                  child: HadithGradeTile(grade: grade!),
                ),

              _buildDivider(),

              /// معلومات الكتاب
              SliverToBoxAdapter(
                child: HadithBookSection(
                  bookName: bookName ?? '',
                  author: author,
                  authorDeath: authorDeath,
                  chapter: chapter ?? "",
                ),
              ),

              _buildDivider(),

              /// أزرار الأكشن (نسخ - مشاركة - حفظ)
              SliverToBoxAdapter(
                child: HadithActions(
                  hadithText: hadithText ?? "",
                  isBookMark: isBookMark,
                  bookName: bookName ?? '',
                  bookSlug: bookSlug ?? '',
                  chapter: chapter ?? '',
                  hadithNumber: hadithNumber ?? '',
                ),
              ),

              _buildDivider(),

              /// التنقل بين الأحاديث
              if (!isBookMark)
                SliverToBoxAdapter(
                  child: HadithNavigation(
                    hadithNumber: hadithNumber ?? "",
                    onNext: onNext,
                    onPrev: onPrev,
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Divider(
            color: ColorsManager.primaryNavy,
            endIndent: 30.h,
            indent: 30.h,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

/// ----------- Widgets -----------

/// نص الحديث
class HadithTextCard extends StatelessWidget {
  final String hadithText;
  const HadithTextCard({super.key, required this.hadithText});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        hadithText,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 18.sp,
          height: 1.8,
          color: ColorsManager.primaryText,
          fontFamily: 'Amiri',
        ),
      ),
    );
  }
}

/// درجة الحديث
class HadithGradeTile extends StatelessWidget {
  final String grade;
  const HadithGradeTile({super.key, required this.grade});

  String gradeArabic(String g) {
    switch (g.toLowerCase()) {
      case 'sahih':
        return " حديث صحيح ";
      case 'good':
        return " حديث حسن ";
      case "daif":
        return " حديث ضعيف ";
      default:
        return '';
    }
  }

  Color gradeColor(String g) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: gradeColor(grade).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          gradeArabic(grade),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: gradeColor(grade),
          ),
        ),
      ),
    );
  }
}

/// معلومات الكتاب
class HadithBookSection extends StatelessWidget {
  final String bookName;
  final String? author;
  final String? authorDeath;
  final String chapter;

  const HadithBookSection({
    super.key,
    required this.bookName,
    this.author,
    this.authorDeath,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: "عن الكتاب",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookRow("📖 اسم الكتاب", bookName),
          SizedBox(height: 8.h),
          _buildBookRow("✍️ المؤلف", author ?? "غير متوفر"),
          if (author != null) ...[
            SizedBox(height: 8.h),
            _buildBookRow('وفاة $author ', authorDeath ?? 'غير متوفر'),
          ],
          SizedBox(height: 8.h),
          _buildBookRow("📌 الباب", chapter),
        ],
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

/// أزرار النسخ / المشاركة / الحفظ
class HadithActions extends StatelessWidget {
  final String hadithText;
  final bool isBookMark;
  final String bookName;
  final String bookSlug;
  final String chapter;
  final String hadithNumber;

  const HadithActions({
    super.key,
    required this.hadithText,
    required this.isBookMark,
    required this.bookName,
    required this.bookSlug,
    required this.chapter,
    required this.hadithNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primaryPurple.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ActionButton(
              icon: Icons.copy,
              label: "نسخ",
              onTap: () {
                Clipboard.setData(ClipboardData(text: hadithText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم نسخ الحديث")),
                );
              },
            ),
            _ActionButton(
              icon: Icons.share,
              label: "مشاركة",
              onTap: () async {
                await Share.share(hadithText, subject: "شارك الحديث");
              },
            ),
            if (!isBookMark)
              BlocConsumer<AddCubitCubit, AddCubitState>(
                listener: (context, state) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (state is AddLoading) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: ColorsManager.primaryGreen,
                        content: Text("تم اضافة الحديث إلي المحفوظات"),
                      ),
                    );
                  } else if (state is AddFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("حدث خطأ. حاول مرة اخري"),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return _ActionButton(
                    icon: Icons.bookmark,
                    label: "حفظ",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  getIt<GetCollectionsBookmarkCubit>(),
                            ),
                            BlocProvider(
                              create: (context) => getIt<AddCubitCubit>(),
                            ),
                          ],
                          child: AddToFavoritesDialog(
                            bookName: bookName,
                            bookSlug: bookSlug,
                            chapter: chapter,
                            hadithNumber: hadithNumber,
                            hadithText: hadithText,
                            id: hadithNumber,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// زرار أكشن صغير
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// التنقل بين الأحاديث
class HadithNavigation extends StatelessWidget {
  final String hadithNumber;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const HadithNavigation({
    super.key,
    required this.hadithNumber,
    this.onNext,
    this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primaryPurple.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: onPrev),
            Text(
              "الحديث رقم $hadithNumber",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryPurple,
              ),
            ),
            IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

/// كارت عام لعرض أي سيكشن
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
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
}
