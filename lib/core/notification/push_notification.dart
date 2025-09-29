import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_factories.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/core/notification/send_fcm_token.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PushNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? fcmToken;
  static String? apnsToken;
  static bool _isInitialized = false; // Prevent multiple initializations
  static Future<RemoteMessage?> getInitialNotification() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  static Future pushNotifications() async {
    // Prevent multiple initializations
    if (_isInitialized) {
      log('Push notifications already initialized');
      return;
    }

    // 1. Request permissions with proper iOS settings
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    // 2. Check if permission was granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    }

    // 3. Configure foreground notification presentation options for iOS
    // This is CRUCIAL - it determines how notifications appear in foreground
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Get FCM token
    fcmToken = await messaging.getToken();
    log('FCM Token: ${fcmToken ?? "Failed to get FCM token"}');
    // CacheHelper.saveData(key: 'fcm_token', value: fcmToken);

    // 5. Handle APNS token for iOS
    await getApnsToken();

    // 6. Initialize foreground notification handling
    setupForegroundNotification();

    // 7. Set up background handler
    FirebaseMessaging.onBackgroundMessage(backGroundHandler);

    _isInitialized = true;
    log('Push notifications initialized successfully');
  }

  static Future<void> backGroundHandler(RemoteMessage message) async {
    log("Background message: ${message.data}");
  }

  static void setupForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got foreground message:');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
      log('Data: ${message.data}');
      log('Received foreground message: ${message.messageId}');

      // Ensure the message contains notification data
      if (message.notification == null) {
        log('No notification in message');
        return;
      }

      // On iOS, if setForegroundNotificationPresentationOptions is configured,
      // the system will automatically show the notification
      // Only show local notification if you want custom behavior
      if (Platform.isAndroid) {
        // Handle foreground notification for Android only
        await LocalNotification.forgroundNotificationHandler(message);
      }
      // For iOS, the system handles it automatically with the presentation options
    });
  }

  // make it seperate function to handle notification tap
  static void handleNotificationTap(RemoteMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigationHandler =
          NotificationHandlerFactory.getHandler(message.data['type']);
      navigationHandler?.handleOnTap();
    });
  }

  static Future<void> setupOnTapNotification() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationTap(message);
    });
  }

  static Future<void> handleOnClickTirminatedApp() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleNotificationTap(initialMessage);
    }
  }

  static Future<void> getApnsToken() async {
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      log(apnsToken ?? 'Failed to get apns');

      if (apnsToken != null) {
        await messaging.subscribeToTopic('moona');
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          await messaging.subscribeToTopic('moona');
        }
      }
    } else {
      await messaging.subscribeToTopic('moona');
    }
  }

  static Future<void> updateFcmtokenIfChanged() async {
      final prefs = await SharedPreferences.getInstance();

    String? savedFcmToken = prefs.getString('fcm_token');
    String? fcmTokenDevice = await FirebaseMessaging.instance.getToken();
    log('Current FCM Token: $fcmTokenDevice, Saved FCM Token: $savedFcmToken');

    if (fcmTokenDevice != savedFcmToken || savedFcmToken == null) {
      UpdateFcmToken.sendFcmToken(fcmTokenDevice!);
      log('FCM Token has changed, updating...');
      prefs.setString( 'fcm_token', fcmTokenDevice);
      log('FCM Token updated successfully: $fcmTokenDevice');
    } else {
      log('FCM Token has not changed, no update needed.');
    }
  }
}