package com.example.ex_money

import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "navigation_mode"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getNavigationMode") {
                result.success(getNavigationMode())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getNavigationMode(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val gestureEnabled = Settings.Secure.getInt(contentResolver, "navigation_mode", 0)
            if (gestureEnabled == 2) "gesture" else "button"
        } else {
            "button" // Pre-Android 10 defaults to button navigation
        }
    }

}
