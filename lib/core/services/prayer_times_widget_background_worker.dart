import 'dart:io';

import 'package:workmanager/workmanager.dart';

import 'prayer_times_home_widget_sync.dart';

class PrayerTimesWidgetBackgroundWorker {
  static const String _taskName = 'prayer_times_widget_refresh';
  static const String _uniqueTaskName = 'prayer_times_widget_refresh_daily';

  static Future<void> initialize() async {
    await Workmanager().initialize(prayerTimesWidgetCallbackDispatcher);

    if (!Platform.isAndroid) {
      return;
    }

    final alreadyScheduled = await Workmanager().isScheduledByUniqueName(
      _uniqueTaskName,
    );
    if (alreadyScheduled) {
      return;
    }

    await Workmanager().registerPeriodicTask(
      _uniqueTaskName,
      _taskName,
      frequency: const Duration(hours: 24),
      initialDelay: _delayUntilNextMidnight(),
    );
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
    if (taskName == 'prayer_times_widget_refresh') {
      await PrayerTimesHomeWidgetSync.refresh();
    }

    return true;
  });
}
