import 'dart:async';

import 'package:flutter/services.dart';

class Barometer {
  static const MethodChannel _channel = const MethodChannel('barometer');
  static const EventChannel _eventChannel = const EventChannel('barometerEvent');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<double> get reading async {
    final double reading = await _channel.invokeMethod("getBarometer");
    return reading;
  }

  static Future<bool> initialize() async {
    return await _channel.invokeMethod("initializeBarometer");
  }

  static Future<bool> get checkAvailibility async {
    return await _channel.invokeMethod('isSensorAvailable');
  }

  static Stream get startReading {
    return _eventChannel.receiveBroadcastStream();
  }

  static Future<bool> get starttRinging async {
    final bool result = await _channel.invokeMethod('ringingTone');
    return result;
  }

  static Future<bool> get stopRinging async {
    final bool result = await _channel.invokeMethod('stopTone');
    return result;
  }
}
