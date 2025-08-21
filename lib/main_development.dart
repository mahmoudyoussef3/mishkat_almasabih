import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await setUpGetIt();
  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool isLoggedIn = token != null;

  await ScreenUtil.ensureScreenSize();
  runApp(
    DevicePreview(
      enabled: true,

      builder:
          (context) => MishkatAlmasabih(
            appRouter: AppRouter(),
            isFirstTime: isFirstTime,
            isLoggedIn: isLoggedIn,
          ),
    ),
  );
}
