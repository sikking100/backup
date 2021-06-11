import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:barometer/barometer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _reading = 0.0;
  int _isAvail = 1;
  StreamSubscription _streamSubscription;

  void _startReading() {
    _streamSubscription = Barometer.startReading.listen((event) {
      setState(() {
        _reading = event;
      });
    });
  }

  void _stopReading() {
    setState(() {
      _reading = 0.0;
    });
    _streamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await Barometer.initialize();

      return;
    } on PlatformException catch (e) {
      log(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('isSound ready: $_isAvail\n'),
              // TextButton(
              //   onPressed: () async {
              //     final isAvail = await Barometer.initSound();
              //     setState(() {
              //       _isAvail = isAvail;
              //     });
              //   },
              //   child: Text("Check Availibility"),
              // ),
              Text('Latest reading: $_reading\n'),
              _reading == 0.0
                  ? TextButton(
                      onPressed: () async {
                        final read = await Barometer.reading;
                        setState(() {
                          _reading = read;
                        });
                      },
                      child: Text("Start Reading"),
                    )
                  : TextButton(
                      onPressed: () async {
                        final read = await Barometer.reading;
                        setState(() {
                          _reading = read;
                        });
                      },
                      child: Text("Stop Reading"),
                    ),
              SizedBox(height: 50),
              Text("Ringtone"),
              TextButton(
                onPressed: () async {
                  await Barometer.starttRinging;
                  return;
                },
                child: Text("Start Ringtone"),
              ),
              TextButton(
                onPressed: () async {
                  await Barometer.stopRinging;
                  return;
                },
                child: Text("Start Ringtone"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
