import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/features/authentication/login/logic/cubit/login_cubit.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<LoginCubit>().emitGoogleLoginStates();
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    'تسجيل الدخول عبر جوجل',
                    style: TextStyle(color: ColorsManager.darkGray),
                  ),
                  SizedBox(width: 12.w),
                  FaIcon(
                    FontAwesomeIcons.google,
                    color: ColorsManager.darkGray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
