package com.example.localnotif

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME: String = "com.example.localnotif/local"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        register(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    private fun register(context: Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method){
                "ringing" -> {
                    SoundPoolManager.getInitialize(context)?.playRinging()
                    result.success(true)
                }
                "stopRing" -> {
                    SoundPoolManager.getInitialize(context)?.stopRinging()
                }
                "vibrate" -> {
                    Vibrators.getInitialize(context)?.vibrating()
                }
                "stopVibrate" -> {
                    Vibrators.getInitialize(context)?.stopVibrating()
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        methodChannel?.setMethodCallHandler(null)
    }
}
