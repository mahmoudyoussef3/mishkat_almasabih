import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/error_dialg.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/profile_screen_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool dailyHadithNotification = true;
  bool azkarNotification = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _loadNotificationSettings();
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

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyHadithNotification =
          prefs.getBool('daily_hadith_notification') ?? true;
      azkarNotification = prefs.getBool('azkar_notification') ?? false;
    });
  }

  Future<void> _saveNotificationSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (token != null) {
          await context.read<ProfileCubit>().getUserProfile();
        }
      },
      color: ColorsManager.primaryPurple,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.primaryBackground,
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (token == null) _buildLoginPrompt(),

                  if (token != null) _buildProfileHeaderByState(state),
                  _buildNotificationSection(),

                  if (token != null) _buildStatisticsSection(),

                  SliverPadding(padding: EdgeInsets.only(bottom: 60.h)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 🔹 Profile Header logic
  Widget _buildProfileHeaderByState(ProfileState state) {
    if (state is ProfileLoading) {
      return const ProfileShimmerScreen();
    } else if (state is ProfileError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ErrorState(error: state.message),
        ),
      );
    } else if (state is ProfileLoaded) {
      return ProfileHeader(user: state.user);
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  // 🔹 Login Prompt
  Widget _buildLoginPrompt() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.userLock,
                  size: 80.sp,
                  color: ColorsManager.primaryPurple,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "مرحباً بك!",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                "يجب تسجيل الدخول لعرض بيانات\nالملف الشخصي والاستمتاع بجميع المزايا",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsManager.darkGray,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryGreen,
                    elevation: 2,
                    shadowColor: ColorsManager.primaryGreen.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.loginScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.rightToBracket,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // 🔹 Statistics Section
  Widget _buildStatisticsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.chartLine,
                  size: 20.sp,
                  color: ColorsManager.primaryPurple,
                ),
                SizedBox(width: 8.w),
                Text(
                  "الإحصائيات",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.3,
              children: [
                _StatCard(
                  title: "الإشارات المرجعية",
                  value: "128",
                  icon: FontAwesomeIcons.bookmark,
                  color: ColorsManager.primaryGreen,
                ),
                _StatCard(
                  title: "المجموعات",
                  value: "6",
                  icon: FontAwesomeIcons.folder,
                  color: ColorsManager.primaryPurple,
                ),
                _StatCard(
                  title: "البطاقات",
                  value: "0",
                  icon: FontAwesomeIcons.addressCard,
                  color: ColorsManager.hadithWeak,
                ),
                _StatCard(
                  title: "عمليات البحث",
                  value: "34",
                  icon: FontAwesomeIcons.magnifyingGlass,
                  color: Color(0xFF00BCD4),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _LastActivityCard(date: "03-11-2025"),
          ],
        ),
      ),
    );
  }

  // 🔹 Notification Settings Section
  Widget _buildNotificationSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  size: 20.sp,
                  color: ColorsManager.primaryPurple,
                ),
                SizedBox(width: 8.w),
                Text(
                  "الإشعارات",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _NotificationToggleCard(
              title: "الحديث اليومي",
              subtitle: "استقبل إشعار بحديث جديد كل يوم",
              icon: FontAwesomeIcons.bookQuran,
              value: dailyHadithNotification,
              onChanged: (value) {
                setState(() {
                  dailyHadithNotification = value;
                });
                _saveNotificationSetting('daily_hadith_notification', value);
              },
            ),
            SizedBox(height: 12.h),
            _NotificationToggleCard(
              title: "أذكار الصباح والمساء",
              subtitle: "تذكير بأذكار الصباح والمساء يومياً",
              icon: FontAwesomeIcons.moon,
              value: azkarNotification,
              onChanged: (value) {
                setState(() {
                  azkarNotification = value;
                });
                _saveNotificationSetting('azkar_notification', value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 22.sp, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Last Activity Card
class _LastActivityCard extends StatelessWidget {
  final String date;

  const _LastActivityCard({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsManager.error.withOpacity(0.8), ColorsManager.error],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.error.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              FontAwesomeIcons.clock,
              size: 24.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "آخر نشاط",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Notification Toggle Card
class _NotificationToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              value
                  ? ColorsManager.primaryPurple.withOpacity(0.3)
                  : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                value
                    ? ColorsManager.primaryPurple.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color:
                    value
                        ? ColorsManager.primaryPurple.withOpacity(0.15)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color:
                    value ? ColorsManager.primaryPurple : Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: ColorsManager.primaryPurple,
                activeTrackColor: ColorsManager.primaryPurple.withOpacity(0.5),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
