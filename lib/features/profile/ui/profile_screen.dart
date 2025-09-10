import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/dark_mode_toggle.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/section_title.dart';

import '../logic/cubit/profile_cubit.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getUserProfile();

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProfileCubit>().getUserProfile();
      },
      child: SafeArea(
        child: DoubleTapToExitApp(
          myScaffoldScreen: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorsManager.primaryBackground,
              body: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.primaryPurple,
                      ),
                    );
                  } else if (state is ProfileError) {
                    return Center(
                      child: Text(
                        "حدث خطأ أثناء تحميل البيانات",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsManager.error,
                        ),
                      ),
                    );
                  } else if (state is ProfileLoaded) {
                    final user = state.user;
            
                    return CustomScrollView(
                      slivers: [
                        /// User Info Header
                        ProfileHeader(user: user),
            
                        /// Content Sections
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: "الإعدادات"),
                                SizedBox(height: 16.h),
                                const DarkModeToggle(),
                                SizedBox(height: 16.h),
                                const SectionTitle(title: "من نحن"),
                                SizedBox(height: 16.h),
                                _buildSection(
                                  title: "",
                                  icon: Icons.info_outline,
                                  text:
                                      "مشروع متخصص في نشر العلوم الإسلامية والحديثية بأسلوب معاصر وسلس. نهدف إلى تقريب تراث الإسلام وعلومه للمسلمين والمهتمين بطريقة سهلة وموثوقة",
                                ),
                                SizedBox(height: 16.h),
            
                                const SectionTitle(title: "رؤيتنا"),
                                SizedBox(height: 16.h),
                                _buildSection(
                                  title: "",
                                  icon: Icons.visibility_outlined,
                                  text:
                                      "أن نكون المرجع الأول والأكثر موثوقية في تقديم العلوم الحديثية بشكل سهل ومفهوم للجميع.",
                                ),
                                SizedBox(height: 16.h),
            
                                const SectionTitle(title: "رسالتنا"),
                                SizedBox(height: 16.h),
                                _buildSection(
                                  title: "",
                                  icon: Icons.lightbulb_outline,
                                  text:
                                      "توفير مصادر علمية دقيقة للأحاديث النبوية وشروحها، مع الحرص على الوضوح والدقة العلمية.",
                                ),
                                SizedBox(height: 16.h),
            
                                const SectionTitle(title: "قيمنا"),
                                SizedBox(height: 16.h),
                                _buildSection(
                                  title: "",
                                  icon: Icons.favorite_outline,
                                  text:
                                      "الأمانة العلمية، الموثوقية، الابتكار، والسهولة في تقديم المعلومة.",
                                ),
                              ],
                            ),
                          ),
                        ),
            
                        /// Footer
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 28.h,
                              horizontal: 20.w,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorsManager.primaryPurple,
                                  Colors.deepPurple,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 46.r,
                                  backgroundImage: const AssetImage(
                                    "assets/images/app_logo.png",
                                  ),
                                ),
                                SizedBox(height: 5.h),
            
                                Text(
                                  style: TextStyle(
                                    color: ColorsManager.secondaryBackground,
                                  ),
                                  'منصة رقمية متكاملة لدراسة الأحاديث النبوية الشريفة مع تحليل ذكي وفوائد عملية',
                                ),
                                SizedBox(height: 5.h),
            
                                Divider(
                                  color: ColorsManager.gray,
                                  endIndent: 50.w,
                                  indent: 50.w,
                                ),
                                SizedBox(height: 5.h),
            
                                /// Social Media Icons
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 18.w,
                                  children: [
                                    _socialIcon(FontAwesomeIcons.whatsapp),
                                    _socialIcon(FontAwesomeIcons.instagram),
                                    _socialIcon(FontAwesomeIcons.twitter),
                                    _socialIcon(FontAwesomeIcons.facebook),
                                    _socialIcon(FontAwesomeIcons.envelope),
                                  ],
                                ),
                                SizedBox(height: 10.h),
            
                                /// Links
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "شروط الاستخدام",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "سياسة الخصوصية",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
            
                                SizedBox(height: 10.h),
                                Text(
                                  "© جميع الحقوق محفوظة لتطبيق مشكاة المصابيح 2025",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Builder
  Widget _buildSection({
    required String title,
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.mediumGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorsManager.primaryGreen),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 26.r,
      child: Icon(icon, color: ColorsManager.secondaryBackground, size: 22.sp),
    );
  }
}
