import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class EmptyChatState extends StatelessWidget {
  const EmptyChatState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64.sp,
              color: ColorsManager.primaryPurple.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              "ابدأ بكتابة سؤالك لبدء المحادثة",
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "سراج مساعدك الذكي للإجابة على أسئلة الحديث",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.secondaryText.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
