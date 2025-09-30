import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_handler.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/screen/daily_hadith_screen.dart';

class PushNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? fcmToken;
  static bool _isInitialized = false;

  static final SaveHadithDailyRepo _repo = SaveHadithDailyRepo();

  static Future<void> init() async {
    if (_isInitialized) {
      log('Push notifications already initialized');
      return;
    }

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    }

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    fcmToken = await messaging.getToken();
    log('FCM Token: ${fcmToken ?? "Failed to get FCM token"}');

    await messaging.subscribeToTopic('daily_hadith');
    log("Subscribed to topic: daily_hadith");

    _setupForegroundNotification();

    FirebaseMessaging.onBackgroundMessage(_backGroundHandler);

    _isInitialized = true;
    log('Push notifications initialized successfully');
  }

  static Future<void> _backGroundHandler(RemoteMessage message) async {
    log("Background message: ${message.data}");
    await _handleHadithNavigation(message);
  }

  static void _setupForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got foreground message: ${message.data}');

      if (Platform.isAndroid) {
        await LocalNotification.forgroundNotificationHandler(message);
      }

      await _handleHadithNavigation(message, showScreen: false);
    });
  }

  static void setupOnTapNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("User tapped notification with data: ${message.data}");
      await _handleHadithNavigation(message, navigate: true);
    });
  }

  static Future<void> handleTerminatedNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log("App opened from terminated state with data: ${initialMessage.data}");
      await _handleHadithNavigation(initialMessage, navigate: true);
    }
  }

  static Future<void> _handleHadithNavigation(
    RemoteMessage message, {
    bool navigate = false,
    bool showScreen = true,
  }) async {
    try {
      final data = message.data;
      final hadithId = data['hadithId'];

      if (hadithId == null) {
        log("❌ No hadithId found in notification data");
        return;
      }
      log("❌ vfdvfdvfdvf");

      // استدعاء API
      final hadith = await _repo.fetchHadith(hadithId.toString());
      log(hadith.toString());
            log("❌ cdscdddd");

      /*
      if (hadith != null && navigate && showScreen) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) =>
                HadithDailyScreen(dailyHadithModel: hadith),
          ),
        );
      }
      */
    } catch (e) {
      log("❌ Error handling hadith navigation: $e");
    }
  }
}
