import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat_almasabih/core/notification/prayer_time_notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const MethodChannel _permissionChannel = MethodChannel(
  'flutter.baseflow.com/permissions/methods',
);

/// Mocks the permission_handler platform channel so `Permission.notification`
/// resolves to [granted] without touching a real device/OS permission.
void _mockNotificationPermission(bool granted) {
  TestDefaultBinaryMessengerBinding
      .instance
      .defaultBinaryMessenger
      .setMockMethodCallHandler(_permissionChannel, (call) async {
        switch (call.method) {
          case 'checkPermissionStatus':
            // PermissionStatus.granted == 1, PermissionStatus.denied == 0.
            return granted ? 1 : 0;
          default:
            return null;
        }
      });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding
        .instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionChannel, null);
  });

  group('PrayerNotificationScheduler.isEnabled', () {
    test('is false when the user preference was never enabled', () async {
      SharedPreferences.setMockInitialValues({});
      _mockNotificationPermission(true);

      expect(await PrayerNotificationScheduler.isEnabled(), isFalse);
    });

    test(
      'is false when enabled by preference but OS permission is revoked',
      () async {
        SharedPreferences.setMockInitialValues({
          'prayer_notifications_enabled': true,
        });
        _mockNotificationPermission(false);

        expect(await PrayerNotificationScheduler.isEnabled(), isFalse);
      },
    );

    test(
      'is true only when both the preference and OS permission are granted',
      () async {
        SharedPreferences.setMockInitialValues({
          'prayer_notifications_enabled': true,
        });
        _mockNotificationPermission(true);

        expect(await PrayerNotificationScheduler.isEnabled(), isTrue);
      },
    );
  });

  group('PrayerNotificationScheduler.buildSchedule', () {
    test('creates five unique future prayer reminders for each full day', () {
      final now = DateTime(2026, 1, 15);

      final schedule = PrayerNotificationScheduler.buildSchedule(
        PrayerNotificationLocation.defaultLocation,
        currentTime: now,
        daysAhead: 2,
      );

      expect(schedule, hasLength(10));
      expect(schedule.map((entry) => entry.id).toSet(), hasLength(10));
      expect(schedule.every((entry) => entry.fireAt.isAfter(now)), isTrue);
      expect(schedule.map((entry) => entry.prayerKey).toSet(), {
        'fajr',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      });
    });

    test('serialization preserves the alarm delivery timestamp', () {
      final entry = PrayerNotificationScheduleEntry(
        id: 123,
        prayerKey: 'fajr',
        prayerLabel: 'الفجر',
        title: 'تذكير صلاة الفجر',
        body: 'حان الآن وقت صلاة الفجر.',
        fireAt: DateTime.fromMillisecondsSinceEpoch(1768446000000),
      );

      final restored = PrayerNotificationScheduleEntry.fromJson(entry.toJson());

      expect(restored.id, entry.id);
      expect(restored.prayerKey, entry.prayerKey);
      expect(restored.fireAt, entry.fireAt);
    });
  });
}
