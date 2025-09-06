import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/app_text_button.dart';
import 'package:mishkat_almasabih/features/ahadith/ui/widgets/separator.dart';
import 'package:mishkat_almasabih/features/profile/logic/cubit/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // جلب بيانات المستخدم
    context.read<ProfileCubit>().getUserProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🔹 دالة فتح الروابط - متوافقة مع الإصدار القديم

Future<void> _launchUrl(String url) async {
  Uri uri = Uri.parse(url);

  String? appUrl;

  if (url.contains("whatsapp.com") || url.contains("wa.me")) {
    // WhatsApp
    appUrl = "whatsapp://send?text=Hello"; // مثال لإرسال رسالة
  } else if (url.contains("facebook.com")) {
    // Facebook
    appUrl = "fb://facewebmodal/f?href=$url";
  } else if (url.contains("instagram.com")) {
    // Instagram
    appUrl = "instagram://user?username=${uri.pathSegments.last}";
  } else if (url.contains("twitter.com") || url.contains("x.com")) {
    // Twitter (X)
    appUrl = "twitter://user?screen_name=${uri.pathSegments.last}";
  } else if (url.contains("mailto:") || url.contains("gmail.com")) {
    // Gmail
    appUrl = "mailto:"; // هيفتح البريد
  }

  if (appUrl != null && await canLaunch(appUrl)) {
    await launch(appUrl); // افتح بالتطبيق
  } else {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: false, forceWebView: false); // افتح بالمتصفح
    } else {
      throw 'Could not launch $url';
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocBuilder<ProfileCubit, ProfileState>(
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
                      fontSize: 16,
                      color: ColorsManager.error,
                      fontFamily: 'Amiri',
                    ),
                  ),
                );
              } else if (state is ProfileLoaded) {
                final user = state.user;

                return CustomScrollView(
                  slivers: [
                    /// 🔹 الهيدر
                    SliverAppBar(
                      expandedHeight: 180,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorsManager.primaryPurple,
                                ColorsManager.secondaryPurple,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      (user.avatarUrl?.isNotEmpty ?? false)
                                          ? NetworkImage(user.avatarUrl!)
                                          : null,
                                  child: (user.avatarUrl?.isEmpty ?? true)
                                      ? const Icon(Icons.person,
                                          size: 60,
                                          color: ColorsManager.secondaryBackground)
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  user.username ?? "المستخدم",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsManager.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.email ?? "user@example.com",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ColorsManager.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(userData: {}),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),

                    /// 🔹 باقي الصفحة
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildSectionTitle("الإعدادات"),
                            const SizedBox(height: 16),
                            _buildDarkModeToggle(isDarkMode),
                            const SizedBox(height: 24),
                        
                            _buildProfileOption(
                              icon: FontAwesomeIcons.shieldAlt,
                              title: "سياسة الخصوصية",
                              subtitle: "اقرأ سياسة الخصوصية",
                              onTap: () =>_launchUrl(
                                'https://hadith-shareef.com/privacy-policy',
                              ),
                            ),
                                                        const SizedBox(height: 24),
                                                                                    _buildSectionTitle("تواصل معنا"),
                                                        const SizedBox(height: 24),


                                                        _buildSocialMediaIcons(context),

                                                                                                                const SizedBox(height: 24),
                                                        const SizedBox(height: 24),


                            _buildLogoutButton(context),
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
    );
  }

  /// 🔹 Social Media
  Widget _buildSocialMediaIcons(BuildContext context) {
    final socialLinks = [
      {
        'icon': FontAwesomeIcons.whatsapp,
        'url': 'https://whatsapp.com/channel/0029VazdI4N84OmAWA8h4S2F',
        'color': Colors.green,
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'url': 'https://www.instagram.com/mishkahcom1',
        'color': Colors.red,
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'url': 'https://x.com/mishkahcom1',
        'color': Colors.black,
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'url': 'https://www.facebook.com/mishkahcom1',
        'color': Colors.blue,
      },
      {
        'icon': FontAwesomeIcons.envelope,
        'url': 'mailto:Meshkah@hadith-shareef.com',
        'color': Colors.redAccent,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: socialLinks.map((link) {
        return GestureDetector(
          onTap: () => _launchUrl(link['url'] as String),
          child: Icon(
            link['icon'] as IconData,
            size: 28,
            color: link['color'] as Color,
          ),
        );
      }).toList(),
    );
  }
}



  Future<void> launchUrl(String url,BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("حدث خطأ. حاول مرة أخري"),
        ),
      );
    }
  }

Widget _buildSectionTitle(String title) {
  return Row(
    children: [
      Container(
        width: 4.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: ColorsManager.primaryPurple,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
      SizedBox(width: 12.w),
      Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: ColorsManager.primaryText,
          fontFamily: 'YaModernPro',
        ),
      ),
    ],
  );
}

Widget _buildDarkModeToggle(bool isDarkMode) {
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
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value * (isDarkMode ? 0.5 : 0),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                  color: ColorsManager.primaryGreen,
                  size: 20.sp,
                ),
              ),
            );
          },
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الوضع الليلي",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.primaryText,
                  fontFamily: 'YaModernPro',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                isDarkMode ? "مفعل" : "معطل",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.secondaryText,
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isDarkMode,
          onChanged: (value) {},
          activeColor: ColorsManager.primaryPurple,
          activeTrackColor: ColorsManager.primaryPurple.withOpacity(0.3),
        ),
      ],
    ),
  );
}



Widget _buildProfileOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
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
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: ColorsManager.primaryGreen, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: ColorsManager.primaryText,
          fontFamily: 'YaModernPro',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorsManager.secondaryText,
          fontFamily: 'Amiri',
        ),
      ),
      trailing: Icon(
        Icons.arrow_back_ios,
        size: 16.sp,
        color: ColorsManager.secondaryText,
      ),
      onTap: onTap,
    ),
  );
}

Widget _buildLogoutButton(BuildContext context) {
  return AppTextButton(
    backgroundColor: ColorsManager.primaryGreen,

    buttonText: "تسجيل الخروج",
    textStyle: TextStyle(color: ColorsManager.secondaryBackground),
    onPressed: () async {
      showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                style: TextStyle(fontSize: 16),
              ),
              actionsAlignment: MainAxisAlignment.start,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("token");

                    context.pushReplacementNamed(Routes.loginScreen);
                  },
                  child: const Text(
                    'نعم',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12.w),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorsManager.lightBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: ColorsManager.primaryGreen),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

