import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// ==================== معالج الإشعارات في الـ Background ====================
// لازم يكون top-level function (خارج أي class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background Message: ${message.messageId}');
  // ممكن تعمل أي حاجة هنا زي حفظ في database
}

// ==================== سيرفس إدارة الإشعارات ====================
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  // ==================== التهيئة الأساسية ====================
  Future<void> initialize() async {
    try {
      // 1. تهيئة Firebase
      await Firebase.initializeApp();
      print('✅ Firebase initialized successfully');

      // 2. تسجيل معالج الـ background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      print('✅ Background handler registered');

      // 3. طلب الصلاحيات
      await _requestPermissions();

      // 4. إعداد Local Notifications
      await _setupLocalNotifications();

      // 5. إعداد Firebase Messaging
      await _setupFirebaseMessaging();

      // 6. الحصول على FCM Token
      await _getToken();
      
      print('✅ Notification service initialized successfully');
    } catch (e) {
      print('❌ Error initializing notification service: $e');
      rethrow;
    }
  }

  // ==================== طلب الصلاحيات ====================
  Future<void> _requestPermissions() async {
    // صلاحيات Firebase
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // صلاحيات Android 13+ (POST_NOTIFICATIONS)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // ==================== إعداد Local Notifications ====================
  Future<void> _setupLocalNotifications() async {
    // إعدادات Android
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // إعدادات iOS
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // إنشاء قناة للإشعارات (Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ==================== إعداد Firebase Messaging ====================
  Future<void> _setupFirebaseMessaging() async {
    // عند وصول رسالة والتطبيق في الـ Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.messageId}');
      _showLocalNotification(message);
    });

    // عند الضغط على الإشعار والتطبيق في الـ Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.messageId}');
      _handleNotificationClick(message);
    });

    // التحقق من وجود إشعار عند فتح التطبيق
    RemoteMessage? initialMessage = 
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }
  }

  // ==================== الحصول على FCM Token ====================
  Future<String?> _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    
    // ابعت الـ token ده للباك اند عشان يبعتلك notifications
    // await _sendTokenToBackend(token);
    
    // الاستماع لتغييرات الـ token
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      // ابعت الـ token الجديد للباك اند
      // await _sendTokenToBackend(newToken);
    });

    return token;
  }

  // ==================== عرض الإشعار المحلي ====================
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // ==================== معالجة الضغط على الإشعار ====================
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // انتقل لصفحة معينة حسب الـ payload
  }

  void _handleNotificationClick(RemoteMessage message) {
    print('Message data: ${message.data}');
    // انتقل لصفحة معينة حسب الـ data
    // مثال: Navigator.pushNamed(context, '/order', arguments: message.data['orderId']);
  }

  // ==================== دوال مساعدة ====================
  
  // الحصول على الـ token الحالي
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // حذف الـ token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }

  // الاشتراك في topic معين
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // إلغاء الاشتراك في topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}