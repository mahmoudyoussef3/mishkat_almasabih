import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'ليس لديك حساب؟',
            style: TextStyles.font13DarkBlueRegular,
          ),
          TextSpan(
            text: '\nأنشئ حساب جديد',
            style: TextStyles.font14BlueSemiBold.copyWith(
              color: ColorsManager.primaryGreen,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    //    context.pushReplacementNamed(Routes.signUpScreen);
                  },
          ),
        ],
      ),
    );
  }
}
