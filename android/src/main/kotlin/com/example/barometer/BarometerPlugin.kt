package com.example.barometer

import android.content.Context
import android.content.Context.SENSOR_SERVICE
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.SoundPool
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BarometerPlugin */
class BarometerPlugin: FlutterPlugin, MethodCallHandler, SensorEventListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context;
  private lateinit var sensorManager: SensorManager
  private var mAccelerometer: Sensor? = null
  private var mLatestReading: Double = 0.0
  private var pressureChannel: EventChannel? = null
  private var pressureStreamHandler: StreamHandler? = null

  private fun getBarometer(): Double {
    return mLatestReading;
  }

  private fun initializeBarometer(): Boolean {
    sensorManager = context.getSystemService(SENSOR_SERVICE) as SensorManager
    mAccelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE)
    return sensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL)
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "barometer")
    channel.setMethodCallHandler(this)
    pressureChannel = EventChannel(flutterPluginBinding.binaryMessenger, "barometerEvent")
    pressureStreamHandler = StreamHandler(sensorManager, Sensor.TYPE_PRESSURE)
    pressureChannel?.setStreamHandler(pressureStreamHandler)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      return
    }

    if (call.method == "isSensorAvailable") {
      result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
      return
    }

    if (call.method == "getBarometer") {
//      throw IllegalArgumentException()
      var reading: Double = getBarometer()
      result.success(reading)
      return
    }

    if (call.method == "initializeBarometer") {
      result.success(initializeBarometer())
      return
    }

    if (call.method == "ringingTone") {
      SoundPoolManager.getInstance(context)?.playRinging()
      result.success(true);
      return
    }

    if (call.method == "stopTone") {
      SoundPoolManager.getInstance(context)?.stopRinging()
      result.success(true)
      return
    }

    return result.notImplemented();
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onSensorChanged(event: SensorEvent?) {
    if(event != null) {
      mLatestReading = event.values[0].toDouble()
    }
  }

  override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
  }
}
