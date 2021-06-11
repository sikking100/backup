import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localnotif/page.dart';

void main() async {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  log("inimi");
  if (message.containsKey('data')) {
    // Handle data message
    // final dynamic data = message['data'];
    log(message['data']['status'], name: "backgroun data");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    log(notification, name: "backgroun notif");
  }
  // Navigator.push(context, MaterialPageRoute(builder: (context) => PageData()));

  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
  final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final settings = InitializationSettings(android: android);
  flip.initialize(settings);
  await _showNotificationWithDefaultSound(flip);
  return Future.value(true);
  // Or do other work.
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high);

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flip.show(1, 'GeeksforGeeks', 'Your are one step away to connect with GeeksforGeeks', platformChannelSpecifics, payload: 'Default_Sound');
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (message) async {
        log(message["notification"]["body"], name: "onMessage notif");
      },
      onResume: (message) {
        log("onResume");
        Navigator.push(context, MaterialPageRoute(builder: (context) => PageData()));

        return;
      },
      onLaunch: (message) {
        log("onLaunch");
        Navigator.push(context, MaterialPageRoute(builder: (context) => PageData()));

        return;
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );

    _fcm.getToken().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.orange,
          child: Image.asset("assets/sp.gif"),
        ),
      ),
    );
  }
}
