import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const HadithTabs({
    required this.selectedTab, required this.onTabSelected, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ["شرح", "الدروس المستفادة", "معاني الكلمات"];
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 8.h,
      horizontal: 8.w
      ),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return GestureDetector(
            onTap: () => onTabSelected(tab),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorsManager.primaryPurple.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? ColorsManager.primaryPurple : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
