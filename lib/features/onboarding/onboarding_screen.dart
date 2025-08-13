import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      title: 'مرحباً بك في مكتبة الحديث الشريف',
      subtitle: 'اكتشف كنوز السنة النبوية في تطبيق واحد شامل',
      description:
          'تطبيق مشكاة المصابيح يجمع لك أهم كتب الحديث مع واجهة جميلة وسهلة الاستخدام',
      image: 'assets/images/onboarding_1.png',
      icon: Icons.library_books,
      color: ColorsManager.primaryPurple,
    ),
    OnboardingPage(
      title: '17 كتاب من أهم كتب الحديث',
      subtitle: 'من صحيح البخاري إلى سنن الترمذي وأكثر',
      description:
          'احصل على محتوى شامل يشمل الأحاديث الصحيحة والضعيفة مع درجات الصحة',
      image: 'assets/images/onboarding_2.png',
      icon: Icons.book,
      color: ColorsManager.secondaryPurple,
    ),
    OnboardingPage(
      title: 'البحث المتقدم والتصفح السهل',
      subtitle: 'ابحث في الأحاديث والأبواب والرواة بسهولة',
      description:
          'استخدم أدوات البحث المتقدمة للعثور على أي حديث تريده في ثوانٍ معدودة',
      image: 'assets/images/onboarding_3.png',
      icon: Icons.search,
      color: ColorsManager.primaryGold,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    context.pushNamed(Routes.mainNavigationScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: TextButton(
                  onPressed: _getStarted,
                  child: Text(
                    'تخطي',
                    style: TextStyles.bodyMedium.copyWith(
                      color: ColorsManager.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingPages[index]);
                },
              ),
            ),

            // Bottom section with indicators and buttons
            Container(
              padding: EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),

                  SizedBox(height: Spacing.xl),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button (only show if not first page)
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            'السابق',
                            style: TextStyles.bodyMedium.copyWith(
                              color: ColorsManager.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 80),

                      // Next/Get Started button
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _onboardingPages[_currentPage].color,
                          foregroundColor: ColorsManager.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.xl,
                            vertical: Spacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          _currentPage == _onboardingPages.length - 1
                              ? 'ابدأ الآن'
                              : 'التالي',
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorsManager.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.all(Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: page.color.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        page.color.withOpacity(0.1),
                        page.color.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/islamic_pattern.png',
                                ),
                                repeat: ImageRepeat.repeat,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Main content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon container
                            Container(
                              padding: EdgeInsets.all(Spacing.xl),
                              decoration: BoxDecoration(
                                color: page.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: page.color.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                page.icon,
                                size: 60,
                                color: page.color,
                              ),
                            ),

                            SizedBox(height: Spacing.lg),

                            // Placeholder for image (you can replace with actual images)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: page.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: page.color.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                page.icon,
                                size: 48,
                                color: page.color.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: Spacing.xl),

          // Text content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  page.title,
                  style: TextStyles.headlineMedium.copyWith(
                    color: ColorsManager.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                SizedBox(height: Spacing.md),

                Text(
                  page.subtitle,
                  style: TextStyles.titleMedium.copyWith(
                    color: page.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                SizedBox(height: Spacing.md),

                Text(
                  page.description,
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorsManager.secondaryText,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isActive = index == _currentPage;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Spacing.xs),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isActive
                ? _onboardingPages[_currentPage].color
                : ColorsManager.mediumGray,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.icon,
    required this.color,
  });
}
