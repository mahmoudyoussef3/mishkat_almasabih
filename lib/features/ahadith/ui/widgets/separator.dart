import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class IslamicSeparator extends StatelessWidget {
  const IslamicSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
      child: Row(
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
              Icons.format_quote,
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
      ),
    );
  }
}
