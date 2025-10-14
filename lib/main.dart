import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/core/notification/push_notification.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';
import 'package:mishkat_almasabih/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Local Notifications
  await LocalNotification.init();

  // Initialize Push Notifications
  await PushNotification.init();

  // Setup notification tap handling
  PushNotification.setupOnTapNotification();
  await PushNotification.handleTerminatedNotification();

  // Dependency Injection
  await setUpGetIt();
  await initializeDateFormatting('ar', null);

  // Check if first time user
  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final app = MishkatAlmasabih(
    appRouter: AppRouter(),
    isFirstTime: isFirstTime,
  );

  runApp(app);
}
