import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/section_card.dart';

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
    return SectionCard(
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
