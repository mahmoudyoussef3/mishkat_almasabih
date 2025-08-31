import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithTitle extends StatelessWidget {
  final String title;
  const HadithTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.auto_stories,
          color: ColorsManager.primaryPurple,
          size: 24.sp,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryPurple,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
