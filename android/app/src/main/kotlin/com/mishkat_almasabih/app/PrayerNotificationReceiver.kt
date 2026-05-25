package com.mishkat_almasabih.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class PrayerNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val notificationId = intent.getIntExtra(
            PrayerNotificationScheduler.EXTRA_NOTIFICATION_ID,
            -1,
        )
        if (notificationId == -1) return

        val prayerKey = intent.getStringExtra(PrayerNotificationScheduler.EXTRA_PRAYER_KEY)
            ?: return
        val title = intent.getStringExtra(PrayerNotificationScheduler.EXTRA_TITLE) ?: return
        val body = intent.getStringExtra(PrayerNotificationScheduler.EXTRA_BODY) ?: return

        PrayerNotificationScheduler.showPrayerNotification(
            context,
            PrayerNotificationEntry(
                id = notificationId,
                prayerKey = prayerKey,
                title = title,
                body = body,
                fireAtMillis = System.currentTimeMillis(),
            ),
        )
        if (intent.action != "com.mishkat_almasabih.app.action.PRAYER_NOTIFICATION_TEST") {
            PrayerNotificationScheduler.removeFiredPrayerNotification(context, notificationId)
        }
    }
}