import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theming/colors.dart';
class BuildWelcomeMessage extends StatelessWidget {
  const BuildWelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'انضم إلي مشكاة ',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryText,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.3),

        SizedBox(height: 8.h),

        Text(
          'أنشئ حسابك وابدأ رحلتك مع الأحاديث والعلوم الإسلامية',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: ColorsManager.secondaryText,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.3),
      ],
    );
  }
}
