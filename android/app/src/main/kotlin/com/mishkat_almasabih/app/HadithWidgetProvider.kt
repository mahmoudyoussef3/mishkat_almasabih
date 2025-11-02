package com.mishkat_almasabih.app


import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.util.Log // Import for logging

class HadithWidgetProvider : AppWidgetProvider() {
    private val TAG = "HadithWidgetProvider" // Tag for logging

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate: Widget update initiated.")
        for (appWidgetId in appWidgetIds) {
            try {
                val views = RemoteViews(context.packageName, R.layout.hadith_widget).apply {
                    val widgetData = HomeWidgetPlugin.getData(context)

                    val hadithText = widgetData.getString("hadith_text", "إنما الأعمال بالنيات")
                    Log.d(TAG, "onUpdate: Retrieved hadithText: $hadithText")

                    setTextViewText(R.id.hadith_text, hadithText)
                }
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.d(TAG, "onUpdate: Widget $appWidgetId updated successfully.")
            } catch (e: Exception) {
                Log.e(TAG, "onUpdate: Error updating widget $appWidgetId: ${e.message}", e)
            }
        }
    }
}