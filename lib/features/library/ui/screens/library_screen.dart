import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/helpers/spacing.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'كتب الأحاديث الكبيرة';

  final List<String> _categories = [
    'كتب الأحاديث الكبيرة',
    'كتب الأربعينات',
    'كتب الأدب والآداب',
  ];

  final List<Map<String, dynamic>> _books = [
    {
      'title': 'صحيح البخاري',
      'author': 'الإمام البخاري',
      'coverImage': 'assets/images/book_covers/bukhari.png',
      'chapterCount': 97,
      'hadithCount': 7563,
      'category': 'كتب الأحاديث الكبيرة',
      'color': ColorsManager.hadithAuthentic,
    },
    {
      'title': 'صحيح مسلم',
      'author': 'الإمام مسلم',
      'coverImage': 'assets/images/book_covers/muslim.png',
      'chapterCount': 54,
      'hadithCount': 7563,
      'category': 'كتب الأحاديث الكبيرة',
      'color': ColorsManager.hadithAuthentic,
    },
    {
      'title': 'الأربعون النووية',
      'author': 'الإمام النووي',
      'coverImage': 'assets/images/book_covers/nawawi.png',
      'chapterCount': 1,
      'hadithCount': 42,
      'category': 'كتب الأربعينات',
      'color': ColorsManager.hadithAuthentic,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          SizedBox(
            height: 50.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = category);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? ColorsManager.primaryPurple
                              : ColorsManager.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color:
                            isSelected
                                ? ColorsManager.primaryPurple
                                : ColorsManager.mediumGray.withOpacity(0.3),
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: ColorsManager.primaryPurple
                                      .withOpacity(0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ]
                              : [],
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyles.labelMedium.copyWith(
                          fontSize: 14.sp,
                          color:
                              isSelected
                                  ? ColorsManager.white
                                  : ColorsManager.primaryText,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.68,
                ),
                itemCount:
                    _books
                        .where((book) => book['category'] == _selectedCategory)
                        .length,
                itemBuilder: (context, index) {
                  final book =
                      _books
                          .where(
                            (book) => book['category'] == _selectedCategory,
                          )
                          .toList()[index];
                  return _buildBookCard(book);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
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
                  image: AssetImage(book['coverImage']),
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
                    book['title'],
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
                    book['author'],
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
                      _buildStat('${book['chapterCount']}', 'أبواب'),
                      _buildStat('${book['hadithCount']}', 'حديث'),
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
