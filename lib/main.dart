import 'dart:async';
import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt();
  await initializeDateFormatting('ar');
  await EasyNotify.init();
 // await initializeService();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isLoggedIn = token != null;
  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final app = MishkatAlmasabih(
    appRouter: AppRouter(),
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  );

  runApp(app);

 // await openBatterySettings();
}

Future<void> openBatterySettings() async {
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.example.mishkat_almasabih',
  );
  await intent.launch();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      isForegroundMode: true,
      onStart: onStart,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'الخدمة بدأت',
      initialNotificationContent: 'التطبيق بيعمل في الخلفية',
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
    await service.setForegroundNotificationInfo(
      title: "الخدمة شغالة ✅",
      content: "التطبيق بيعمل في الخلفية",
    );
  }

  final repo = HadithDailyRepo(ApiService(Dio()));

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    final result = await repo.getDailyHadith();

    result.fold(
      (failure) {
        debugPrint("❌ حصل خطأ: ${failure.apiErrorModel.msg}");
      },
      (hadith) async {
                SaveHadithDailyRepo().deleteHadith();

        debugPrint("✅ Got hadith: ${hadith.data?.hadith}");
                SaveHadithDailyRepo().saveHadith(hadith);

        await EasyNotify.showBasicNotification(
          id: DateTime.now().millisecondsSinceEpoch.remainder(0x7FFFFFFF),
          title: "حديث جديد",
          body: hadith.data?.hadith ?? "حديث اليوم",
        );
      },
    );
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("🍏 iOS background triggered");
  return true;
}
