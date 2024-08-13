package com.example.sleer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

import id.flutter.flutter_background_service.BackgroundService

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent?.action) {
            val serviceIntent = Intent(context, BackgroundService::class.java)
            context?.startForegroundService(serviceIntent)
            Log.d("BootReceiver", "Service started on boot.")
        }
    }
}
