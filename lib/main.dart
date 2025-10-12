import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/core/notification/push_notification.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'mishkat_almasabih.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Firebase.initializeApp();

  // تهيئة الـ FCM (مرة واحدة بس)
  await PushNotification.init();
  // Setup notification tap handlers
  await LocalNotification.init();
  //await PushNotification.getApnsToken();

    
    // إعداد tap على النوتيفيكيشن
    PushNotification.setupOnTapNotification();
    
    // معالجة لو الأبلكيشن فتح من نوتيفيكيشن (terminated state)
    PushNotification.handleTerminatedNotification();
  
  await setUpGetIt();
  await initializeDateFormatting('ar', null);
  //final prefs = await SharedPreferences.getInstance();
  //final token = prefs.getString('token');
 // final isLoggedIn = token != null;
  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final app = MishkatAlmasabih(
    appRouter: AppRouter(),
    isFirstTime: isFirstTime,
   // isLoggedIn: isLoggedIn,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(app);
}
