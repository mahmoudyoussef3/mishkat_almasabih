/*
class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  static void showBasicNotification() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_notification_channel_id',
        'Default Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      'Instant Notification',
      'The body of the notification',
      details,
      payload: 'payloadData',
    );
  }

  static void repeatedNotification() async {
    // First check if we can schedule exact alarms
    await _requestExactAlarmPermission();
    
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'repeated_notification_channel_id', // Different channel for repeated notifications
        'Repeated Notification Channel',
        channelDescription: 'Channel for repeated notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
      ),
    );
    
    try {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        2,
        'This is repeated Notification',
        'Repeated notification every minute',
        RepeatInterval.everyMinute,
        details,
        payload: 'payloadData',
        // Remove this line - it's causing the issue
        // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint("Repeated notification scheduled successfully");
    } catch (e) {
      debugPrint("Error scheduling repeated notification: $e");
      // Fallback: try without exact scheduling
      await _scheduleRepeatedNotificationFallback(details);
    }
  }

  // Fallback method for devices that don't support exact alarms
  static Future<void> _scheduleRepeatedNotificationFallback(NotificationDetails details) async {
    try {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        2,
        'This is repeated Notification',
        'Repeated notification every minute (approximate)',
        RepeatInterval.everyMinute,
        details,
        payload: 'payloadData',
        // Use inexact scheduling as fallback
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
      debugPrint("Repeated notification scheduled with inexact timing");
    } catch (e) {
      debugPrint("Fallback scheduling also failed: $e");
    }
  }

  // Request exact alarm permission for Android 12+
  static Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isGranted) {
        debugPrint("Exact alarm permission granted");
      } else {
        debugPrint("Exact alarm permission denied");
      }
    }
  }

  void cancelNotification(int id) async {
    await LocalNotificationService.flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAllNotifications() async {
    await LocalNotificationService.flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint("Notification permission granted.");
    } else {
      debugPrint("Notification permission denied.");
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  // Enhanced permission request method that handles all required permissions
  static Future<void> requestAllPermissions() async {
    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      debugPrint("Notification permission granted.");
    } else {
      debugPrint("Notification permission denied.");
      if (notificationStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    // Request exact alarm permission (Android 12+)
    final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
    if (exactAlarmStatus.isGranted) {
      debugPrint("Exact alarm permission granted.");
    } else {
      debugPrint("Exact alarm permission denied.");
    }
  }

  // Check if exact alarms are available
  static Future<bool> canScheduleExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.status;
    return status.isGranted;
  }
}
*/