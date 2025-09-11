import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

import 'mishkat_almasabih.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpGetIt();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool isLoggedIn = token != null;

  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  runApp(
    kDebugMode
        ? DevicePreview(
          enabled: true,
          builder:
              (context) => MishkatAlmasabih(
                appRouter: AppRouter(),
                isFirstTime: isFirstTime,
                isLoggedIn: isLoggedIn,
              ),
        )
        : MishkatAlmasabih(
          appRouter: AppRouter(),
          isFirstTime: isFirstTime,
          isLoggedIn: isLoggedIn,
        ),
  );
}
