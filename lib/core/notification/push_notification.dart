import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_handler.dart';
import 'package:mishkat_almasabih/core/notification/hadith_refresh_notifier.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

/// GlobalKey للـ Navigator عشان نقدر نعمل navigation من أي مكان

/// Background message handler (لازم يكون top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("📩 Background message received: ${message.data}");

  final repo = SaveHadithDailyRepo();
  final hadithId = message.data['hadithId'];

  if (hadithId != null) {
    // حذف الحديث القديم
    await repo.deleteHadith();
    
    // جلب الحديث الجديد وحفظه
    final hadith = await repo.fetchHadith(hadithId.toString());
    
    if (hadith != null) {
      log("📖 Hadith fetched and saved in background: ${hadith.title}");
    } else {
      log("❌ Failed to fetch hadith in background");
    }
  }
}

/// كلاس مسؤول عن إعداد وتهيئة إشعارات Firebase Cloud Messaging (FCM)
class PushNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? fcmToken;
  static bool _isInitialized = false;

  static final SaveHadithDailyRepo _repo = SaveHadithDailyRepo();

  /// تهيئة الإشعارات (يتم استدعاؤها مرة واحدة فقط)
  static Future<void> init() async {
    if (_isInitialized) {
      log('Push notifications already initialized');
      return;
    }

    // طلب صلاحيات الإشعارات من المستخدم
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('✅ User granted permission for notifications');
    }

    // تحديد كيف يتم عرض الإشعار في الـ foreground
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // الحصول على الـ FCM Token
    fcmToken = await messaging.getToken();
    log('📱 FCM Token: ${fcmToken ?? "Failed to get FCM token"}');

    // الاشتراك في topic
    await messaging.subscribeToTopic('daily_hadith');
    await messaging.subscribeToTopic('update');

    log("📌 Subscribed to topic: daily_hadith");

    // إعداد استقبال الإشعارات في الـ foreground
    _setupForegroundNotification();

    // إعداد استقبال الإشعارات في background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _isInitialized = true;
    log('✅ Push notifications initialized successfully');
  }

  /// استقبال الإشعارات لما التطبيق مفتوح (foreground)
  static void _setupForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📩 Foreground message received: ${message.data}');

      final hadithId = message.data['hadithId'];
      
      if (hadithId != null) {
        // حذف الحديث القديم وجلب الجديد
        await _repo.deleteHadith();
        await _repo.fetchHadith(hadithId.toString());
        log("✅ Hadith updated in foreground");
        
        // إشعار الكارد بالتحديث
        HadithRefreshNotifier().notifyRefresh();
      }

      // عرض إشعار محلي على Android
      if (Platform.isAndroid) {
        await LocalNotification.forgroundNotificationHandler(message);
      }
    });
  }

  /// استقبال الإشعار لما المستخدم يضغط على النوتيفيكيشن ويفتح التطبيق
  static void setupOnTapNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("👆 User tapped notification (app in background): ${message.data}");

      // الانتظار شوية عشان الأبلكيشن يخلص rendering
      await Future.delayed(const Duration(milliseconds: 300));
      
      // فتح شاشة الحديث
      await _navigateToHadithScreen();
    });
  }

  /// استقبال الإشعار لو التطبيق كان Terminated (مقفول خالص)
  static Future<void> handleTerminatedNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log("🚀 App opened from terminated state with data: ${initialMessage.data}");

      final hadithId = initialMessage.data['hadithId'];
      
      if (hadithId != null) {
        // التأكد إن الداتا موجودة (المفروض اتخزنت من الـ background handler)
        final hadith = await _repo.getHadith();
        
        if (hadith == null) {
          // لو مش موجودة، نجيبها دلوقتي
          log("⚠️ Hadith not found in cache, fetching now...");
          await _repo.deleteHadith();
          await _repo.fetchHadith(hadithId.toString());
        }
        
        // الانتظار شوية عشان الأبلكيشن يخلص initialization
        await Future.delayed(const Duration(milliseconds: 800));
        
        // فتح شاشة الحديث
        await _navigateToHadithScreen();
      }
    }
  }

  /// Navigation لشاشة الحديث اليومي
  static Future<void> _navigateToHadithScreen() async {
    try {
      final context = navigatorKey.currentContext;
      
      if (context == null) {
        log("❌ Navigator context is null");
        return;
      }

      // جلب الحديث المخزن عشان نبعته للشاشة
      final hadith = await _repo.getHadith();
      
      if (hadith == null) {
        log("❌ No hadith found to navigate to");
        return;
      }

      // استخدام نفس الطريقة اللي في الكارد بتاعك
      if (context.mounted) {
            Navigator.of(context).pushNamed(
          
          Routes.homeScreen,
        );
        
        /*
        Navigator.of(context).pushNamed(

          Routes.hadithOfTheDay,
          arguments: hadith,
        );
        */
        
        log("✅ Navigated to Hadith Daily Screen");
      }
      
    } catch (e) {
      log("❌ Navigation error: $e");
    }
  }
}