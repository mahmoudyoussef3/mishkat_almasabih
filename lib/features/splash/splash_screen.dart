import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/styles.dart';
import '../../core/helpers/spacing.dart';
import '../../core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _initializeControllers() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _startAnimations() {
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      _scaleController.forward();
    });
  }

  void _navigateToNextScreen() {
    //  Future.delayed(const Duration(seconds: 4), () {
    //  Navigator.pushReplacementNamed(context, Routes.onBoardingScreen);
    //});
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.primaryGreen.withOpacity(0.1),
              ColorsManager.primaryNavy.withOpacity(0.05),
              ColorsManager.primaryBackground,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top decorative elements
              // _buildTopDecorations(),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and main title
                    _buildLogoSection(),

                    SizedBox(height: Spacing.md),

                    // App description
                    _buildDescriptionSection(),

                    SizedBox(height: Spacing.xxl),

                    // Loading indicator
                    //    _buildLoadingSection(),
                  ],
                ),
              ),

              // Bottom decorative elements
              //  _buildBottomDecorations(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDecorations() {
    return Container(
      height: 120.h,
      child: Stack(
        children: [
          // Top right decorative circle
          Positioned(
            top: 20.h,
            right: -30.w,
            child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ColorsManager.primaryGold.withOpacity(0.3),
                        ColorsManager.primaryGold.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                .animate(controller: _fadeController)
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.5, 0.5)),
          ),

          // Top left decorative pattern
          Positioned(
            top: 40.h,
            left: 20.w,
            child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.secondaryGreen.withOpacity(0.4),
                        ColorsManager.primaryGreen.withOpacity(0.2),
                      ],
                    ),
                  ),
                )
                .animate(controller: _fadeController)
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideX(begin: -0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Main logo container
        Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorsManager.primaryGreen,
                    ColorsManager.secondaryGreen,
                    ColorsManager.primaryNavy,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset('assets/images/app_logo.png'),
            )
            .animate(controller: _logoController)
            .scale(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 1.0))
            .then()
            .shimmer(
              duration: 1000.ms,
              color: ColorsManager.white.withOpacity(0.3),
            ),

        SizedBox(height: Spacing.lg),

        // App name in Arabic
        Text(
              'مشكاة المصابيح',
              style: TextStyles.arabicTitle.copyWith(
                fontSize: 28.sp,
                color: ColorsManager.primaryGreen,
                shadows: [
                  Shadow(
                    color: ColorsManager.primaryGreen.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            )
            .animate(controller: _textController)
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.5),

        SizedBox(height: Spacing.sm),

        // App name in English
        Text(
              'Mishkat Al-Masabih',
              style: TextStyles.displaySmall.copyWith(
                color: ColorsManager.primaryNavy,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            )
            .animate(controller: _textController)
            .fadeIn(delay: 200.ms, duration: 800.ms)
            .slideY(begin: 0.5),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Text(
            'اكتشف آلاف الأحاديث الموثوقة مع ميزات بحث ذكية وحفظ المفضلة. ابدأ رحلتك في التعلم الإسلامي الآن!',
            style: TextStyles.bodyLarge.copyWith(
              color: ColorsManager.secondaryBlue,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          )
          .animate(controller: _textController)
          .fadeIn(delay: 400.ms, duration: 600.ms)
          .slideY(begin: 0.3),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Animated loading dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.primaryGreen,
                    ),
                  )
                  .animate(controller: _scaleController)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                  )
                  .then()
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.2, 1.2),
                    duration: 800.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                  ),
            );
          }),
        ),

        SizedBox(height: Spacing.md),

        // Loading text
        Text(
              'Loading...',
              style: TextStyles.bodyMedium.copyWith(
                color: ColorsManager.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            )
            .animate(controller: _fadeController)
            .fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildBottomDecorations() {
    return Container(
      height: 100.h,
      child: Stack(
        children: [
          // Bottom left decorative circle
          Positioned(
            bottom: 20.h,
            left: -20.w,
            child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ColorsManager.secondaryGreen.withOpacity(0.4),
                        ColorsManager.secondaryGreen.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                .animate(controller: _fadeController)
                .fadeIn(delay: 400.ms, duration: 700.ms)
                .scale(begin: const Offset(0.3, 0.3)),
          ),

          // Bottom right decorative pattern
          Positioned(
            bottom: 30.h,
            right: 30.w,
            child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.w),
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.primaryGold.withOpacity(0.5),
                        ColorsManager.secondaryGold.withOpacity(0.3),
                      ],
                    ),
                  ),
                )
                .animate(controller: _fadeController)
                .fadeIn(delay: 600.ms, duration: 500.ms)
                .slideX(begin: 0.5),
          ),

          // Center bottom decorative element
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                    width: 100.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.h),
                      gradient: LinearGradient(
                        colors: [
                          ColorsManager.primaryGreen.withOpacity(0.3),
                          ColorsManager.primaryGreen.withOpacity(0.1),
                          ColorsManager.primaryGreen.withOpacity(0.3),
                        ],
                      ),
                    ),
                  )
                  .animate(controller: _fadeController)
                  .fadeIn(delay: 800.ms, duration: 600.ms)
                  .scaleX(begin: 0.0),
            ),
          ),
        ],
      ),
    );
  }
}
