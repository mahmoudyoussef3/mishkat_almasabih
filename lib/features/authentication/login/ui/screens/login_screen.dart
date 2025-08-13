import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../widgets/don`t_have_account_text.dart';
import '../widgets/login_with_google.dart';
import '../widgets/terms_and_conditions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top spacing
                  SizedBox(height: 60.h),

                  // App Logo and Title
                  _buildHeaderSection(),

                  SizedBox(height: 60.h),

                  // Login Form
                  _buildLoginForm(),

                  SizedBox(height: 24.h),

                  _buildRememberMeSection(),

                  SizedBox(height: 24.h),

                  // Login Button
                  _buildLoginButton(),

                  SizedBox(height: 18.h),

                  // Divider
                  _buildDivider(),

                  SizedBox(height: 24.h),

                  // Don't have account
                  const DontHaveAccountText(),

                  SizedBox(height: 32.h),

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
              width: 100.w,
              height: 100.w,
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
                padding: EdgeInsets.all(20.w),
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

        SizedBox(height: 20.h),

        // App Name
        Text(
          'مرحباً بك مرة أخرى',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryText,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.3),

        SizedBox(height: 8.h),

        Text(
          "سجل دخولك وابدء رحلتك مع الأحاديث والعلوم الإسلامية",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: ColorsManager.secondaryText,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        AppTextFormField(
          backgroundColor: ColorsManager.lightGray,
          suffixIcon: Icon(Icons.email, color: ColorsManager.primaryGreen),
          controller: _emailController,
          hintText: 'البريد الإلكتروني',
          hintStyle: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ).animate().fadeIn(delay: 500.ms, duration: 300.ms).slideX(begin: -0.3),

        SizedBox(height: 20.h),

        // Password Field
        AppTextFormField(
          backgroundColor: ColorsManager.lightGray,
          hintStyle: TextStyle(color: Colors.black),

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
        ).animate().fadeIn(delay: 600.ms, duration: 300.ms).slideX(begin: -0.3),
      ],
    );
  }

  Widget _buildRememberMeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me
        Row(
          children: [
            Checkbox(
              side: BorderSide(color: ColorsManager.primaryGreen),
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: ColorsManager.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Text(
              'تذكرني',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorsManager.primaryText,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms, duration: 300.ms),

        // Forgot Password
        TextButton(
          onPressed: () {
            // TODO: Navigate to forgot password screen
          },
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryGreen,
              decoration: TextDecoration.underline,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 300.ms),
      ],
    );
  }

  Widget _buildLoginButton() {
    return AppTextButton(
          buttonText: 'تسجيل الدخول',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Implement login logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('جاري تسجيل الدخول...'),
                  backgroundColor: ColorsManager.primaryGreen,
                ),
              );
            }
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
}
