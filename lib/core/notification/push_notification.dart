import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_handler.dart';
import 'package:mishkat_almasabih/core/notification/local_notification.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/screen/daily_hadith_screen.dart';

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

    // طلب صلاحيات الإشعارات من المستخدم (iOS فقط مهم، Android بيتفعل تلقائيًا)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('✅ User granted permission for notifications');
    }

    // تحديد كيف يتم عرض الإشعار في الـ foreground (التطبيق مفتوح)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // الحصول على الـ FCM Token الخاص بالجهاز
    fcmToken = await messaging.getToken();
    log('📱 FCM Token: ${fcmToken ?? "Failed to get FCM token"}');

    // الاشتراك في topic لاستقبال إشعارات مخصصة له
    await messaging.subscribeToTopic('daily_hadith');
    log("📌 Subscribed to topic: daily_hadith");

    // إعداد استقبال الإشعارات في الـ foreground
    _setupForegroundNotification();

    // إعداد استقبال الإشعارات في background (لازم handler يكون top-level function)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _isInitialized = true;
    log('✅ Push notifications initialized successfully');
  }

  /// استقبال الإشعارات لما التطبيق مفتوح (foreground)
  static void _setupForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📩 Foreground message received: ${message.data}');

      // عرض إشعار محلي على Android
      if (Platform.isAndroid) {
        await LocalNotification.forgroundNotificationHandler(message);
      }

      // هنا ممكن تعمل أي تعامل مع الـ data اللي جت من السيرفر
      // مثال: استدعاء API أو تخزينها
      // await _handleHadithNavigation(message, showScreen: false);
    });
  }

  /// استقبال الإشعار لما المستخدم يضغط على النوتيفيكيشن ويفتح التطبيق
  static void setupOnTapNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("👆 User tapped notification with data: ${message.data}");

      // هنا تقدر تعمل Navigation عشان تفتح شاشة معينة
      // await _handleHadithNavigation(message, navigate: true);
    });
  }

  /// استقبال الإشعار لو التطبيق كان Terminated (مقفول خالص)
  static Future<void> handleTerminatedNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log(
        "🚀 App opened from terminated state with data: ${initialMessage.data}",
      );

      // هنا تقدر تفتح شاشة معينة لو الإشعار معاه data مهمة
      // await _handleHadithNavigation(initialMessage, navigate: true);
    }
  }
}

/// 🔹 Handler للإشعارات اللي بتيجي في background أو terminated.
/// لازم يكون function عادي (top-level) مش static جوه class.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("📩 Background message received: ${message.data}");

  final repo = SaveHadithDailyRepo();
  final hadithId = message.data['hadithId'];

  if (hadithId != null) {
    repo.deleteHadith();
    // استدعاء API في الخلفية (بدون UI)
    final hadith = await repo.fetchHadith(hadithId.toString());
    log("📖 Hadith fetched in background: $hadith");

    // ملاحظة: هنا مينفعش تعمل Navigation أو UI
    // ممكن تخزن الداتا في Hive/SharedPreferences وتعرضها بعد فتح التطبيق
  }
}
