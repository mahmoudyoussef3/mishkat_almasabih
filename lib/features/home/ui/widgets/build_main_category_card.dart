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
        height: 140.h,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primaryPurple.withOpacity(0.25),
              blurRadius: 24.r,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Islamic pattern background
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    'assets/images/islamic_pattern.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Decorative corner element
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: ColorsManager.white.withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.r),
                    bottomLeft: Radius.circular(24.r),
                  ),
                ),
                child: Icon(
                  Icons.star,
                  color: ColorsManager.white.withOpacity(0.8),
                  size: 20.sp,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.symmetric(vertical:  Spacing.md2,horizontal: Spacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Title with enhanced styling
                        Text(
                          title,
                          style: TextStyles.headlineSmall.copyWith(
                            color: ColorsManager.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Spacing.xs),

                        // Subtitle with enhanced styling
                  /*      Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: ColorsManager.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            subtitle,
                            style: TextStyles.bodyMedium.copyWith(
                              color: ColorsManager.white.withOpacity(0.95),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        */
                        SizedBox(height: Spacing.xs),

                        // Description with enhanced styling
                        Flexible(
                          child: Text(
                            description,
                            style: TextStyles.bodySmall.copyWith(
                              fontSize: 18.sp,
                              color: ColorsManager.white.withOpacity(0.85),
                            //  height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Book count with enhanced styling
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: ColorsManager.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$bookCount',
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorsManager.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'كتاب',
                          style: TextStyles.bodySmall.copyWith(
                            color: ColorsManager.white.withOpacity(0.9),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Icon overlay
            Positioned(
              bottom: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorsManager.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: ColorsManager.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: ColorsManager.white, size: 24.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
