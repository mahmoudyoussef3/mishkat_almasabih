import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/theme_manager.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeManager, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorsManager.getCardBackgroundColor(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorsManager.getBorderColor(context),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.getShadowColor(context),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                color: ColorsManager.primaryPurple,
                size: 20.sp,
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
                        color: ColorsManager.getPrimaryTextColor(context),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _getStatusText(themeMode),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorsManager.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeManager>().toggleTheme();
                },
                activeColor: ColorsManager.primaryPurple,
                activeTrackColor: ColorsManager.primaryPurple.withOpacity(0.3),
                inactiveThumbColor: ColorsManager.gray,
                inactiveTrackColor: ColorsManager.mediumGray,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "مفعل";
      case ThemeMode.dark:
        return "مفعل";
      case ThemeMode.system:
        return "تلقائي";
    }
  }
}
