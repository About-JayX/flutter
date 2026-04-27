package com.wakme.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class MainActivity : FlutterActivity() {

    private val CHANNEL = "mobisen_app.android/notification"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.let { engine ->
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "createNotificationChannel" -> {
                        val channelId = call.argument<String>("channelId")!!
                        val channelName = call.argument<String>("channelName")!!
                        val importance = call.argument<Int>("importance") ?: NotificationManager.IMPORTANCE_DEFAULT
                        createNotificationChannel(channelId, channelName, importance)
                        result.success(null)
                    }
                    "createMultipleNotificationChannels" -> {
                        val channels = call.argument<List<Map<String, Any>>>("channels") ?: listOf()
                        createMultipleNotificationChannels(channels)
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel("default_channel", "Default Channel", NotificationManager.IMPORTANCE_DEFAULT)
        }
    }

    private fun createNotificationChannel(channelId: String, channelName: String, importance: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, channelName, importance)
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createMultipleNotificationChannels(channels: List<Map<String, Any>>) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            for (channelInfo in channels) {
                val channelId = channelInfo["channelId"] as String
                val channelName = channelInfo["channelName"] as String
                val importance = channelInfo["importance"] as Int
                createNotificationChannel(channelId, channelName, importance)
            }
        }
    }
}