import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theming/colors.dart';
import 'build_nav_item.dart';

class BuildBottomNavBarContainer extends StatelessWidget {
  const BuildBottomNavBarContainer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 139, 90, 231),
            ColorsManager.secondaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: ColorsManager.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BuildNavItem(
                        icon: Icons.home,
            index: 0,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
      
          
          BuildNavItem(
            icon: Icons.search
          ,
            index: 1,
            currentIndex: currentIndex,
            onTap: onTap
          ),
          
          BuildNavItem(
            icon: Icons.bookmark,
            index: 2,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
               BuildNavItem(
            icon: Icons.person,
            index: 3,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
