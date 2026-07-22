import 'dart:io';

import 'package:workmanager/workmanager.dart';

import '../notification/prayer_time_notification_scheduler.dart';
import 'prayer_times_home_widget_sync.dart';

/// Owns the app's single [Workmanager] runtime. Workmanager only supports one
/// callback dispatcher per app, so every periodic background task is
/// registered and routed from here instead of each feature initializing its
/// own Workmanager instance.
class PrayerTimesWidgetBackgroundWorker {
  static const String _widgetRefreshTask = 'prayer_times_widget_refresh';
  static const String _uniqueWidgetRefreshTask =
      'prayer_times_widget_refresh_daily';

  // Safety net for the native rolling alarm chain: only the next prayer's
  // alarm is ever armed on the Android side, and it re-arms the following
  // one when it fires. If that chain is ever broken (killed receiver, OEM
  // battery restrictions, a missed exact alarm, ...), every prayer after the
  // break point silently stops firing until the app is reopened. Periodically
  // re-syncing here bounds how long notifications can stay silently broken.
  static const String _notificationResyncTask = 'prayer_notifications_resync';
  static const String _uniqueNotificationResyncTask =
      'prayer_notifications_resync_periodic';
  static const Duration _notificationResyncFrequency = Duration(hours: 6);

  static Future<void> initialize() async {
    await Workmanager().initialize(prayerTimesWidgetCallbackDispatcher);

    if (!Platform.isAndroid) {
      return;
    }

    if (!await Workmanager().isScheduledByUniqueName(
      _uniqueWidgetRefreshTask,
    )) {
      await Workmanager().registerPeriodicTask(
        _uniqueWidgetRefreshTask,
        _widgetRefreshTask,
        frequency: const Duration(hours: 24),
        initialDelay: _delayUntilNextMidnight(),
      );
    }

    if (!await Workmanager().isScheduledByUniqueName(
      _uniqueNotificationResyncTask,
    )) {
      await Workmanager().registerPeriodicTask(
        _uniqueNotificationResyncTask,
        _notificationResyncTask,
        frequency: _notificationResyncFrequency,
      );
    }
  }

  static Duration _delayUntilNextMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    return nextMidnight.difference(now);
  }
}

@pragma('vm:entry-point')
void prayerTimesWidgetCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case PrayerTimesWidgetBackgroundWorker._widgetRefreshTask:
        await PrayerTimesHomeWidgetSync.refresh();
        return true;
      case PrayerTimesWidgetBackgroundWorker._notificationResyncTask:
        // No-ops internally if the user hasn't enabled prayer notifications.
        // Reporting the real outcome lets Workmanager back off and retry a
        // transient failure instead of waiting for the next 6h tick.
        final result = await PrayerNotificationScheduler.refreshSchedule();
        return result.success;
    }

    return true;
  });
}
