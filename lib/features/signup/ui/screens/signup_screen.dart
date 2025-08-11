import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/features/login/ui/widgets/login_with_google.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/app_text_button.dart';

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
  bool _agreeToTerms = false;

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
                  _buildHeaderSection(),

                  SizedBox(height: 24.h),

                  // Welcome Text
                  _buildWelcomeSection(),

                  SizedBox(height: 32.h),

                  // Signup Form
                  _buildSignupForm(),

                  SizedBox(height: 32.h),

                  // Signup Button
                  _buildSignupButton(),

                  SizedBox(height: 24.h),

                  // Divider
                  _buildDivider(),

                  SizedBox(height: 24.h),

                  // Already have account
                  _buildAlreadyHaveAccount(),
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

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // App Logo
        Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.primaryGreen,
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
            .animate()
            .scale(begin: const Offset(0.8, 0.8), duration: 400.ms)
            .then()
            .shimmer(
              duration: 800.ms,
              color: ColorsManager.white.withOpacity(0.3),
            ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
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

  Widget _buildSignupForm() {
    return Column(
      children: [
        // Full Name Field
        AppTextFormField(
          controller: _fullNameController,

          backgroundColor: ColorsManager.lightGray,
          suffixIcon: Icon(Icons.person, color: ColorsManager.primaryGreen),
          hintText: 'الاسم الكامل',
          hintStyle: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال الاسم الكامل';
            }
            if (value.length < 3) {
              return 'الاسم يجب أن يكون 3 أحرف على الأقل';
            }
            return null;
          },
        ).animate().fadeIn(delay: 500.ms, duration: 300.ms).slideX(begin: -0.3),

        SizedBox(height: 16.h),

        // Email Field
        AppTextFormField(
          hintStyle: TextStyle(color: Colors.black),

          backgroundColor: ColorsManager.lightGray,
          suffixIcon: Icon(Icons.email, color: ColorsManager.primaryGreen),
          controller: _emailController,
          hintText: 'البريد الإلكتروني',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ).animate().fadeIn(delay: 600.ms, duration: 300.ms).slideX(begin: -0.3),

        SizedBox(height: 16.h),

        // Password Field
        AppTextFormField(
          hintStyle: TextStyle(color: Colors.black),

          backgroundColor: ColorsManager.lightGray,
          controller: _passwordController,
          hintText: 'كلمة المرور',
          isObscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: ColorsManager.primaryGreen,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال كلمة المرور';
            }
            if (value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }
            return null;
          },
        ).animate().fadeIn(delay: 700.ms, duration: 300.ms).slideX(begin: -0.3),

        SizedBox(height: 16.h),

        // Confirm Password Field
        AppTextFormField(
          hintStyle: TextStyle(color: Colors.black),

          backgroundColor: ColorsManager.lightGray,
          controller: _confirmPasswordController,
          hintText: 'تأكيد كلمة المرور',
          isObscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: ColorsManager.primaryGreen,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى تأكيد كلمة المرور';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ).animate().fadeIn(delay: 800.ms, duration: 300.ms).slideX(begin: -0.3),
      ],
    );
  }

  Widget _buildSignupButton() {
    return AppTextButton(
          backgroundColor: ColorsManager.primaryGreen,
          buttonText: 'إنشاء الحساب',

          onPressed:
              _agreeToTerms
                  ? () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Implement signup logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('جاري إنشاء الحساب...'),
                          backgroundColor: ColorsManager.primaryGreen,
                        ),
                      );
                    }
                  }
                  : () {},

          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: ColorsManager.white,
          ),
        )
        .animate()
        .fadeIn(delay: 900.ms, duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9));
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

  Widget _buildAlreadyHaveAccount() {
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
