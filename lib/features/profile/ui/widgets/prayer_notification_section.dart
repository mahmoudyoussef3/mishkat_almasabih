import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/profile_styles.dart';

import 'notification_toggle_card.dart';

class PrayerNotificationSection extends StatelessWidget {
  final bool enabled;
  final bool isBusy;
  final ValueChanged<bool> onChanged;
  final VoidCallback onRefresh;

  const PrayerNotificationSection({
    super.key,
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            SizedBox(height: 16.h),
            NotificationToggleCard(
              title: 'إشعارات مواقيت الصلاة',
              subtitle: 'تنبيهات دقيقة للفجر والظهر والعصر والمغرب والعشاء',
              icon: FontAwesomeIcons.bell,
              value: enabled,
              onChanged: isBusy ? (_) {} : onChanged,
            ),
            SizedBox(height: 10.h),
            _buildRefreshButton(),
            SizedBox(height: 8.h),
            Text(
              'يتم استخدام موقعك المحفوظ أو موقع الجهاز الحالي، مع إعادة المزامنة عند فتح التطبيق.',
              style: ProfileTextStyles.notificationCardSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.clockRotateLeft,
          size: 20.sp,
          color: ColorsManager.primaryPurple,
        ),
        SizedBox(width: 8.w),
        Text('مواقيت الصلاة', style: ProfileTextStyles.sectionHeaderText),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isBusy ? null : onRefresh,
        icon:
            isBusy
                ? SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
                : const Icon(Icons.sync),
        label: Text(
          'مزامنة الإشعارات الآن',
          style: TextStyle(
            color: isBusy ? Colors.grey : ColorsManager.primaryPurple,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: ColorsManager.primaryPurple.withOpacity(0.35),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
      ),
    );
  }
}
