# Prayer Notifications - Technical README

## 1. Overview

The Prayer Notifications feature schedules exact notifications for the 5 daily prayers:
- Fajr
- Dhuhr
- Asr
- Maghrib
- Isha

Current implementation goals achieved:
- exact timing with AlarmManager exact alarms
- works when app is closed
- works while device is idle (setExactAndAllowWhileIdle)
- survives reboot and time/timezone changes

Why Android native scheduling is used:
- Dart computes prayer times, but scheduling is delegated to native Android AlarmManager for process-independent delivery
- exact alarms and boot restore are handled natively through BroadcastReceivers
- this project does not use Flutter local notifications for prayer scheduling

---

## 2. Architecture

End-to-end flow in this project:

```txt
Profile UI (toggle/refresh)
    -> PrayerNotificationScheduler (Dart)
    -> MethodChannel: com.mishkat_almasabih.app/prayer_notifications
    -> MainActivity.kt method handler
    -> PrayerNotificationScheduler.kt (Android)
    -> AlarmManager exact alarms
    -> PrayerNotificationReceiver
    -> NotificationManager.notify(...)
```

Boot/time restore flow:

```txt
BOOT_COMPLETED / TIME_CHANGED / TIMEZONE_CHANGED
    -> PrayerNotificationBootReceiver
    -> PrayerNotificationScheduler.restorePrayerNotifications(...)
    -> AlarmManager re-scheduling
```

---

## 3. Flutter files

### lib/core/notification/prayer_time_notification_scheduler.dart

Responsibility:
- main Flutter-side service for prayer notifications
- computes prayer schedule using adhan package
- handles permissions flow from Flutter side
- sends schedule payload to Android through MethodChannel

Important methods:
- `bootstrap()`:
  - called at app startup (from a fire-and-forget background init task, after the
    first frame has rendered — see `lib/app_bootstrap.dart` notes below)
  - the first time notification permission is granted and the user has never made
    an explicit enable/disable choice, auto-enables the feature
    (`_autoEnableIfPermissionGranted()`) so no manual toggle is required
  - if the feature ends up enabled, calls `refreshSchedule()`
- `isEnabled()`:
  - true only when the user preference is on AND the OS notification permission
    is currently granted, so the Profile toggle always reflects reality and the
    app never keeps arming alarms the user can no longer see
- `setEnabled(bool enabled, {bool refresh = true})`:
  - toggles feature on/off
  - when enabling, checks permissions (notification, exact alarm, and battery
    optimization exemption) and schedules alarms
  - when disabling, cancels all alarms
- `refreshSchedule()`:
  - resolves location
  - builds rolling schedule for `_daysAhead = 60`
  - persists schedule metadata in SharedPreferences
  - calls native method `schedulePrayerNotifications`
  - also invoked every 6 hours by a periodic `Workmanager` task
    (`PrayerTimesWidgetBackgroundWorker`) as a safety net: if the native
    rolling-alarm chain is ever broken (killed receiver, OEM battery
    restrictions, a missed exact alarm), this bounds how long notifications
    can stay silently broken
- `cancelAll()`:
  - calls native method `cancelPrayerNotifications`
- `hasExactAlarmPermission()` and `requestExactAlarmPermission()`:
  - communicate with Android to check/request exact alarm capability
- `hasBatteryOptimizationExemption()` and `requestBatteryOptimizationExemption()`:
  - communicate with Android to check/request exemption from OEM battery
    optimization (MIUI, EMUI, ColorOS, One UI "deep sleep", ...), which can kill
    the app process and silently drop otherwise-exact alarms

Supporting models in same file:
- `PrayerNotificationActionResult`
- `PrayerNotificationLocation`
- `PrayerNotificationScheduleEntry`

When called:
- startup: via `bootstrap()` from `lib/app_bootstrap.dart`
- user actions: via profile screen buttons/toggle

---

### lib/app_bootstrap.dart

Responsibility:
- initializes app services at startup

Prayer feature hook:
- `await PrayerNotificationScheduler.bootstrap();`

Meaning:
- app attempts to re-sync prayer schedule on startup when feature is enabled

---

### lib/features/profile/ui/profile_screen.dart

Responsibility:
- user-facing trigger points for prayer notifications

Feature triggers:
- `_togglePrayerNotifications(bool enabled)` -> `PrayerNotificationScheduler.setEnabled(...)`
- `_refreshPrayerNotifications()` -> `PrayerNotificationScheduler.refreshSchedule()`

Also loads persisted UI state:
- `_loadPrayerNotificationState()` reads `PrayerNotificationScheduler.isEnabled()`

---

### lib/features/profile/ui/widgets/prayer_notification_section.dart

Responsibility:
- prayer notifications controls UI

UI controls:
- switch for enable/disable (reflects `PrayerNotificationScheduler.isEnabled()`,
  which is auto-activated once notification permission is granted — no manual
  toggle is required for the feature to start working)
- refresh button (`onRefresh`)

---

## 4. MethodChannel contract

Channel name in current code:
- full channel: `com.mishkat_almasabih.app/prayer_notifications`
- logical suffix: `prayer_notifications`

Dart -> Kotlin methods currently implemented:

1. `schedulePrayerNotifications`
- Dart payload:
  - JSON string
  - shape:
    ```json
    {
      "items": [
        {
          "id": 202605241,
          "prayerKey": "fajr",
          "prayerLabel": "الفجر",
          "title": "حان الآن موعد صلاة الفجر",
          "body": "تقبل الله طاعتك. حان الآن موعد صلاة الفجر.",
          "fireAtMillis": 1780000000000
        }
      ]
    }
    ```
- Kotlin receiver:
  - `MainActivity.kt` -> `PrayerNotificationScheduler.schedulePrayerNotifications(...)`
- expected result:
  - replaces old schedule, stores future items, creates exact alarms

2. `cancelPrayerNotifications`
- Dart payload: none
- Kotlin receiver:
  - `PrayerNotificationScheduler.cancelPrayerNotifications(...)`
- expected result:
  - cancels all existing prayer PendingIntents and clears persisted schedule

3. `hasExactAlarmPermission`
- Dart payload: none
- Kotlin receiver:
  - `PrayerNotificationScheduler.hasExactAlarmPermission(...)`
- expected result:
  - returns boolean

4. `requestExactAlarmPermission`
- Dart payload: none
- Kotlin receiver:
  - `MainActivity.kt` opens `Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM`
- expected result:
  - returns true if already granted, false after opening settings when not granted

5. `hasIgnoreBatteryOptimizations`
- Dart payload: none
- Kotlin receiver:
  - `PrayerNotificationScheduler.isIgnoringBatteryOptimizations(...)`
- expected result:
  - returns boolean

6. `requestIgnoreBatteryOptimizations`
- Dart payload: none
- Kotlin receiver:
  - `PrayerNotificationScheduler.requestIgnoreBatteryOptimizations(...)` opens
    `Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`
- expected result:
  - returns true if already exempt, false after opening settings when not exempt

Note about requested names in original prompt:
- there is no separate Dart method named `requestPermissions` exposed on channel
- permission checks are handled in Dart service `_requestPermissions()` and internally call channel methods where needed
- there is no method named `cancelAll` on channel; actual channel method is `cancelPrayerNotifications`
- there is no method named `reschedulePrayerNotifications`; rescheduling is done by calling `schedulePrayerNotifications` again with a fresh full list

---

## 5. Android files

### android/app/src/main/kotlin/com/mishkat_almasabih/app/MainActivity.kt

Responsibility:
- hosts MethodChannel handlers
- forwards scheduling commands from Dart to Android scheduler

Receives:
- `schedulePrayerNotifications`
- `cancelPrayerNotifications`
- `hasExactAlarmPermission`
- `requestExactAlarmPermission`
- `hasIgnoreBatteryOptimizations`
- `requestIgnoreBatteryOptimizations`

Also handles existing widget/deep-link navigation methods on another channel (`com.mishkat_almasabih.app/widget`).

---

### android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationScheduler.kt

(Equivalent role to "PrayerNotificationManager" in the requested template)

Responsibility:
- native schedule manager for prayer alarms
- stores schedule in device-protected SharedPreferences
- restores alarms after reboot/time changes

Key behaviors:
- `schedulePrayerNotifications(...)`
  - parses payload and replaces schedule
- `replaceSchedules(...)`
  - cancels old alarms first
  - keeps only future entries
- `scheduleEntry(...)`
  - skips past alarms
  - uses `setExactAndAllowWhileIdle`
  - if exact permission missing on Android 12+, skips scheduling and logs warning
- `cancelPrayerNotifications(...)`
  - cancels all saved PendingIntents
- `restorePrayerNotifications(...)`
  - loads saved entries, filters future ones, re-schedules
- `showPrayerNotification(...)`
  - builds and posts notification

Storage:
- SharedPreferences file: `prayer_notification_scheduler`
- key: `schedules_json`

Exact alarm permission:
- check: `alarmManager.canScheduleExactAlarms()`
- settings intent: `Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM`

---

### android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationReceiver.kt

(Equivalent role to "PrayerAlarmReceiver" in requested template)

Responsibility:
- receives scheduled alarm broadcasts
- reads extras (id, prayerKey, title, body)
- calls `PrayerNotificationScheduler.showPrayerNotification(...)`
- removes the fired entry from the persisted schedule and re-arms the next one

Tap behavior:
- notification pending intent opens `MainActivity`

---

### android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationBootReceiver.kt

(Equivalent role to "BootReceiver" in requested template)

Responsibility:
- listens for system boot/time events
- calls `PrayerNotificationScheduler.restorePrayerNotifications(...)`

Handled actions in Kotlin `when`:
- `Intent.ACTION_BOOT_COMPLETED`
- `Intent.ACTION_LOCKED_BOOT_COMPLETED`
- `Intent.ACTION_MY_PACKAGE_REPLACED`
- `Intent.ACTION_TIME_CHANGED`
- `Intent.ACTION_TIMEZONE_CHANGED`

Manifest also includes `android.intent.action.TIME_SET` for this receiver.

---

### android/app/src/main/AndroidManifest.xml

Prayer-related declarations:
- permissions
- receiver registrations
- exported flags and intent filters

---

## 6. Permissions

Declared in AndroidManifest:

1. `android.permission.POST_NOTIFICATIONS`
- required for Android 13+ runtime notification permission
- requested from Dart via `permission_handler`

2. `android.permission.SCHEDULE_EXACT_ALARM`
- required on Android 12+ for exact alarms
- checked via `canScheduleExactAlarms()`
- settings opened via `ACTION_REQUEST_SCHEDULE_EXACT_ALARM`

3. `android.permission.RECEIVE_BOOT_COMPLETED`
- required to restore alarms after reboot

Other related permissions present but not prayer-specific core:
- `WAKE_LOCK` (helps wake execution context)
- `VIBRATE` (notification vibration)

---

## 7. Notification channel

Defined in `PrayerNotificationScheduler.kt`:
- channel id: `prayer_notifications`
- channel name: `Prayer Time Notifications`
- importance: `IMPORTANCE_HIGH`
- vibration: enabled
- sound: default notification sound (`RingtoneManager.TYPE_NOTIFICATION`)

Notification behavior:
- high priority reminder category
- visible on lock screen (`VISIBILITY_PUBLIC`)
- auto-cancel on tap
- tap opens `MainActivity`

---

## 8. Scheduling logic

How prayer list becomes alarms:
1. Dart computes prayer times for 60 days ahead using `adhan`
2. each prayer converted to `PrayerNotificationScheduleEntry`
3. all entries serialized to JSON and sent to Android
4. Android saves and schedules each future entry exactly

Duplicate avoidance:
- `replaceSchedules()` always calls `cancelPrayerNotifications()` first
- this makes scheduling idempotent per refresh cycle

Past prayers skipped:
- Dart filters entries: `entry.fireAt.isAfter(now)`
- Android also guards: `if (entry.fireAtMillis <= now) return`

Reschedule strategy:
- no incremental diffing; full replacement model
- refresh calls replace old schedule with new computed schedule

RequestCode generation:
- deterministic by date + prayer index in Dart (`YYYYMMDD * 10 + prayerIndex`)
- Android uses `entry.id` as PendingIntent requestCode

Timezone handling:
- prayer times computed from local date/time in Dart
- restore reacts to `TIME_CHANGED` and `TIMEZONE_CHANGED`
- startup bootstrap re-sync also helps after timezone drift

---

## 9. Restore after reboot

Where alarms are saved:
- Android device-protected SharedPreferences
- file: `prayer_notification_scheduler`
- key: `schedules_json`

How loaded and rescheduled:
1. `PrayerNotificationBootReceiver` receives boot/time broadcasts
2. calls `PrayerNotificationScheduler.restorePrayerNotifications(context)`
3. restore loads JSON entries
4. filters out past entries
5. re-schedules future entries with exact alarms

---

## 10. Testing

### A) Real prayer schedule test

Steps:
1. Enable prayer notifications using switch (or grant notification permission on
   first launch, which auto-enables the feature)
2. tap refresh (`مزامنة الإشعارات الآن`)
3. wait for next prayer time

Expected:
- notification appears at exact prayer time

### B) Reboot test

Steps:
1. ensure feature enabled and schedule exists
2. reboot device
3. wait for upcoming prayer

Expected:
- alarms restored and notification still appears

### C) Permission denied test

POST_NOTIFICATIONS denied:
- enabling returns error message; schedule not activated

Exact alarm denied:
- settings screen opened; if still denied, exact scheduling is not performed

### D) Timezone/time change test

Steps:
1. change device timezone/time
2. confirm boot/time receiver and/or app refresh path runs

Expected:
- future alarms reflect new device time context

---

## 11. Debugging guide

### Issue: notification not showing

Check:
- `POST_NOTIFICATIONS` granted (Android 13+)
- exact alarm permission granted on Android 12+
- app-level channel exists: `prayer_notifications`

Files:
- `lib/core/notification/prayer_time_notification_scheduler.dart`
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationScheduler.kt`

Logs:
- Android tag: `PrayerNotification`
- look for warnings like exact alarm permission missing

### Issue: duplicate alarms

Current design should prevent duplicates via `replaceSchedules()` cancel-first strategy.

Check:
- ensure scheduling always goes through `schedulePrayerNotifications` full replacement

### Issue: boot restore failed

Check:
- receiver declared in manifest
- `RECEIVE_BOOT_COMPLETED` exists
- saved schedule JSON not empty

Files:
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationBootReceiver.kt`
- `android/app/src/main/AndroidManifest.xml`

### Issue: notifications work for a while then silently stop

This is usually the native rolling-alarm chain breaking (only the *next* prayer
alarm is ever armed; each fire re-arms the following one) — a killed receiver,
OEM battery restrictions, or a missed exact alarm stops the whole chain.

Check:
- battery optimization exemption granted (`hasIgnoreBatteryOptimizations`) —
  MIUI/EMUI/ColorOS/One UI "deep sleep" style battery managers are the most
  common real-world cause
- the periodic `Workmanager` safety net (`prayer_notifications_resync`, every
  6h) is registered and firing — it calls `refreshSchedule()` to re-arm the
  chain if it was ever broken

Files:
- `lib/core/services/prayer_times_widget_background_worker.dart`
- `lib/core/notification/prayer_time_notification_scheduler.dart`
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationScheduler.kt`

---

## 12. Future improvements

Practical next steps:
- per-prayer toggles (e.g., enable Fajr only)
- custom adhan sound and per-channel sound options
- pre-prayer reminder offsets (e.g., 10 minutes before)
- action buttons on notifications (Snooze, Open Prayer Times)
- iOS native implementation with equivalent reliability strategy
- telemetry/health checks for last successful scheduling cycle

---

## Final summary

### Files documented

Flutter:
- `lib/core/notification/prayer_time_notification_scheduler.dart`
- `lib/app_bootstrap.dart`
- `lib/features/profile/ui/profile_screen.dart`
- `lib/features/profile/ui/widgets/prayer_notification_section.dart`

Android:
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/MainActivity.kt`
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationScheduler.kt`
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationReceiver.kt`
- `android/app/src/main/kotlin/com/mishkat_almasabih/app/PrayerNotificationBootReceiver.kt`
- `android/app/src/main/AndroidManifest.xml`

### Main flow

Dart computes + sends schedule -> Kotlin stores + schedules exact alarms -> receiver posts notification -> boot receiver restores future alarms.

### Key maintenance notes

- This feature relies on exact alarm permission on Android 12+.
- Scheduling uses full replacement model (cancel then re-schedule).
- Boot/time restore is native and depends on manifest receiver declarations.
- Channel contract must remain synchronized between Dart and MainActivity.
