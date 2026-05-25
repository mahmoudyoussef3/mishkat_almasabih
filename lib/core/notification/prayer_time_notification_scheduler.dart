import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerNotificationScheduler {
  static const MethodChannel _channel = MethodChannel(
    'com.mishkat_almasabih.app/prayer_notifications',
  );

  static const String _enabledKey = 'prayer_notifications_enabled';
  static const String _locationKey = 'prayer_notification_location';
  static const String _legacyLocationKey = 'prayer_location';
  static const String _scheduleKey = 'prayer_notification_schedule';
  static const int _daysAhead = 60;
  static const String _testPrayerKey = 'test';

  static bool _bootstrapped = false;

  static Future<void> bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;

    if (!await isEnabled()) return;
    await refreshSchedule();
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  static Future<PrayerNotificationActionResult> setEnabled(
    bool enabled, {
    bool refresh = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (!enabled) {
      await cancelAll();
      await prefs.setBool(_enabledKey, false);
      return const PrayerNotificationActionResult(
        success: true,
        message: 'تم إيقاف إشعارات مواقيت الصلاة',
      );
    }

    final permissionResult = await _requestPermissions();
    if (!permissionResult.success) {
      return permissionResult;
    }

    await prefs.setBool(_enabledKey, true);

    if (!refresh) {
      return const PrayerNotificationActionResult(
        success: true,
        message: 'تم تفعيل إشعارات مواقيت الصلاة',
      );
    }

    final refreshResult = await refreshSchedule();
    if (!refreshResult.success) {
      await prefs.setBool(_enabledKey, false);
      return refreshResult;
    }

    return const PrayerNotificationActionResult(
      success: true,
      message: 'تم تفعيل إشعارات مواقيت الصلاة',
    );
  }

  static Future<PrayerNotificationActionResult> refreshSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!(prefs.getBool(_enabledKey) ?? false)) {
        return const PrayerNotificationActionResult(
          success: true,
          message: 'إشعارات مواقيت الصلاة غير مفعلة',
        );
      }

      final location = await _resolveLocation(prefs);
      final schedule = _buildSchedule(location);

      if (schedule.isEmpty) {
        return const PrayerNotificationActionResult(
          success: false,
          message: 'لم يتم العثور على مواعيد صلاة قادمة لإعداد التنبيهات',
        );
      }

      await _persistLocation(prefs, location);
      await _persistSchedule(prefs, schedule);

      await _channel.invokeMethod(
        'schedulePrayerNotifications',
        jsonEncode({'items': schedule.map((entry) => entry.toJson()).toList()}),
      );

      return PrayerNotificationActionResult(
        success: true,
        message: 'تمت مزامنة إشعارات مواقيت الصلاة',
        scheduledCount: schedule.length,
      );
    } catch (e, stackTrace) {
      log(
        'Error refreshing prayer notification schedule: $e',
        stackTrace: stackTrace,
      );
      return const PrayerNotificationActionResult(
        success: false,
        message: 'تعذر مزامنة إشعارات مواقيت الصلاة',
      );
    }
  }

  static Future<PrayerNotificationActionResult> cancelAll() async {
    try {
      await _channel.invokeMethod('cancelPrayerNotifications');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scheduleKey);
      return const PrayerNotificationActionResult(
        success: true,
        message: 'تم إلغاء جميع إشعارات مواقيت الصلاة',
      );
    } catch (e, stackTrace) {
      log('Error canceling prayer notifications: $e', stackTrace: stackTrace);
      return const PrayerNotificationActionResult(
        success: false,
        message: 'تعذر إلغاء إشعارات مواقيت الصلاة',
      );
    }
  }

  static Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final result = await _channel.invokeMethod<bool>(
        'hasExactAlarmPermission',
      );
      return result ?? false;
    } catch (e) {
      log('Exact alarm permission check failed: $e');
      return false;
    }
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final result = await _channel.invokeMethod<bool>(
        'requestExactAlarmPermission',
      );
      return result ?? false;
    } catch (e) {
      log('Exact alarm permission request failed: $e');
      return false;
    }
  }

  static Future<PrayerNotificationActionResult> testNotification() async {
    final permissionResult = await _requestPermissions();
    if (!permissionResult.success) {
      return permissionResult;
    }

    try {
      final fireAt = DateTime.now().add(const Duration(minutes: 1));
      final entry = PrayerNotificationScheduleEntry(
        id: DateTime.now().millisecondsSinceEpoch % 2147483647,
        prayerKey: _testPrayerKey,
        prayerLabel: 'اختبار',
        title: 'Test Prayer Notification',
        body: 'This is a test notification',
        fireAt: fireAt,
      );

      await _channel.invokeMethod(
        'scheduleTestPrayerNotification',
        jsonEncode({
          'items': [entry.toJson()],
        }),
      );

      return const PrayerNotificationActionResult(
        success: true,
        message: 'تم جدولة إشعار اختبار بعد دقيقة',
      );
    } catch (e, stackTrace) {
      log(
        'Error scheduling test prayer notification: $e',
        stackTrace: stackTrace,
      );
      return const PrayerNotificationActionResult(
        success: false,
        message: 'تعذر جدولة إشعار الاختبار',
      );
    }
  }

  static Future<PrayerNotificationActionResult> _requestPermissions() async {
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.request();
      if (!notificationStatus.isGranted) {
        return const PrayerNotificationActionResult(
          success: false,
          message: 'يرجى السماح بإشعارات التطبيق أولاً',
        );
      }

      final exactAlarmGranted = await hasExactAlarmPermission();
      if (!exactAlarmGranted) {
        final requested = await requestExactAlarmPermission();
        if (!requested) {
          return const PrayerNotificationActionResult(
            success: false,
            message:
                'يرجى السماح بإنذارات دقيقة حتى تصل إشعارات الصلاة في وقتها',
          );
        }
      }
    }

    return const PrayerNotificationActionResult(
      success: true,
      message: 'تم منح الأذونات المطلوبة',
    );
  }

  static Future<PrayerNotificationLocation> _resolveLocation(
    SharedPreferences prefs,
  ) async {
    final storedLocationJson =
        prefs.getString(_locationKey) ?? prefs.getString(_legacyLocationKey);
    if (storedLocationJson != null && storedLocationJson.isNotEmpty) {
      try {
        return PrayerNotificationLocation.fromJson(
          jsonDecode(storedLocationJson) as Map<String, dynamic>,
        );
      } catch (e) {
        log('Failed to parse stored prayer notification location: $e');
      }
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          return PrayerNotificationLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            cityName: 'موقعك الحالي',
          );
        }
      }
    } catch (e) {
      log('Unable to resolve current location for prayer notifications: $e');
    }

    return PrayerNotificationLocation.defaultLocation;
  }

  static List<PrayerNotificationScheduleEntry> _buildSchedule(
    PrayerNotificationLocation location,
  ) {
    final coordinates = Coordinates(location.latitude, location.longitude);
    final calculationParameters = CalculationMethod.egyptian.getParameters();
    calculationParameters.madhab = Madhab.shafi;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final entries = <PrayerNotificationScheduleEntry>[];

    for (var offset = 0; offset < _daysAhead; offset++) {
      final day = startOfToday.add(Duration(days: offset));
      final prayerTimes = PrayerTimes(
        coordinates,
        DateComponents.from(day),
        calculationParameters,
      );

      entries.addAll([
        _entryForPrayer(day, 'fajr', prayerTimes.fajr, 'الفجر'),
        _entryForPrayer(day, 'dhuhr', prayerTimes.dhuhr, 'الظهر'),
        _entryForPrayer(day, 'asr', prayerTimes.asr, 'العصر'),
        _entryForPrayer(day, 'maghrib', prayerTimes.maghrib, 'المغرب'),
        _entryForPrayer(day, 'isha', prayerTimes.isha, 'العشاء'),
      ]);
    }

    return entries
        .where((entry) => entry.fireAt.isAfter(now))
        .toList(growable: false);
  }

  static PrayerNotificationScheduleEntry _entryForPrayer(
    DateTime day,
    String prayerKey,
    DateTime fireAt,
    String arabicLabel,
  ) {
    final dateKey = day.year * 10000 + day.month * 100 + day.day;
    final prayerIndex = switch (prayerKey) {
      'fajr' => 1,
      'dhuhr' => 2,
      'asr' => 3,
      'maghrib' => 4,
      'isha' => 5,
      _ => 0,
    };

    return PrayerNotificationScheduleEntry(
      id: dateKey * 10 + prayerIndex,
      prayerKey: prayerKey,
      prayerLabel: arabicLabel,
      title: 'حان الآن موعد صلاة $arabicLabel',
      body: 'تقبل الله طاعتك. حان الآن موعد صلاة $arabicLabel.',
      fireAt: fireAt,
    );
  }

  static Future<void> _persistLocation(
    SharedPreferences prefs,
    PrayerNotificationLocation location,
  ) async {
    await prefs.setString(_locationKey, jsonEncode(location.toJson()));
  }

  static Future<void> _persistSchedule(
    SharedPreferences prefs,
    List<PrayerNotificationScheduleEntry> schedule,
  ) async {
    await prefs.setString(
      _scheduleKey,
      jsonEncode(schedule.map((entry) => entry.toJson()).toList()),
    );
  }
}

class PrayerNotificationActionResult {
  final bool success;
  final String message;
  final int scheduledCount;

  const PrayerNotificationActionResult({
    required this.success,
    required this.message,
    this.scheduledCount = 0,
  });
}

class PrayerNotificationLocation {
  final double latitude;
  final double longitude;
  final String cityName;

  const PrayerNotificationLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  static const PrayerNotificationLocation defaultLocation =
      PrayerNotificationLocation(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'القاهرة، مصر',
      );

  factory PrayerNotificationLocation.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationLocation(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0444,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 31.2357,
      cityName: json['cityName'] as String? ?? 'القاهرة، مصر',
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'cityName': cityName};
  }
}

class PrayerNotificationScheduleEntry {
  final int id;
  final String prayerKey;
  final String prayerLabel;
  final String title;
  final String body;
  final DateTime fireAt;

  const PrayerNotificationScheduleEntry({
    required this.id,
    required this.prayerKey,
    required this.prayerLabel,
    required this.title,
    required this.body,
    required this.fireAt,
  });

  factory PrayerNotificationScheduleEntry.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationScheduleEntry(
      id: (json['id'] as num).toInt(),
      prayerKey: json['prayerKey'] as String,
      prayerLabel:
          json['prayerLabel'] as String? ?? json['prayerKey'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      fireAt: DateTime.fromMillisecondsSinceEpoch(
        (json['fireAtMillis'] as num).toInt(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prayerKey': prayerKey,
      'prayerLabel': prayerLabel,
      'title': title,
      'body': body,
      'fireAtMillis': fireAt.millisecondsSinceEpoch,
    };
  }
}
