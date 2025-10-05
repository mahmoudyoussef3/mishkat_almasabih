import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BuildHeaderAppBar extends StatelessWidget {
  BuildHeaderAppBar({
    super.key,
    this.description,
    required this.title,
    this.home = false,
    this.pinned = false,
    this.actions,
    this.bottomNav = false,
  });
  final String title;
  final String? description;
  final bool home;
  final bool pinned;
  bool bottomNav;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: actions,
      leading: IconButton(
        onPressed: 
            home
                ? ()  => Scaffold.of(context).openDrawer()
                : () => context.pop(),
        icon: Icon(
          home ? Icons.list : Icons.arrow_back,
          color: Colors.white,
        ),
      ),

      expandedHeight: 100.h,
      floating: true,
      pinned: pinned,
      backgroundColor: ColorsManager.primaryPurple,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyles.displaySmall.copyWith(
                color: ColorsManager.white,
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
              ),
            ),
            Flexible(
              child: Text(
                description ?? '',
                style: TextStyles.bodyMedium.copyWith(
                  color: ColorsManager.white.withOpacity(0.9),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(),
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
