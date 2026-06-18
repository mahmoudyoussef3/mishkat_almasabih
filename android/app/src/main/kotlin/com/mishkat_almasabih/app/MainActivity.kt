package com.mishkat_almasabih.app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mishkat_almasabih.app/widget"
    private val PRAYER_CHANNEL = "com.mishkat_almasabih.app/prayer_notifications"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PRAYER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "schedulePrayerNotifications" -> {
                        val payload = call.arguments as? String
                        if (payload.isNullOrBlank()) {
                            result.error(
                                "invalid_arguments",
                                "Missing prayer schedule payload",
                                null,
                            )
                            return@setMethodCallHandler
                        }

                        PrayerNotificationScheduler.schedulePrayerNotifications(
                            applicationContext,
                            payload,
                        )
                        result.success(true)
                    }

                    "cancelPrayerNotifications" -> {
                        PrayerNotificationScheduler.cancelPrayerNotifications(applicationContext)
                        result.success(true)
                    }

                    "scheduleTestPrayerNotification" -> {
                        val payload = call.arguments as? String
                        if (payload.isNullOrBlank()) {
                            result.error(
                                "invalid_arguments",
                                "Missing test prayer notification payload",
                                null,
                            )
                            return@setMethodCallHandler
                        }

                        PrayerNotificationScheduler.scheduleTestPrayerNotification(
                            applicationContext,
                            payload,
                        )
                        result.success(true)
                    }

                    "hasExactAlarmPermission" -> {
                        result.success(
                            PrayerNotificationScheduler.hasExactAlarmPermission(applicationContext),
                        )
                    }

                    "requestExactAlarmPermission" -> {
                        if (PrayerNotificationScheduler.hasExactAlarmPermission(applicationContext)) {
                            result.success(true)
                        } else {
                            startActivity(
                                PrayerNotificationScheduler.buildExactAlarmPermissionIntent(
                                    applicationContext,
                                ).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) },
                            )
                            result.success(false)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
        
        // Handle the initial intent when app is launched from widget
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        intent?.let {
            val openScreen = it.getStringExtra("open_screen")
            val fromWidget = it.getBooleanExtra("from_widget", false)

            // Handle widget tap navigation
            if (fromWidget && openScreen == "hadith_of_the_day") {
                methodChannel?.invokeMethod("openHadithOfTheDay", null)
            }

            if (fromWidget && openScreen == "prayer_times") {
                methodChannel?.invokeMethod("openPrayerTimes", null)
            }

            // Handle deep links like mishkat://hadith?... via intent.data
            val dataUri = it.data
            if (dataUri != null && dataUri.scheme == "mishkat" && dataUri.host == "hadith") {
                methodChannel?.invokeMethod("openHadithLink", dataUri.toString())
            }
        }
    }
}
