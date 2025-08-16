import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorsManager.secondaryText,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(Routes.loginScreen);
          },
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.primaryGreen,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1100.ms, duration: 300.ms);
  }
}
