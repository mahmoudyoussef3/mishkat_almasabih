import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat_almasabih/core/notification/prayer_time_notification_scheduler.dart';

void main() {
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
