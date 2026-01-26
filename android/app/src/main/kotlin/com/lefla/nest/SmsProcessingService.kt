package com.lefla.nest

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class SmsProcessingService : Service() {
    private val TAG = "NestFinance"

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val body = intent?.getStringExtra("body") ?: ""
        val address = intent?.getStringExtra("address") ?: ""
        val timestamp = intent?.getLongExtra("timestamp", 0L) ?: 0L

        Log.d(TAG, "Processing SMS in background service")
        
        // Send to Flutter via MethodChannel
        val messenger = (application as? FlutterApplication)?.flutterEngine?.dartExecutor?.binaryMessenger
        if (messenger != null) {
            val channel = MethodChannel(messenger, "com.nest.finance/sms_events")
            channel.invokeMethod("onSmsReceived", mapOf(
                "body" to body,
                "address" to address,
                "timestamp" to timestamp
            ))
        }

        stopSelf(startId)
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
