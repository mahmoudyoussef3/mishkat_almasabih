import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/error_dialg.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/profile_screen_shimmer.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/section_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routing/routes.dart';
import '../logic/cubit/profile_cubit.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    setState(() {
      token = storedToken;
    });
    if (storedToken != null) {
      context.read<ProfileCubit>().getUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (token != null) {
          await context.read<ProfileCubit>().getUserProfile();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  token == null ?   SliverPadding(
                    padding: EdgeInsets.only(top: 10.h),
                    sliver:SliverToBoxAdapter(
                      child:
                         _buildLoginPrompt(context)
                         
                    )
                  ):_buildProfileHeaderByState(state), 
                

                  /// باقي الشاشة ثابت
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: "من نحن"),
                          SizedBox(height: 12.h),
                          _buildSection(
                            icon: Icons.info_outline,
                            text:
                                "مشروع متخصص في نشر العلوم الإسلامية والحديثية بأسلوب معاصر وسلس. نهدف إلى تقريب تراث الإسلام وعلومه للمسلمين والمهتمين بطريقة سهلة وموثوقة.",
                          ),
                          SizedBox(height: 12.h),

                          const SectionTitle(title: "رؤيتنا"),
                          SizedBox(height: 12.h),
                          _buildSection(
                            icon: Icons.visibility_outlined,
                            text:
                                "أن نكون المرجع الأول والأكثر موثوقية في تقديم العلوم الحديثية بشكل سهل ومفهوم للجميع.",
                          ),
                          SizedBox(height: 12.h),

                          const SectionTitle(title: "رسالتنا"),
                          SizedBox(height: 12.h),
                          _buildSection(
                            icon: Icons.lightbulb_outline,
                            text:
                                "توفير مصادر علمية دقيقة للأحاديث النبوية وشروحها، مع الحرص على الوضوح والدقة العلمية.",
                          ),
                          SizedBox(height: 12.h),

                          const SectionTitle(title: "قيمنا"),
                          SizedBox(height: 12.h),
                          _buildSection(
                            icon: Icons.favorite_outline,
                            text:
                                "الأمانة العلمية، الموثوقية، الابتكار، والسهولة في تقديم المعلومة.",
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Footer
                  _buildFooter(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

/// 🔹 Profile Header logic - FIXED VERSION
Widget _buildProfileHeaderByState(ProfileState state) {
  if (state is ProfileLoading) {
    return const ProfileShimmerScreen();
  } else if (state is ProfileError) {
    return SliverToBoxAdapter(
      child: Center(child: ErrorState(error: state.message)),
    );
  } else if (state is ProfileLoaded) {
    return ProfileHeader(user: state.user); 
  }
  return const SliverToBoxAdapter(
    child: SizedBox.shrink(),
  );
}

Widget _buildLoginPrompt(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.8, // ✅ قيود ارتفاع
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.userLock,
              size: 70.sp,
              color: ColorsManager.primaryPurple,
            ),
            SizedBox(height: 12.h),
            Text(
              "يجب تسجيل الدخول لعرض بيانات الملف الشخصي",
              style: TextStyle(
                fontSize: 15.sp,
                color: ColorsManager.darkGray,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryGreen,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.loginScreen);
              },
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  /// باقي الأقسام ثابتة
  Widget _buildSection({
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
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer ثابت كما هو
  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.primaryPurple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
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
                padding: EdgeInsets.all(18.w),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'منصة رقمية متكاملة لدراسة الأحاديث النبوية الشريفة مع تحليل ذكي وفوائد عملية',
              style: TextStyle(color: ColorsManager.secondaryBackground),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Divider(color: ColorsManager.gray, endIndent: 50.w, indent: 50.w),
            SizedBox(height: 8.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 18.w,
              children: [
                _socialIcon(FontAwesomeIcons.whatsapp,
                    'https://whatsapp.com/channel/0029VazdI4N84OmAWA8h4S2F'),
                _socialIcon(FontAwesomeIcons.instagram,
                    'https://www.instagram.com/mishkahcom1'),
                _socialIcon(
                    FontAwesomeIcons.twitter, 'https://x.com/mishkahcom1'),
                _socialIcon(
                    FontAwesomeIcons.facebook, 'https://facebook.com/mishkahcom1'),
                _socialIcon(
                    FontAwesomeIcons.envelope, 'mailto:Meshkah@hadith-shareef.com'),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              "© جميع الحقوق محفوظة لتطبيق مشكاة الأحاديث 2025",
              style: TextStyle(fontSize: 12.sp, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 26.r,
        child: Icon(icon, color: ColorsManager.secondaryBackground, size: 22.sp),
      ),
    );
  }
}
