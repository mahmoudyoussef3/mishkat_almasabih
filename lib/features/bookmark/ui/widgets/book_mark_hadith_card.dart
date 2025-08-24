import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/delete_cubit/cubit/delete_cubit_cubit.dart';

class BookmarkHadithCard extends StatelessWidget {
  const BookmarkHadithCard({
    super.key,
    required this.hadithNumber,
    required this.hadithText,
    required this.bookName,
    this.chapterName,
    this.collection,
    this.notes,
  });

  final int hadithNumber;
  final String hadithText;
  final String bookName;
  final String? chapterName;
  final String? collection;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsManager.secondaryBackground, ColorsManager.offWhite],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: ColorsManager.primaryGreen,
                      size: 18.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'حديث رقم $hadithNumber',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.primaryText,
                      ),
                    ),
                  ],
                ),

                BlocConsumer<DeleteCubitCubit, DeleteCubitState>(
                  listener: (context, state) {
                    if (state is DeleteLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: ColorsManager.primaryGreen,
                          content: loadingProgressIndicator(
                            size: 30,
                            color: ColorsManager.offWhite,
                          ),
                        ),
                      );
                    } else if (state is DeleteSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: ColorsManager.primaryGreen,
                          content: const Text(
                            'تم حذف الحديث من المحفوظات',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (state is DeleteFaliure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: ColorsManager.primaryGreen,
                          content: const Text(
                            'حدث خطأ. حاول مرة اخري',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is DeleteLoading;

                    return InkWell(
                      onTap:
                          isLoading
                              ? null
                              : () => context.read<DeleteCubitCubit>().delete(
                                hadithNumber,
                              ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color:
                                isLoading
                                    ? ColorsManager.gray
                                    : ColorsManager.error,
                            size: 18.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            isLoading ? 'جارٍ الحذف...' : 'حذف الحديث',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  isLoading
                                      ? ColorsManager.gray
                                      : ColorsManager.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Text(
              hadithText,
              textAlign: TextAlign.right,
              style: TextStyle(
     //           fontFamily: 'FodaFree',
                color: ColorsManager.primaryText,
                fontSize: 16.sp,
                height: 1.8,
              ),
            ),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildGradientPill(
                  text: bookName,
                  colors: [
                    ColorsManager.primaryGreen.withOpacity(0.7),
                    ColorsManager.primaryGreen.withOpacity(0.5),
                  ],
                  textColor: ColorsManager.offWhite,
                ),
                if (chapterName != null && chapterName!.isNotEmpty)
                  _buildGradientPill(
                    text: chapterName!,
                    colors: [
                      ColorsManager.hadithAuthentic.withOpacity(0.7),
                      ColorsManager.hadithAuthentic.withOpacity(0.5),
                    ],
                    textColor: ColorsManager.offWhite,
                  ),
              ],
            ),

            if (notes != null && notes!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                "ملاحظة: ${notes!}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: ColorsManager.primaryGreen,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGradientPill({
    required String text,
    required List<Color> colors,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
