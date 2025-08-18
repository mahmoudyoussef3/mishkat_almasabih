import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      onTap: () {}, // TODO: Navigate to details
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  image: DecorationImage(
                    image: AssetImage(bookImages[book.bookName!] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookNamesArabic[book.bookName] ?? '',
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
                    bookWriters[book.bookName] ?? '',
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
                      BookStat(
                        value: '${book.chapters_count} باب',
                        color: ColorsManager.accentPurple,
                      ),
                      BookStat(
                        value: '${book.hadiths_count} حديث',
                        color: ColorsManager.hadithAuthentic,
                      ),
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
}
