import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/debug_service/debug_service.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:android_intent_plus/android_intent.dart'; // ✅ battery settings
import 'mishkat_almasabih.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt();
  await initializeDateFormatting('ar', null);
  await initializeService();
  await EasyNotify.init(); // ✅ notifications

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool isLoggedIn = token != null;
  final bool isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final app = MishkatAlmasabih(
    appRouter: AppRouter(),
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  );

  runApp(
    kDebugMode
        ? DevicePreview(enabled: true, builder: (_) => app)
        : app,
  );

  /// افتح إعدادات البطارية عشان المستخدم يدي إذن
await  openBatterySettings();
}

/// 🔋 فتح Battery Optimization Settings
Future<void> openBatterySettings() async {
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.example.mishkat_almasabih', // حط package name بتاعك
  );
  await intent.launch();
}

/// 🟢 إعداد الخدمة
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      onStart: onStart,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'الخدمة بدأت',
      initialNotificationContent: 'التطبيق بيعمل في الخلفية',
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    // لازم يحصل فوراً
    await service.setAsForegroundService();
    await service.setForegroundNotificationInfo(
      title: "الخدمة شغالة ✅",
      content: "التطبيق بيعمل في الخلفية",
    );
  }
  final repo = HadithDailyRepo(ApiService(Dio()));

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    debugPrint("⏰ Timer tick");

    final result = await repo.getDailyHadith();
        debugConsole.add("✅ الخدمة اشتغلت");

    result.fold(
      (failure) =>debugConsole.add("❌ حصل خطأ: ${failure.apiErrorModel.msg}"),

      (hadith) async {
        debugPrint("✅ Got hadith: ${hadith.data?.hadith}");
        await EasyNotify.showBasicNotification(
          id: DateTime.now().millisecondsSinceEpoch.remainder(0x7FFFFFFF),
          title: "حديث جديد",
          body: hadith.data?.hadith ?? "حديث اليوم",
        );
debugConsole.add("📡 جبت حديث جديد: ${hadith.data?.hadith}");

      },
    );
  });
  // بعدين اعمل أي Calls أو Timer
}


/// 🍏 iOS
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("🍏 iOS background triggered");
  return true;
}
