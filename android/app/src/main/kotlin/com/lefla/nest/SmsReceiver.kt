package com.lefla.nest

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    private val TAG = "NestFinance"

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            // Check if auto-sync is enabled
            val prefs = context.getSharedPreferences("nest_settings", Context.MODE_PRIVATE)
            val autoSyncEnabled = prefs.getBoolean("auto_sync_enabled", true)
            
            if (!autoSyncEnabled) {
                Log.d(TAG, "Auto-sync disabled, ignoring SMS")
                return
            }
            
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            
            for (smsMessage in messages) {
                val body = smsMessage.messageBody
                val address = smsMessage.originatingAddress
                val timestamp = smsMessage.timestampMillis
                
                Log.d(TAG, "SMS received from $address: $body")
                
                if (isTransactionSms(body)) {
                    Log.d(TAG, "Transaction SMS detected, processing...")
                    val serviceIntent = Intent(context, SmsProcessingService::class.java).apply {
                        putExtra("body", body)
                        putExtra("address", address)
                        putExtra("timestamp", timestamp)
                    }
                    context.startService(serviceIntent)
                }
            }
        }
    }

    private fun isTransactionSms(body: String): Boolean {
        val keywords = listOf(
            // Mobile Money
            "m-pesa", "mpesa", "sent to", "received from", "paybill", "buy goods",
            "withdraw", "deposit", "airtel money", "t-kash", "fuliza",
            // Banking
            "debited", "credited", "paid", "received",
            // Currency
            "ksh", "kes", "rs", "inr", "₹"
        )
        return keywords.any { body.lowercase().contains(it) }
    }
}
