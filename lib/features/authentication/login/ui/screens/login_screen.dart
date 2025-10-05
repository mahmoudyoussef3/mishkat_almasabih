import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theming/colors.dart';
import '../widgets/don`t_have_account_text.dart';
import '../widgets/email_and_password.dart';
import '../widgets/login_bloc_listener.dart';
import '../widgets/login_screen_header.dart';
import '../widgets/login_with_google.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
             
          backgroundColor: ColorsManager.white,
          body: SafeArea(
        top: false,
        
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top spacing
                  SizedBox(height: 60.h),
        
                  // App Logo and Title
                  LoginScreenHeader(),
        
                  SizedBox(height: 60.h),
        
                  // Login Form
                  EmailAndPassword(),
        
                  SizedBox(height: 24.h),
        
         
        
                  // Login Button
                  LoginBlocListener(),
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
