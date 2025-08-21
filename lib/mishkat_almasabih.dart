import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

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

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Mishkat Almasabih',
          theme: ThemeData(fontFamily: 'YaModernPro'),

          debugShowCheckedModeBanner: false,
          initialRoute: _getStartScreen(),
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
