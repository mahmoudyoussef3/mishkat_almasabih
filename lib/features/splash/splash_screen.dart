import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import '../../core/theming/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _initializeControllers() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.mainNavigationScreen);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryGreen,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.primaryGreen,
              ColorsManager.primaryGreen.withOpacity(0.9),
              ColorsManager.primaryGreen.withOpacity(0.8),
            ],
            stops: const [0.0, 0.9, 1.5],
          ),
        ),
        child: SafeArea(

          top: false,

          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogoSection(),

                    SizedBox(height: 22.h),

                    _buildAppNameSection(),

                    SizedBox(height: 60.h),

                    _buildLoadingIndicator(),
                  ],
                ),
              ),

              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsManager.white,
            boxShadow: [
              BoxShadow(
                color: ColorsManager.black.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        )
        .animate(controller: _scaleController)
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          curve: Curves.elasticOut,
        )
        .then()
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 2000.ms,
          color: ColorsManager.white.withOpacity(0.3),
        );
  }

  Widget _buildAppNameSection() {
    return Column(
      children: [
        // Arabic app name
        Text(
              'مكتبة مشكاة الإسلامية ',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: ColorsManager.black.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            )
            .animate(controller: _fadeController)
            .fadeIn(duration: 1000.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),

        SizedBox(height: 12.h),

        Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'اكتشف آلاف الأحاديث الموثوقة مع ميزات بحث ذكية وحفظ المفضلة. ابدأ رحلتك في التعلم الإسلامي الآن',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.white.withOpacity(0.9),
                  height: 1.6,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.center,
              ),
            )
            .animate(controller: _fadeController)
            .fadeIn(delay: 600.ms, duration: 1000.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.white,
                    ),
                  )
                  .animate(controller: _slideController)
                  .fadeIn(delay: (index * 100).ms, duration: 600.ms)
                  .scale(begin: const Offset(0.0, 0.0))
                  .then()
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.3, 1.3),
                    duration: 800.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.3, 1.3),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.easeInOut,
                  ),
            );
          }),
        ),
      ],
    );
  }
}
