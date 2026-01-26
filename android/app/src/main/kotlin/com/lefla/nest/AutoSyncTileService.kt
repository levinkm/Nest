package com.lefla.nest

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.util.Log

class AutoSyncTileService : TileService() {
    private val TAG = "NestFinance"
    private val PREFS_NAME = "nest_settings"
    private val AUTO_SYNC_KEY = "auto_sync_enabled"

    override fun onStartListening() {
        super.onStartListening()
        updateTile()
    }

    override fun onClick() {
        super.onClick()
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val currentState = prefs.getBoolean(AUTO_SYNC_KEY, true)
        val newState = !currentState
        
        prefs.edit().putBoolean(AUTO_SYNC_KEY, newState).apply()
        
        // Enable/disable SMS receiver
        val receiver = ComponentName(this, SmsReceiver::class.java)
        packageManager.setComponentEnabledSetting(
            receiver,
            if (newState) PackageManager.COMPONENT_ENABLED_STATE_ENABLED 
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
        
        Log.d(TAG, "Auto-sync ${if (newState) "enabled" else "disabled"}")
        updateTile()
    }

    private fun updateTile() {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val isEnabled = prefs.getBoolean(AUTO_SYNC_KEY, true)
        
        qsTile?.apply {
            state = if (isEnabled) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
            label = "Auto Sync"
            subtitle = if (isEnabled) "ON" else "OFF"
            updateTile()
        }
    }
}
