import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/helpers/spacing.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'حديث اليوم',
        'subtitle': 'Daily Hadith',
        'icon': Icons.lightbulb_outline,
        'color': ColorsManager.primaryGold,
        'onTap': () {},
      },
      {
        'title': 'المحفوظات',
        'subtitle': 'Bookmarks',
        'icon': Icons.bookmark_outline,
        'color': ColorsManager.primaryPurple,
        'onTap': () {},
      },
      {
        'title': 'البحث المتقدم',
        'subtitle': 'Advanced Search',
        'icon': Icons.search,
        'color': ColorsManager.secondaryPurple,
        'onTap': () {},
      },
      {
        'title': 'الإعدادات',
        'subtitle': 'Settings',
        'icon': Icons.settings_outlined,
        'color': ColorsManager.lightPurple,
        'onTap': () {},
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on, color: ColorsManager.primaryPurple, size: 24),
            SizedBox(width: Spacing.sm),
            Text(
              'إجراءات سريعة',
              style: TextStyles.headlineMedium.copyWith(
                color: ColorsManager.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: Spacing.md),
        Row(
          children:
              actions.map((action) {
                return Expanded(
                  child: GestureDetector(
                    onTap: action['onTap'] as VoidCallback,
                    child: Container(
                      margin: EdgeInsets.only(
                        right:
                            actions.indexOf(action) < actions.length - 1
                                ? Spacing.sm
                                : 0,
                      ),
                      padding: EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: ColorsManager.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.primaryPurple.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(Spacing.sm),
                            decoration: BoxDecoration(
                              color: (action['color'] as Color).withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
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
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Spacing.xs),
                          Text(
                            action['subtitle'] as String,
                            style: TextStyles.bodySmall.copyWith(
                              color: ColorsManager.secondaryText,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
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
