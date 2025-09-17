import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.mediumGray),
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
          const Icon(FontAwesomeIcons.sun, color: ColorsManager.primaryGreen),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الوضع الليلي",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text("معطل",
                    style: TextStyle(
                        fontSize: 14.sp, color: ColorsManager.secondaryText)),
              ],
            ),
          ),
          Switch(
            value: true,
            onChanged: (value) {},
            activeThumbColor: ColorsManager.primaryPurple,
          ),
        ],
      ),
    );
  }
}
