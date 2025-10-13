import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart' show Routes;
import 'package:mishkat_almasabih/core/theming/colors.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب ؟ ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorsManager.secondaryText,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(Routes.signupScreen);
          },
          child: Text(
            'أنشئ حساب',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.primaryGreen,
          
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 2600.ms, duration: 600.ms);
  }
}
