import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

// ignore: must_be_immutable
class LibraryScreen extends StatefulWidget {
  LibraryScreen({super.key, required this.id});
  String id;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BookDataCubit>()..emitGetBookData(widget.id),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          appBar: AppBar(
            title: Text(
              'مكتبة الكتب',
              style: TextStyles.headlineMedium.copyWith(
                color: ColorsManager.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            backgroundColor: ColorsManager.primaryGreen,
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<BookDataCubit, BookDataState>(
                  builder: (context, state) {
                    if (state is BookDataLoading) {
                      return loadingProgressIndicator();
                    } else if (state is BookDataSuccess) {
                      final books = state.categoryResponse.books;
        
                    
        
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: books?.length,
                          itemBuilder: (context, index) {
                            final book = books?[index];
                            return _buildBookCard(book!);
                          },
                        ),
                      );
                    } else if (state is BookDataFailure) {
                      return Center(child: Text("Something went wrong"));
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
        
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // صورة الغلاف
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                image: DecorationImage(
                  image: AssetImage(book.category??''),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // معلومات الكتاب
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.bookName??'',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    book.writerName??'',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorsManager.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('${book.chapters_count}', 'أبواب'),
                      _buildStat('${book.hadiths_count}', 'حديث'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryPurple,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: ColorsManager.secondaryText),
        ),
      ],
    );
  }
}
