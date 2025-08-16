import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/cubit/login_state.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen:
          (previous, current) =>
              current is LoginLoading ||
              current is LoginSuccess ||
              current is LoginError,
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            builder:
                (context) => const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.primaryGreen,
                  ),
                ),
          );
        } else if (state is LoginSuccess) {
          context.pop();
          context.pushNamed(Routes.mainNavigationScreen);
        } else if (state is LoginError) {
          setupErrorState(context, state.message);
        }
      },
      child:

      AppTextButton(
        buttonText: 'تسجيل الدخول',
        onPressed: () {
          validateThenDoLogin(context);
        },
        backgroundColor: ColorsManager.primaryGreen,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: ColorsManager.white,
          letterSpacing: 0.5,
        ),
      )
          .animate()
          .fadeIn(delay: 900.ms, duration: 300.ms)
          .scale(begin: const Offset(0.9, 0.9))

    );
  }
  void validateThenDoLogin(BuildContext context) {
    if (context.read<LoginCubit>().formKey.currentState!.validate()) {
      context.read<LoginCubit>().emitLoginStates(
      );
    }
  }
}
