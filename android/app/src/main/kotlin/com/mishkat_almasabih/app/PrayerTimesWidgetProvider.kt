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

class PrayerTimesWidgetProvider : AppWidgetProvider() {
    private val tag = "PrayerTimesWidget"

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            try {
                val widgetData = HomeWidgetPlugin.getData(context)
                val nextPrayerKey = widgetData.getString("prayer_next_key", "fajr") ?: "fajr"

                val views = RemoteViews(context.packageName, R.layout.prayer_times_widget).apply {
                    setTextViewText(
                        R.id.prayer_widget_hijri_date,
                        widgetData.getString("prayer_hijri_date", "١٨ ذو القعدة ١٤٤٧ هـ"),
                    )
                    setTextViewText(
                        R.id.prayer_widget_gregorian_date,
                        widgetData.getString("prayer_gregorian_date", "الثلاثاء، ٢٦ مايو ٢٠٢٦ م"),
                    )

                    setTextViewText(R.id.prayer_time_fajr, widgetData.getString("prayer_fajr", "--:--"))
                    setTextViewText(
                        R.id.prayer_time_sunrise,
                        widgetData.getString("prayer_sunrise", "--:--"),
                    )
                    setTextViewText(R.id.prayer_time_dhuhr, widgetData.getString("prayer_dhuhr", "--:--"))
                    setTextViewText(R.id.prayer_time_asr, widgetData.getString("prayer_asr", "--:--"))
                    setTextViewText(
                        R.id.prayer_time_maghrib,
                        widgetData.getString("prayer_maghrib", "--:--"),
                    )
                    setTextViewText(R.id.prayer_time_isha, widgetData.getString("prayer_isha", "--:--"))

                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_fajr,
                        labelId = R.id.prayer_label_fajr,
                        timeId = R.id.prayer_time_fajr,
                        isActive = nextPrayerKey == "fajr",
                    )
                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_sunrise,
                        labelId = R.id.prayer_label_sunrise,
                        timeId = R.id.prayer_time_sunrise,
                        isActive = nextPrayerKey == "sunrise",
                    )
                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_dhuhr,
                        labelId = R.id.prayer_label_dhuhr,
                        timeId = R.id.prayer_time_dhuhr,
                        isActive = nextPrayerKey == "dhuhr",
                    )
                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_asr,
                        labelId = R.id.prayer_label_asr,
                        timeId = R.id.prayer_time_asr,
                        isActive = nextPrayerKey == "asr",
                    )
                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_maghrib,
                        labelId = R.id.prayer_label_maghrib,
                        timeId = R.id.prayer_time_maghrib,
                        isActive = nextPrayerKey == "maghrib",
                    )
                    applyPrayerItemStyle(
                        views = this,
                        context = context,
                        itemId = R.id.prayer_item_isha,
                        labelId = R.id.prayer_label_isha,
                        timeId = R.id.prayer_time_isha,
                        isActive = nextPrayerKey == "isha",
                    )

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
            views.setTextColor(labelId, ContextCompat.getColor(context, R.color.prayer_widget_text_primary))
            views.setTextColor(timeId, ContextCompat.getColor(context, R.color.prayer_widget_text_primary))
        } else {
            views.setInt(itemId, "setBackgroundResource", R.drawable.prayer_time_item_default)
            views.setTextColor(labelId, ContextCompat.getColor(context, R.color.prayer_widget_text_secondary))
            views.setTextColor(timeId, ContextCompat.getColor(context, R.color.prayer_widget_text_primary))
        }
    }
}
