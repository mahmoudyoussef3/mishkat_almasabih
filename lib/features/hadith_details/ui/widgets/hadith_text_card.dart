import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

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
