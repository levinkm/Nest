package com.lefla.nest

import android.content.Context
import android.content.Intent
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.util.Log
import android.widget.Toast

class ManualSyncTileService : TileService() {
    private val TAG = "NestFinance"
    private val PREFS_NAME = "nest_settings"
    private val LAST_SYNC_KEY = "last_manual_sync"

    override fun onStartListening() {
        super.onStartListening()
        updateTile()
    }

    override fun onClick() {
        super.onClick()
        
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val lastSync = prefs.getLong(LAST_SYNC_KEY, 0L)
        val now = System.currentTimeMillis()
        val oneDayMs = 24 * 60 * 60 * 1000L
        
        if (now - lastSync < oneDayMs) {
            Toast.makeText(this, "Already synced today", Toast.LENGTH_SHORT).show()
            return
        }
        
        // Trigger manual sync
        Log.d(TAG, "Manual sync triggered from Quick Settings")
        val intent = Intent(this, MainActivity::class.java).apply {
            action = "MANUAL_SYNC"
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
        
        prefs.edit().putLong(LAST_SYNC_KEY, now).apply()
        Toast.makeText(this, "Syncing messages...", Toast.LENGTH_SHORT).show()
        updateTile()
    }

    private fun updateTile() {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val lastSync = prefs.getLong(LAST_SYNC_KEY, 0L)
        val now = System.currentTimeMillis()
        val oneDayMs = 24 * 60 * 60 * 1000L
        val canSync = (now - lastSync) >= oneDayMs
        
        qsTile?.apply {
            state = if (canSync) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
            label = "Daily Sync"
            subtitle = if (canSync) "Available" else "Synced"
            icon = android.graphics.drawable.Icon.createWithResource(applicationContext, android.R.drawable.ic_popup_sync)
            updateTile()
        }
    }
}
