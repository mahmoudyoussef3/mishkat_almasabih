import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class BookStat extends StatelessWidget {
  final String value;
  final Color color;

  const BookStat({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5.r, backgroundColor: color),
        SizedBox(width: 3.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.secondaryText,
          ),
        ),
      ],
    );
  }
}
