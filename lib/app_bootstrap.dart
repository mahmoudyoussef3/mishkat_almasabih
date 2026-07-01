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

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Only setup that the very first frame depends on (DI-backed cubits/repos,
  // local storage, date formatting) runs before runApp(). Everything else —
  // especially anything that can show a permission dialog or a system
  // Settings screen (notification/exact-alarm/location prompts) — must never
  // block the first frame, or the app can get stuck on a black screen until
  // force-killed. See _initializeBackgroundServices below.
  await setUpGetIt();
  await HiveService.init();
  await initializeDateFormatting('ar', null);

  WidgetNavigationService.initialize();

  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    MishkatAlmasabih(
      analytics: observer,
      appRouter: AppRouter(),
      isFirstTime: isFirstTime,
    ),
  );

  unawaited(_initializeBackgroundServices());
}

/// Runs everything that is not required to render the first frame. This
/// includes notification permission prompts, exact-alarm/system-settings
/// intents, prayer notification scheduling, background workers and remote
/// config — all of which involve dialogs, native Settings screens, or
/// network I/O and must not block [runApp].
///
/// Each step is isolated: a failure in one (e.g. the widget background
/// worker) must never prevent unrelated steps — most importantly prayer
/// notification scheduling — from running.
Future<void> _initializeBackgroundServices() async {
  await _runIsolated('NotificationHelper.init', NotificationHelper.init);
  await _runIsolated('LocalNotification.init', LocalNotification.init);
  await _runIsolated(
    'PrayerNotificationScheduler.bootstrap',
    PrayerNotificationScheduler.bootstrap,
  );
  await _runIsolated(
    'PrayerTimesWidgetBackgroundWorker.initialize',
    PrayerTimesWidgetBackgroundWorker.initialize,
  );
  await _runIsolated(
    'PrayerTimesHomeWidgetSync.refresh',
    PrayerTimesHomeWidgetSync.refresh,
  );
  await _runIsolated('PushNotification.setupOnTapNotification', () async {
    PushNotification.setupOnTapNotification();
  });
  await _runIsolated(
    'PushNotification.handleTerminatedNotification',
    PushNotification.handleTerminatedNotification,
  );
  await _runIsolated(
    'FirebasePerformance.setPerformanceCollectionEnabled',
    () => FirebasePerformance.instance.setPerformanceCollectionEnabled(true),
  );
  await _runIsolated(
    '_initializeRamadanRemoteConfig',
    _initializeRamadanRemoteConfig,
  );
}

Future<void> _runIsolated(String label, Future<void> Function() step) async {
  try {
    await step();
  } catch (e, stackTrace) {
    debugPrint('Failed to initialize background service "$label": $e');
    FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
  }
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
