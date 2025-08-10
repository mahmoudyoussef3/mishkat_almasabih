import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Daily Hadith',
        'icon': Icons.lightbulb_outline,
        'color': ColorsManager.primaryGold,
        'onTap': () {
          // TODO: Navigate to daily hadith
        },
      },
      {
        'title': 'Bookmarks',
        'icon': Icons.bookmark_outline,
        'color': ColorsManager.primaryGreen,
        'onTap': () {
          // TODO: Navigate to bookmarks
        },
      },
      {
        'title': 'Settings',
        'icon': Icons.settings_outlined,
        'color': ColorsManager.primaryNavy,
        'onTap': () {
          // TODO: Navigate to settings
        },
      },
      {
        'title': 'Help',
        'icon': Icons.help_outline,
        'color': ColorsManager.accentOrange,
        'onTap': () {
          // TODO: Navigate to help
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyles.headlineMedium.copyWith(
            color: ColorsManager.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Spacing.md),
        Row(
          children: actions.map((action) {
            return Expanded(
              child: GestureDetector(
                onTap: action['onTap'] as VoidCallback,
                child: Container(
                  margin: EdgeInsets.only(
                    right: actions.indexOf(action) < actions.length - 1 ? Spacing.sm : 0,
                  ),
                  padding: EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Spacing.sm),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: Spacing.sm),
                      Text(
                        action['title'] as String,
                        style: TextStyles.labelMedium.copyWith(
                          color: ColorsManager.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
