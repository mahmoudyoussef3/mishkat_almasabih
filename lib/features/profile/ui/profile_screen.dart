import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  // Mock user data - replace with actual data from your API
  final Map<String, dynamic> userData = {
    "username": "john_doe",
    "email": "john@example.com",
    "avatar_url": null,
    "google_id": null,
    "role": "user",
    "weekly_achievement_count": 0,
    "created_at": "2024-01-01T12:00:00Z",
  };

  @override
  void initState() {
    super.initState();

    // Initialize animations
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              // Islamic-themed App Bar
              SliverAppBar(
                expandedHeight: 200.h,
                floating: false,
                pinned: true,
                backgroundColor: ColorsManager.primaryPurple,
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
                    child: Stack(
                      children: [
                        // Islamic pattern overlay
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                              'assets/images/islamic_pattern.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Profile content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Profile Avatar with animation
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: 0.7 + (0.3 * value),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorsManager.primaryGold,
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorsManager.primaryGold
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 50.r,
                                        backgroundColor:
                                            ColorsManager.secondaryBackground,
                                        backgroundImage:
                                            userData["avatar_url"] != null
                                                ? NetworkImage(
                                                  userData["avatar_url"],
                                                )
                                                : null,
                                        child:
                                            userData["avatar_url"] == null
                                                ? Icon(
                                                  Icons.person,
                                                  size: 50.r,
                                                  color:
                                                      ColorsManager
                                                          .primaryPurple,
                                                )
                                                : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),
                              // Username with animation
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 600),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Text(
                                        userData["username"] ?? "المستخدم",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsManager.white,
                                          fontFamily: 'YaModernPro',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 8.h),
                              // Email with animation
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 15 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Text(
                                        userData["email"] ?? "user@example.com",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ColorsManager.white
                                              .withOpacity(0.8),
                                          fontFamily: 'Amiri',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  // Edit Profile Button with animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EditProfileScreen(userData: userData),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: ColorsManager.white,
                            size: 24.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Achievement Card with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildAchievementCard(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Settings Section
                      _buildSectionTitle("الإعدادات"),
                      SizedBox(height: 16.h),

                      // Dark Mode Toggle with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 700),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildDarkModeToggle(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Support Section
                      _buildSectionTitle("تواصل معنا"),
                      SizedBox(height: 16.h),

                      // Social Media Icons with animations
                      _buildSocialMediaIcons(),
                      SizedBox(height: 16.h),

                      // Privacy Policy with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 900),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildProfileOption(
                                icon: FontAwesomeIcons.shield,
                                title: "سياسة الخصوصية",
                                subtitle: "اقرأ سياسة الخصوصية",
                                onTap:
                                    () => _launchUrl(
                                      'https://hadith-shareef.com/privacy-policy',
                                    ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Logout Button with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildLogoutButton(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryGold,
            ColorsManager.primaryGold.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryGold.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.1,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.trophy,
                    color: ColorsManager.white,
                    size: 24.sp,
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
                  "الإنجازات الأسبوعية",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.white,
                    fontFamily: 'YaModernPro',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${userData["weekly_achievement_count"]} إنجاز",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.white.withOpacity(0.9),
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildDarkModeToggle() {
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
                    color: ColorsManager.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                    color: ColorsManager.primaryPurple,
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
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              // TODO: Implement dark mode logic
            },
            activeColor: ColorsManager.primaryPurple,
            activeTrackColor: ColorsManager.primaryPurple.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcons() {
    final socialLinks = [
      {
        'icon': FontAwesomeIcons.whatsapp,
        'color': const Color(0xFF25D366),
        'url': 'https://whatsapp.com/channel/0029VazdI4N84OmAWA8h4S2F',
        'title': 'واتساب',
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'color': const Color(0xFFE4405F),
        'url': 'https://www.instagram.com/mishkahcom1',
        'title': 'انستجرام',
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'color': const Color(0xFF1DA1F2),
        'url': 'https://x.com/mishkahcom1',
        'title': 'تويتر',
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'color': const Color(0xFF1877F2),
        'url': 'https://www.facebook.com/mishkahcom1',
        'title': 'فيسبوك',
      },
      {
        'icon': FontAwesomeIcons.envelope,
        'color': ColorsManager.primaryPurple,
        'url': 'mailto:Meshkah@hadith-shareef.com',
        'title': 'البريد الإلكتروني',
      },
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorsManager.mediumGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "تابعنا على وسائل التواصل",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryText,
              fontFamily: 'YaModernPro',
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                socialLinks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final link = entry.value;

                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.5 + (0.5 * value),
                        child: GestureDetector(
                          onTap: () => _launchUrl(link['url'] as String),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: (link['color'] as Color).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (link['color'] as Color).withOpacity(
                                  0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              link['icon'] as IconData,
                              color: link['color'] as Color,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
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
            color: ColorsManager.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: ColorsManager.primaryPurple, size: 20.sp),
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

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsManager.error, ColorsManager.error.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.error.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            _showLogoutDialog();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: ColorsManager.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.white,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              children: [
                Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: ColorsManager.error,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryText,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ],
            ),
            content: Text(
              "هل أنت متأكد من أنك تريد تسجيل الخروج؟",
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.secondaryText,
                fontFamily: 'Amiri',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "إلغاء",
                  style: TextStyle(
                    color: ColorsManager.secondaryText,
                    fontSize: 16.sp,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement logout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "تأكيد",
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: 16.sp,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يمكن فتح الرابط: $url'),
            backgroundColor: ColorsManager.error,
          ),
        );
      }
    }
  }
}
