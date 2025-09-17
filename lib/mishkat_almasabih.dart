import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';

class MishkatAlmasabih extends StatelessWidget {
  final AppRouter appRouter;
  final bool isFirstTime;
  final bool isLoggedIn;
  
  const MishkatAlmasabih({
    required this.appRouter, required this.isFirstTime, required this.isLoggedIn, super.key,
  });

  String _getStartScreen() {
    log("Determining start screen...");
    
    if (isFirstTime) {
      log("Going to onboarding screen");
      return Routes.onBoardingScreen;
    } else if (!isLoggedIn) {
      log("Going to login screen");
      return Routes.loginScreen;
    } else {
      log("Going to splash screen");
      return Routes.splashScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("isFirstTime is $isFirstTime");
    log("is logged in $isLoggedIn");
    
    final startScreen = _getStartScreen();
    log("Start screen: $startScreen");

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Mishkat Almasabih',
          theme: ThemeData(
            fontFamily: 'Cairo',
            useMaterial3: true, // إضافة Material 3
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: _getStartScreen(),
          onGenerateRoute: appRouter.generateRoute,
          
          // إضافة error handling
          onUnknownRoute: (settings) {
            log("Unknown route: ${settings.name}");
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('خطأ')),
                body: const Center(
                  child: Text('الصفحة غير موجودة'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}