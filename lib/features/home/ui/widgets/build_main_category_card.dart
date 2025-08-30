import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

class BuildMainCategoryCard extends StatelessWidget {
  const BuildMainCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.bookCount,
    required this.gradient,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final int bookCount;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primaryPurple.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/islamic_pattern.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.headlineSmall.copyWith(
                            color: ColorsManager.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Spacing.xs),
                        Text(
                          subtitle,
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorsManager.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: Spacing.xs),
                        Text(
                          description,
                          style: TextStyles.bodySmall.copyWith(
                            color: ColorsManager.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$bookCount',
                      style: TextStyles.titleMedium.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
