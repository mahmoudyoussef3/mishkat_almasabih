import 'dart:async';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mishkat_almasabih/core/config/app_config.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/core/notification/notification_helper.dart';
import 'package:mishkat_almasabih/core/notification/prayer_time_notification_scheduler.dart';
import 'package:mishkat_almasabih/core/notification/push_notification.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/core/services/hive_service.dart';
import 'package:mishkat_almasabih/core/services/prayer_times_home_widget_sync.dart';
import 'package:mishkat_almasabih/core/services/prayer_times_widget_background_worker.dart';
import 'package:mishkat_almasabih/core/services/widget_navigation_service.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/features/ramadan_tasks/domain/repositories/ramadan_config_repository.dart';
import 'package:mishkat_almasabih/firebase_options.dart';

import 'mishkat_almasabih.dart';

Future<void> bootstrapApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  await NotificationHelper.init();
  await LocalNotification.init();
  await PrayerNotificationScheduler.bootstrap();
  await PrayerTimesWidgetBackgroundWorker.initialize();
  await PrayerTimesHomeWidgetSync.refresh();
  PushNotification.setupOnTapNotification();
  PushNotification.handleTerminatedNotification();

  await setUpGetIt();
  await HiveService.init();
  await _initializeRamadanRemoteConfig();
  await initializeDateFormatting('ar', null);

  WidgetNavigationService.initialize();

  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  runApp(
    MishkatAlmasabih(
      analytics: observer,
      appRouter: AppRouter(),
      config: config,
      isFirstTime: isFirstTime,
    ),
  );
}

Future<void> _initializeRamadanRemoteConfig() async {
  try {
    final remoteConfig = getIt<FirebaseRemoteConfig>();

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.setDefaults(const {
      'ramadan_start_offset': 0,
      'ramadan_total_days': 30,
    });

    final repository = getIt<RamadanConfigRepository>();
    await repository.initializeRemoteConfig();
  } catch (e) {
    debugPrint('Failed to initialize Ramadan Remote Config: $e');
  }
}
