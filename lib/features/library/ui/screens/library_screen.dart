import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/library/ui/widgets/book_grid.dart';

class LibraryScreen extends StatefulWidget {
  final String id;
  final String name;

  const LibraryScreen({super.key, required this.id, required this.name});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const crossAxisCount = 2;
    final spacing = 12 * (crossAxisCount - 1);
    final itemWidth = (screenWidth - spacing) / crossAxisCount;
    final itemHeight = itemWidth * 1.5;
    final aspectRatio = itemWidth / itemHeight;

    return BlocProvider(
      create: (context) => getIt<BookDataCubit>()..emitGetBookData(widget.id),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              // Enhanced header with Islamic design
              _buildEnhancedHeader(),

              SliverToBoxAdapter(child: SizedBox(height: 20.h)),

              // Enhanced content section
              BlocBuilder<BookDataCubit, BookDataState>(
                builder: (context, state) {
                  if (state is BookDataLoading) {
                    return _buildEnhancedLoadingState(aspectRatio);
                  } else if (state is BookDataSuccess) {
                    final books = state.categoryResponse.books ?? [];
                    return _buildEnhancedSuccessState(books, aspectRatio);
                  } else if (state is BookDataFailure) {
                    return _buildEnhancedErrorState();
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.primaryPurple.withOpacity(0.05),
              ColorsManager.primaryPurple.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Enhanced app bar
            BuildHeaderAppBar(title: widget.name),

            SizedBox(height: 16.h),

            // Islamic decorative separator
            _buildIslamicSeparator(),

            SizedBox(height: 16.h),

            // Enhanced description
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.white.withOpacity(0.8),
                    ColorsManager.offWhite.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorsManager.primaryPurple.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Icon(
                      Icons.library_books,
                      color: ColorsManager.primaryPurple,
                      size: 24.r,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مكتبة ${widget.name}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: ColorsManager.primaryText,
                            fontFamily: 'Amiri',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'استكشف الكتب والأبواب والأحاديث',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorsManager.secondaryText,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
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

  Widget _buildIslamicSeparator() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsManager.primaryPurple.withOpacity(0.3),
                  ColorsManager.primaryPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.auto_stories,
            color: ColorsManager.primaryPurple,
            size: 20.r,
          ),
        ),
        Expanded(
          child: Container(
            height: 2.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsManager.primaryPurple.withOpacity(0.1),
                  ColorsManager.primaryPurple.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedLoadingState(double aspectRatio) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.white,
              ColorsManager.offWhite.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Loading header
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.hourglass_empty,
                    color: ColorsManager.primaryPurple,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: ColorsManager.lightGray,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 200.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: ColorsManager.lightGray,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Loading grid
            BookGrid.shimmer(aspectRatio: aspectRatio),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedSuccessState(List<dynamic> books, double aspectRatio) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.white,
              ColorsManager.offWhite.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primaryPurple.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 6.h),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Success header
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: ColorsManager.hadithAuthentic.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: ColorsManager.hadithAuthentic,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تم تحميل ${books.length} كتاب',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.primaryText,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'اختر كتاباً لاستكشاف محتواه',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorsManager.secondaryText,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Book grid
            BookGrid.success(
              books: books.cast<Book>(),
              aspectRatio: aspectRatio,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedErrorState() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.white,
              ColorsManager.offWhite.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: ColorsManager.hadithWeak.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.hadithWeak.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8.h),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: ColorsManager.hadithWeak.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40.r,
                color: ColorsManager.hadithWeak,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: ColorsManager.primaryText,
                fontFamily: 'Amiri',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'فشل في تحميل البيانات',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.secondaryText,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
