import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/notification/local_notification_service.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'core/di/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';

const fetchTaskKey = "fetchApiTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpGetIt();
  tz.initializeTimeZones();
  await EasyNotify.init();
  await EasyNotifyPermissions.requestAll();
  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool isLoggedIn = token != null;

  await ScreenUtil.ensureScreenSize();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  /*  await Workmanager().registerPeriodicTask(
    "fetchTask_24h",
    fetchTaskKey,
    frequency: const Duration(hours: 24),
  );
*/
  // تاسك تجريبي (مش هيشتغل أقل من 15 دقيقة في الواقع)
  await Workmanager().registerPeriodicTask(
    "fetchTask_debug",
    fetchTaskKey,
    frequency: const Duration(minutes: 15),
  );

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
