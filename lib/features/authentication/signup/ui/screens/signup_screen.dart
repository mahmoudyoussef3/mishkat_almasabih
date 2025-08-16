import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/features/authentication/login/ui/widgets/login_with_google.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/widgets/already_have_account.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/widgets/build_signup_header.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/widgets/build_welcome_message.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/widgets/sign_up_form.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/widgets/signup_bloc_listener.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../../../core/widgets/app_text_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top spacing

                  // App Logo and Title
                  BuildSignupHeader(),

                  SizedBox(height: 24.h),

                  // Welcome Text
                  BuildWelcomeMessage(),

                  SizedBox(height: 32.h),

                  // Signup Form
                  SignupForm(),

                  SizedBox(height: 32.h),

                  // Signup Button
                  SignupBlocListener(),

                  SizedBox(height: 24.h),

                  // Divider
                  _buildDivider(),

                  SizedBox(height: 24.h),

                  // Already have account
                  AlreadyHaveAccount(),
                  SizedBox(height: 8.h),

                  LoginWithGoogle(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }






  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: ColorsManager.mediumGray)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'أو',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorsManager.secondaryText,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: ColorsManager.mediumGray)),
      ],
    ).animate().fadeIn(delay: 1000.ms, duration: 300.ms).scaleX(begin: 0.0);
  }

}
