package com.lefla.nest

import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nest.finance/sms"
    private val TAG = "NestFinance"
    private val SMS_PERMISSION_CODE = 100
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        (application as? FlutterApplication)?.flutterEngine = flutterEngine
        
        // Handle manual sync from Quick Settings
        if (intent?.action == "MANUAL_SYNC") {
            Log.d(TAG, "Manual sync triggered from Quick Settings")
        }
        
        Log.d(TAG, "Configuring Flutter engine")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d(TAG, "Method called: ${call.method}")
            when (call.method) {
                "getInboxSms" -> {
                    val daysBack = call.argument<Int>("daysBack") ?: 30
                    if (checkAndRequestPermission()) {
                        val messages = getInboxSms(daysBack)
                        Log.d(TAG, "Returning ${messages.size} messages")
                        result.success(messages)
                    } else {
                        pendingResult = result
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkAndRequestPermission(): Boolean {
        Log.d(TAG, "Checking SMS permission")
        return if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "SMS permission not granted, requesting...")
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS), SMS_PERMISSION_CODE)
            false
        } else {
            true
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(TAG, "SMS permission granted")
                pendingResult?.let {
                    val messages = getInboxSms(30)
                    Log.d(TAG, "Returning ${messages.size} messages after permission grant")
                    it.success(messages)
                    pendingResult = null
                }
            } else {
                Log.w(TAG, "SMS permission denied")
                pendingResult?.success(emptyList<Map<String, Any>>())
                pendingResult = null
            }
        }
    }

    private fun getInboxSms(daysBack: Int): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "SMS permission not granted")
            return messages
        }

        val cutoffTime = System.currentTimeMillis() - (daysBack * 24 * 60 * 60 * 1000L)
        Log.d(TAG, "Querying SMS inbox for last $daysBack days")
        
        val cursor = contentResolver.query(
            Uri.parse("content://sms/inbox"),
            arrayOf("_id", "address", "body", "date"),
            "date >= ?",
            arrayOf(cutoffTime.toString()),
            "date DESC"
        )

        cursor?.use {
            val bodyIndex = it.getColumnIndex("body")
            val dateIndex = it.getColumnIndex("date")
            val addressIndex = it.getColumnIndex("address")
            Log.d(TAG, "Cursor count: ${it.count}")

            while (it.moveToNext()) {
                val body = if (bodyIndex >= 0) it.getString(bodyIndex) else ""
                val date = if (dateIndex >= 0) it.getLong(dateIndex) else 0L
                val address = if (addressIndex >= 0) it.getString(addressIndex) else ""

                messages.add(mapOf(
                    "body" to body,
                    "date" to date,
                    "address" to address
                ))
            }
        } ?: Log.e(TAG, "Cursor is null")

        Log.d(TAG, "Parsed ${messages.size} messages")
        return messages
    }
}
