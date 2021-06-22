import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

final MethodChannel methodChannel = MethodChannel("com.example.localnotif/local");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  log("inimi");
  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
  final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final settings = InitializationSettings(android: android);
  flip.initialize(settings);
  await methodChannel.invokeMethod("ringing");
  await methodChannel.invokeMethod("vibrate");
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
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.instance.getToken().then((value) => print(value));
    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    // FirebaseMessaging.onMessage.listen((event) async {
    //   await methodChannel.invokeMethod('ringing');
    //   await methodChannel.invokeMethod('vibrate');
    //   log("onResume");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.orange,
          child: Center(
            child: TextButton(
              onPressed: () async {
                try {
                  final url = "https://wa.me/+6285213978468";
                  if (await canLaunch(url)) {
                    await launch(url);
                    return;
                  }
                } catch (e) {
                  print(e);
                  log(e.toString());
                  // dialogError(e.toString());
                  // logger.info(e.toString());
                  return;
                }
              },
              child: Text("Tes"),
            ),
          ),
        ),
      ),
    );
  }
}
