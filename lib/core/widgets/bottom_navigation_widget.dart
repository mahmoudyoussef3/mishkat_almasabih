import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';
import '../helpers/spacing.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'color': ColorsManager.primaryGreen,
      },
      {
        'icon': Icons.search_outlined,
        'activeIcon': Icons.search,
        'label': 'Search',
        'color': ColorsManager.primaryGold,
      },
      {
        'icon': Icons.book_outlined,
        'activeIcon': Icons.book,
        'label': 'Library',
        'color': ColorsManager.primaryNavy,
      },
      {
        'icon': Icons.bookmark_outline,
        'activeIcon': Icons.bookmark,
        'label': 'Bookmarks',
        'color': ColorsManager.secondaryGreen,
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
        'color': ColorsManager.accentOrange,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? (item['color'] as Color).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Spacing.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item['activeIcon'] as IconData : item['icon'] as IconData,
                        color: isActive 
                            ? item['color'] as Color
                            : ColorsManager.gray,
                        size: 24,
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        item['label'] as String,
                        style: TextStyles.labelSmall.copyWith(
                          color: isActive 
                              ? item['color'] as Color
                              : ColorsManager.gray,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
