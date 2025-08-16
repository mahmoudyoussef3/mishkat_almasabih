import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

class BuildHeaderAppBar extends StatelessWidget {
  const BuildHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100.h,
      floating: false,
      pinned: true,
      backgroundColor: ColorsManager.primaryPurple,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'مشكاة المصابيح',
              style: TextStyles.displaySmall.copyWith(
                color: ColorsManager.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            Text(
              'مكتبة مشكاة الإسلامية',
              style: TextStyles.bodyMedium.copyWith(
                color: ColorsManager.white.withOpacity(0.9),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorsManager.primaryPurple, ColorsManager.primaryGreen],
            ),
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
                        repeat: ImageRepeat.repeat,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
