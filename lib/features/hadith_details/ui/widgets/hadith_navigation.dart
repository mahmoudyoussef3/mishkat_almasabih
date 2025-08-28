import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithNavigation extends StatelessWidget {
  final String hadithNumber;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const HadithNavigation({
    super.key,
    required this.hadithNumber,
    this.onNext,
    this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primaryPurple.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: onPrev),
            Text(
              "الحديث رقم $hadithNumber",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryPurple,
              ),
            ),
            IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
