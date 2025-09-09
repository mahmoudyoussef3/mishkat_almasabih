import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_theme.dart';
import 'core/theming/theme_manager.dart';

class MishkatAlmasabih extends StatelessWidget {
  final AppRouter appRouter;
  final bool isFirstTime;
  final bool isLoggedIn;
  const MishkatAlmasabih({
    super.key,
    required this.appRouter,
    required this.isFirstTime,
    required this.isLoggedIn,
  });
  String _getStartScreen() {
    if (isFirstTime) {
      return Routes.onBoardingScreen;
    } else if (!isLoggedIn) {
      return Routes.loginScreen;
    } else {
      return Routes.splashScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("isFirstTime is $isFirstTime");
    log("is logg in $isLoggedIn");

    return BlocProvider(
      create: (context) => ThemeManager(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocBuilder<ThemeManager, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'Mishkat Almasabih',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                debugShowCheckedModeBanner: false,
                initialRoute: _getStartScreen(),
                onGenerateRoute: appRouter.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
