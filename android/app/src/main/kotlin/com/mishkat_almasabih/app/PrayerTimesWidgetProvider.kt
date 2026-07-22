package com.mishkat_almasabih.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin
import android.os.Bundle

class PrayerTimesWidgetProvider : AppWidgetProvider() {
    private val tag = "PrayerTimesWidget"

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidgetView(context, appWidgetManager, appWidgetId, null)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle?
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        updateWidgetView(context, appWidgetManager, appWidgetId, newOptions)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)
            if (appWidgetIds != null) {
                for (appWidgetId in appWidgetIds) {
                    updateWidgetView(context, appWidgetManager, appWidgetId, null)
                }
            } else {
                val componentName = android.content.ComponentName(context, PrayerTimesWidgetProvider::class.java)
                val allWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                for (appWidgetId in allWidgetIds) {
                    updateWidgetView(context, appWidgetManager, appWidgetId, null)
                }
            }
        }
    }

    private fun updateWidgetView(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        options: Bundle?
    ) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            
            val now = System.currentTimeMillis()
            val todayStart = startOfDayMillis(now)
            val savedDayMillis = widgetData.getLong("prayer_widget_day_millis", 0)
            val useTomorrowData = savedDayMillis > 0 && todayStart > savedDayMillis
            val keyPrefix = if (useTomorrowData) "prayer_tomorrow" else "prayer"
            val hijriDateKey = if (useTomorrowData) "prayer_tomorrow_hijri_date" else "prayer_hijri_date"
            val gregorianDateKey = if (useTomorrowData) "prayer_tomorrow_gregorian_date" else "prayer_gregorian_date"
            val prayers = listOf(
                Pair("fajr", widgetData.getLong("${keyPrefix}_fajr_millis", 0)),
                Pair("sunrise", widgetData.getLong("${keyPrefix}_sunrise_millis", 0)),
                Pair("dhuhr", widgetData.getLong("${keyPrefix}_dhuhr_millis", 0)),
                Pair("asr", widgetData.getLong("${keyPrefix}_asr_millis", 0)),
                Pair("maghrib", widgetData.getLong("${keyPrefix}_maghrib_millis", 0)),
                Pair("isha", widgetData.getLong("${keyPrefix}_isha_millis", 0))
            )

            var nextPrayerKey = "fajr"
            var nextPrayerMillis = widgetData.getLong("prayer_tomorrow_fajr_millis", 0)

            for (prayer in prayers) {
                if (prayer.second > now) {
                    nextPrayerKey = prayer.first
                    nextPrayerMillis = prayer.second
                    break
                }
            }

            if (nextPrayerMillis > now) {
                scheduleWidgetUpdate(context, nextPrayerMillis + 1000, 10)
            }
            scheduleWidgetUpdate(context, nextMidnightMillis(now) + 1000, 11)

            val opts = options ?: appWidgetManager.getAppWidgetOptions(appWidgetId)
            val width = opts.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 300)

            val layoutId = when {
                width < 200 -> R.layout.prayer_times_widget_small
                width < 280 -> R.layout.prayer_times_widget_medium
                else -> R.layout.prayer_times_widget
            }

            val views = RemoteViews(context.packageName, layoutId).apply {
                setTextViewText(
                    R.id.prayer_widget_hijri_date,
                    widgetData.getString(hijriDateKey, "١٨ ذو القعدة ١٤٤٧ هـ"),
                )
                setTextViewText(
                    R.id.prayer_widget_gregorian_date,
                    widgetData.getString(gregorianDateKey, "الثلاثاء، ٢٦ مايو ٢٠٢٦ م"),
                )

                setTextViewText(R.id.prayer_time_fajr, widgetData.getString("${keyPrefix}_fajr", "--:--"))
                setTextViewText(
                    R.id.prayer_time_sunrise,
                    widgetData.getString("${keyPrefix}_sunrise", "--:--"),
                )
                setTextViewText(R.id.prayer_time_dhuhr, widgetData.getString("${keyPrefix}_dhuhr", "--:--"))
                setTextViewText(R.id.prayer_time_asr, widgetData.getString("${keyPrefix}_asr", "--:--"))
                setTextViewText(
                    R.id.prayer_time_maghrib,
                    widgetData.getString("${keyPrefix}_maghrib", "--:--"),
                )
                setTextViewText(R.id.prayer_time_isha, widgetData.getString("${keyPrefix}_isha", "--:--"))

                applyPrayerItemStyle(this, context, R.id.prayer_item_fajr, R.id.prayer_label_fajr, R.id.prayer_time_fajr, nextPrayerKey == "fajr")
                applyPrayerItemStyle(this, context, R.id.prayer_item_sunrise, R.id.prayer_label_sunrise, R.id.prayer_time_sunrise, nextPrayerKey == "sunrise")
                applyPrayerItemStyle(this, context, R.id.prayer_item_dhuhr, R.id.prayer_label_dhuhr, R.id.prayer_time_dhuhr, nextPrayerKey == "dhuhr")
                applyPrayerItemStyle(this, context, R.id.prayer_item_asr, R.id.prayer_label_asr, R.id.prayer_time_asr, nextPrayerKey == "asr")
                applyPrayerItemStyle(this, context, R.id.prayer_item_maghrib, R.id.prayer_label_maghrib, R.id.prayer_time_maghrib, nextPrayerKey == "maghrib")
                applyPrayerItemStyle(this, context, R.id.prayer_item_isha, R.id.prayer_label_isha, R.id.prayer_time_isha, nextPrayerKey == "isha")

                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("open_screen", "prayer_times")
                    putExtra("from_widget", true)
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    appWidgetId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                setOnClickPendingIntent(R.id.prayer_widget_root, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: Exception) {
            Log.e(tag, "Failed to update prayer widget $appWidgetId", e)
        }
    }

    private fun scheduleWidgetUpdate(context: Context, updateTimeMillis: Long, requestCode: Int) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        val intent = Intent(context, PrayerTimesWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        try {
            alarmManager.setExactAndAllowWhileIdle(
                android.app.AlarmManager.RTC_WAKEUP,
                updateTimeMillis,
                pendingIntent
            )
        } catch (e: SecurityException) {
            alarmManager.set(
                android.app.AlarmManager.RTC_WAKEUP,
                updateTimeMillis,
                pendingIntent
            )
        }
    }

    private fun startOfDayMillis(timeMillis: Long): Long {
        val calendar = java.util.Calendar.getInstance().apply {
            timeInMillis = timeMillis
            set(java.util.Calendar.HOUR_OF_DAY, 0)
            set(java.util.Calendar.MINUTE, 0)
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }
        return calendar.timeInMillis
    }

    private fun nextMidnightMillis(timeMillis: Long): Long {
        val calendar = java.util.Calendar.getInstance().apply {
            timeInMillis = timeMillis
            add(java.util.Calendar.DAY_OF_YEAR, 1)
            set(java.util.Calendar.HOUR_OF_DAY, 0)
            set(java.util.Calendar.MINUTE, 0)
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }
        return calendar.timeInMillis
    }

    private fun applyPrayerItemStyle(
        views: RemoteViews,
        context: Context,
        itemId: Int,
        labelId: Int,
        timeId: Int,
        isActive: Boolean,
    ) {
        if (isActive) {
            views.setInt(itemId, "setBackgroundResource", R.drawable.prayer_time_item_active)
            views.setTextColor(labelId, ContextCompat.getColor(context, R.color.prayer_widget_accent))
            views.setTextColor(timeId, ContextCompat.getColor(context, R.color.prayer_widget_accent))
        } else {
            views.setInt(itemId, "setBackgroundResource", R.drawable.prayer_time_item_default)
            views.setTextColor(labelId, ContextCompat.getColor(context, R.color.prayer_widget_text_secondary))
            views.setTextColor(timeId, ContextCompat.getColor(context, R.color.prayer_widget_text_primary))
        }
    }
}
