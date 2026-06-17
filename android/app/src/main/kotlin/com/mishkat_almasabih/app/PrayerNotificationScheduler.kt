package com.mishkat_almasabih.app

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat.Action
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import android.widget.RemoteViews

data class PrayerNotificationEntry(
    val id: Int,
    val prayerKey: String,
    val prayerLabel: String,
    val title: String,
    val body: String,
    val fireAtMillis: Long,
)

object PrayerNotificationScheduler {
    private const val TAG = "PrayerNotification"
    private const val PREFS_NAME = "prayer_notification_scheduler"
    private const val KEY_SCHEDULES = "schedules_json"
    private const val CHANNEL_ID = "prayer_notifications"
    private const val CHANNEL_NAME = "Prayer Time Notifications"
    private const val CHANNEL_DESCRIPTION = "Exact prayer time reminders"
    const val EXTRA_NOTIFICATION_ID = "extra_notification_id"
    const val EXTRA_PRAYER_KEY = "extra_prayer_key"
    const val EXTRA_PRAYER_LABEL = "extra_prayer_label"
    const val EXTRA_TITLE = "extra_title"
    const val EXTRA_BODY = "extra_body"
    const val EXTRA_FIRE_AT_MILLIS = "extra_fire_at_millis"
    private const val ACTION_FIRE = "com.mishkat_almasabih.app.action.PRAYER_NOTIFICATION"
    private const val ACTION_TEST_FIRE = "com.mishkat_almasabih.app.action.PRAYER_NOTIFICATION_TEST"

    fun schedulePrayerNotifications(context: Context, payload: String) {
        val entries = parseEntries(payload)
        replaceSchedules(context, entries)
    }

    fun restorePrayerNotifications(context: Context) {
        val entries = loadEntries(context)
        if (entries.isEmpty()) return

        val now = System.currentTimeMillis()
        val futureEntries = entries.filter { it.fireAtMillis > now }
        persistEntries(context, futureEntries)
        futureEntries.forEach { scheduleEntry(context, it) }
    }

    fun cancelPrayerNotifications(context: Context) {
        val entries = loadEntries(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        entries.forEach { entry ->
            alarmManager.cancel(buildPendingIntent(context, entry))
        }

        persistEntries(context, emptyList())
    }

    fun removeFiredPrayerNotification(context: Context, notificationId: Int) {
        val remaining = loadEntries(context).filterNot { it.id == notificationId }
        persistEntries(context, remaining)
    }

    fun hasExactAlarmPermission(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }
    }

    fun requestExactAlarmPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return true
        }

        return try {
            val intent = buildExactAlarmPermissionIntent(context).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Unable to request exact alarm permission", e)
            false
        }
    }

    fun buildExactAlarmPermissionIntent(context: Context): Intent {
        return Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
            data = android.net.Uri.parse("package:${context.packageName}")
        }
    }

    fun showPrayerNotification(context: Context, entry: PrayerNotificationEntry) {
        createChannel(context)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val prayerLabel = entry.prayerLabel.ifBlank { prayerLabelFromKey(entry.prayerKey) }
        val reminderTime = formatReminderTime(entry.fireAtMillis)
        val reminderTitle = "تذكير صلاة $prayerLabel"
        val reminderBody = "وقت التذكير: $reminderTime"
        val detailsText = "$reminderBody\n${entry.body}"

        val contentIntent = PendingIntent.getActivity(
            context,
            entry.id,
            Intent(context, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            },
            pendingIntentFlags(),
        )

        val openAction = Action.Builder(
            0,
            "فتح التطبيق",
            contentIntent,
        ).build()

        val customView = RemoteViews(context.packageName, R.layout.notification_prayer).apply {
            setTextViewText(R.id.notification_title, reminderTitle)
            setTextViewText(R.id.notification_time, reminderBody)
            setTextViewText(R.id.notification_body, entry.body)
            setImageViewResource(R.id.notification_icon, R.mipmap.launcher_icon)
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(customView)
            .setCustomBigContentView(customView)
            .setWhen(entry.fireAtMillis)
            .setShowWhen(true)
            .setContentIntent(contentIntent)
            .addAction(openAction)
            .setAutoCancel(true)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setDefaults(NotificationCompat.DEFAULT_SOUND or NotificationCompat.DEFAULT_VIBRATE)
            .build()

        notificationManager.notify(entry.id, notification)
    }

    private fun replaceSchedules(context: Context, entries: List<PrayerNotificationEntry>) {
        cancelPrayerNotifications(context)

        val now = System.currentTimeMillis()
        val futureEntries = entries.filter { it.fireAtMillis > now }

        persistEntries(context, futureEntries)
        futureEntries.forEach { scheduleEntry(context, it) }
    }

    private fun scheduleEntry(context: Context, entry: PrayerNotificationEntry) {
        if (entry.fireAtMillis <= System.currentTimeMillis()) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = buildPendingIntent(context, entry)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            Log.w(
                TAG,
                "Exact alarm permission missing. Skipping prayer schedule for ${entry.prayerKey}",
            )
            return
        }

        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            entry.fireAtMillis,
            pendingIntent,
        )
    }

    private fun buildPendingIntent(context: Context, entry: PrayerNotificationEntry): PendingIntent {
        val intent = Intent(context, PrayerNotificationReceiver::class.java).apply {
            action = ACTION_FIRE
            putExtra(EXTRA_NOTIFICATION_ID, entry.id)
            putExtra(EXTRA_PRAYER_KEY, entry.prayerKey)
            putExtra(EXTRA_PRAYER_LABEL, entry.prayerLabel)
            putExtra(EXTRA_TITLE, entry.title)
            putExtra(EXTRA_BODY, entry.body)
            putExtra(EXTRA_FIRE_AT_MILLIS, entry.fireAtMillis)
        }

        return PendingIntent.getBroadcast(
            context,
            entry.id,
            intent,
            pendingIntentFlags(),
        )
    }

    private fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = CHANNEL_DESCRIPTION
            enableVibration(true)
            setSound(soundUri, audioAttributes)
        }

        notificationManager.createNotificationChannel(channel)
    }

    private fun persistEntries(context: Context, entries: List<PrayerNotificationEntry>) {
        val prefs = getPrefs(context)
        val json = JSONArray()
        entries.forEach { entry ->
            val item = JSONObject()
                .put("id", entry.id)
                .put("prayerKey", entry.prayerKey)
                .put("prayerLabel", entry.prayerLabel)
                .put("title", entry.title)
                .put("body", entry.body)
                .put("fireAtMillis", entry.fireAtMillis)
            json.put(item)
        }
        prefs.edit().putString(KEY_SCHEDULES, json.toString()).apply()
    }

    private fun loadEntries(context: Context): List<PrayerNotificationEntry> {
        val raw = getPrefs(context).getString(KEY_SCHEDULES, null) ?: return emptyList()

        return try {
            val array = JSONArray(raw)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.getJSONObject(index)
                    add(
                        PrayerNotificationEntry(
                            id = item.getInt("id"),
                            prayerKey = item.getString("prayerKey"),
                            prayerLabel = item.optString("prayerLabel", ""),
                            title = item.getString("title"),
                            body = item.getString("body"),
                            fireAtMillis = item.getLong("fireAtMillis"),
                        ),
                    )
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Unable to load prayer notification entries", e)
            emptyList()
        }
    }

    private fun parseEntries(payload: String): List<PrayerNotificationEntry> {
        return try {
            val root = JSONObject(payload)
            val items = root.optJSONArray("items") ?: JSONArray()
            buildList {
                for (index in 0 until items.length()) {
                    val item = items.getJSONObject(index)
                    add(
                        PrayerNotificationEntry(
                            id = item.getInt("id"),
                            prayerKey = item.getString("prayerKey"),
                            prayerLabel = item.optString("prayerLabel", ""),
                            title = item.getString("title"),
                            body = item.getString("body"),
                            fireAtMillis = item.getLong("fireAtMillis"),
                        ),
                    )
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Unable to parse prayer notification payload", e)
            emptyList()
        }
    }

    private fun getPrefs(context: Context): android.content.SharedPreferences {
        val storageContext =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                context.createDeviceProtectedStorageContext()
            } else {
                context
            }

        return storageContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    private fun pendingIntentFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }

    fun scheduleTestPrayerNotification(context: Context, payload: String) {
        val entry = parseEntries(payload).firstOrNull() ?: return
        scheduleSingleTestNotification(context, entry)
    }

    private fun scheduleSingleTestNotification(
        context: Context,
        entry: PrayerNotificationEntry,
    ) {
        if (entry.fireAtMillis <= System.currentTimeMillis()) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            Log.w(TAG, "Exact alarm permission missing. Skipping test prayer notification")
            return
        }

        val pendingIntent = buildTestPendingIntent(context, entry)
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            entry.fireAtMillis,
            pendingIntent,
        )
    }

    private fun buildTestPendingIntent(
        context: Context,
        entry: PrayerNotificationEntry,
    ): PendingIntent {
        val intent = Intent(context, PrayerNotificationReceiver::class.java).apply {
            action = ACTION_TEST_FIRE
            putExtra(EXTRA_NOTIFICATION_ID, entry.id)
            putExtra(EXTRA_PRAYER_KEY, entry.prayerKey)
            putExtra(EXTRA_PRAYER_LABEL, entry.prayerLabel)
            putExtra(EXTRA_TITLE, entry.title)
            putExtra(EXTRA_BODY, entry.body)
            putExtra(EXTRA_FIRE_AT_MILLIS, entry.fireAtMillis)
        }

        return PendingIntent.getBroadcast(
            context,
            entry.id,
            intent,
            pendingIntentFlags(),
        )
    }

    private fun prayerLabelFromKey(prayerKey: String): String {
        return when (prayerKey.lowercase(Locale.US)) {
            "fajr" -> "الفجر"
            "dhuhr" -> "الظهر"
            "asr" -> "العصر"
            "maghrib" -> "المغرب"
            "isha" -> "العشاء"
            else -> prayerKey
        }
    }

    private fun formatReminderTime(fireAtMillis: Long): String {
        val locale = Locale("ar")
        val formatter = SimpleDateFormat("HH:mm", locale)
        return formatter.format(Date(fireAtMillis))
    }
}