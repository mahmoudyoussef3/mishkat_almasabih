import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/library/ui/widgets/book_stat.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  static const Map<String, String> bookWriters = {
    "Sahih Bukhari": "الإمام البخاري",
    "Sahih Muslim": "الإمام مسلم",
    "Jami' Al-Tirmidhi": "الإمام الترمذي",
    "Sunan Abu Dawood": "الإمام أبو داود السجستاني",
    "Sunan Ibn-e-Majah": "الإمام ابن ماجه القزويني",
    "Sunan An-Nasa`i": "الإمام النسائي",
    "Mishkat Al-Masabih": "الإمام الخطيب التبريزي",
    "رياض الصالحين": "الإمام يحيى بن شرف النووي",
    "موطأ مالك": "الإمام مالك بن أنس",
    "سنن الدارمي": "الإمام عبد الرحمن بن الدارمي",
    "بلوغ المرام": "الإمام ابن حجر العسقلاني",
    "الأربعون النووية": "الإمام يحيى بن شرف النووي",
    "الأربعون القدسية": "مجموعة من العلماء",
    "أربعون ولي الله الدهلوي": "الشاه ولي الله الدهلوي",
    "الأدب المفرد": "الإمام البخاري",
    "الشمائل المحمدية": "الإمام الترمذي",
    "حصن المسلم": "سعيد بن علي بن وهف القحطاني",
  };

  static const Map<String, String> bookNamesArabic = {
    "Sahih Bukhari": "صحيح البخاري",
    "Sahih Muslim": "صحيح مسلم",
    "Jami' Al-Tirmidhi": "جامع الترمذي",
    "Sunan Abu Dawood": "سنن أبي داود",
    "Sunan Ibn-e-Majah": "سنن ابن ماجه",
    "Sunan An-Nasa`i": "سنن النسائي",
    "Mishkat Al-Masabih": "مشكات المصابيح",
    "رياض الصالحين": "رياض الصالحين",
    "موطأ مالك": "موطأ مالك",
    "سنن الدارمي": "سنن الدارمي",
    "بلوغ المرام": "بلوغ المرام",
    "الأربعون النووية": "الأربعون النووية",
    "الأربعون القدسية": "الأربعون القدسية",
    "أربعون ولي الله الدهلوي": "الأربعون لولي الله الدهلوي",
    "الأدب المفرد": "الأدب المفرد",
    "الشمائل المحمدية": "الشمائل المحمدية",
    "حصن المسلم": "حصن المسلم",
  };

  static const Map<String, String> bookImages = {
    "Sahih Bukhari": "assets/images/book_covers/sahih-bukhari.jpeg",
    "Sahih Muslim": "assets/images/book_covers/sahih-muslim.jpeg",
    "Jami' Al-Tirmidhi": "assets/images/book_covers/al-tirmidhi.jpeg",
    "Sunan Abu Dawood": "assets/images/book_covers/abu-dawood.jpeg",
    "Sunan Ibn-e-Majah": "assets/images/book_covers/ibn-e-majah.jpeg",
    "Sunan An-Nasa`i": "assets/images/book_covers/sunan-nasai.jpeg",
    "Mishkat Al-Masabih": "assets/images/book_covers/mishkat.jpeg",
    "رياض الصالحين": "assets/images/book_covers/riyad_assalihin.jpeg",
    "موطأ مالك": "assets/images/book_covers/malik.jpeg",
    "سنن الدارمي": "assets/images/book_covers/darimi.jpeg",
    "بلوغ المرام": "assets/images/book_covers/bulugh_al_maram.jpeg",
    "الأربعون النووية": "assets/images/book_covers/nawawi40.jpeg",
    "الأربعون القدسية": "assets/images/book_covers/ahadith_qudsi.jpg",
    "أربعون ولي الله الدهلوي": "assets/images/book_covers/shahwaliullah40.jpeg",
    "الأدب المفرد": "assets/images/book_covers/aladab_almufrad.jpeg",
    "الشمائل المحمدية": "assets/images/book_covers/shamail_muhammadiyah.jpeg",
    "حصن المسلم": "assets/images/book_covers/hisnul_muslim.jpeg",
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            Routes.bookChaptersScreen,
            arguments: [
              book.bookSlug!,
              {
                "bookName": bookNamesArabic[book.bookName],
                "writerName": bookWriters[book.bookName],
                "noOfChapters": book.chapters_count.toString(),
                "noOfHadith": book.hadiths_count.toString(),
              },
            ],
          ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.white,
              ColorsManager.offWhite.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primaryPurple.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8.h),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Islamic pattern overlay
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Enhanced book cover section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      child: Stack(
                        children: [
                          // Book cover image
                          Image.asset(
                            bookImages[book.bookName!] ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),

                          // Gradient overlay for better text readability
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),

                          // Decorative corner element
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: ColorsManager.primaryPurple.withOpacity(
                                  0.9,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.primaryPurple
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 3.h),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.book,
                                color: ColorsManager.white,
                                size: 18.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Enhanced book information section
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.white,
                        ColorsManager.offWhite.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book title with enhanced styling
                      Text(
                        bookNamesArabic[book.bookName] ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: ColorsManager.primaryText,
                          fontFamily: 'Amiri',
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 6.h),

                      // Author name with enhanced styling
                      Text(
                        bookWriters[book.bookName] ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ColorsManager.secondaryText,
                          fontFamily: 'Amiri',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12.h),

                      // Enhanced stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BookStat(
                              value: '${book.chapters_count} باب',
                              color: ColorsManager.primaryPurple,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: BookStat(
                              value: '${book.hadiths_count} حديث',
                              color: ColorsManager.hadithAuthentic,
                            ),
                          ),
                        ],
                      ),

                      // Decorative bottom line
                      SizedBox(height: 12.h),
                      Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorsManager.primaryPurple.withOpacity(0.4),
                              ColorsManager.primaryPurple.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
