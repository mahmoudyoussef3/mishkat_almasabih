import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class BuildNavItem extends StatelessWidget {
  const BuildNavItem({
    super.key,
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

        decoration:
            isActive
                ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                )
                : BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
        child: Icon(
          icon,
          size: isActive ? 25.r : 20.r,
          color: isActive ? ColorsManager.primaryGreen : Colors.white70,
        ),
      ),
    );
  }
}
