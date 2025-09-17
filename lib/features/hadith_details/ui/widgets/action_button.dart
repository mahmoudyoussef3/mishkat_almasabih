import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionButton({required this.icon, required this.label, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
   //   borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsManager.primaryPurple.withOpacity(0.1),
            child: Icon(icon, color: ColorsManager.primaryPurple),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: ColorsManager.darkGray),
          ),
        ],
      ),
    );
  }
}