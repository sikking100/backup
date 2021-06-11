import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

// void callbackDispatcher() {
//   Workmanager.executeTask((taskName, inputData) {
//     LocalNotification.initialize();
//     LocalNotification.showOneTimeNotification(DateTime.now());
//     return Future.value(true);
//   });
// }
//

class PublicController extends GetxController {
  RxBool isOpen = RxBool(false);
  Rx<LocationData> location = Rx(LocationData.fromMap(
    {'latitude': 0.0, 'longitude': 0.0, 'accuracy': 0.0, 'altitude': 0.0, 'speed': 0.0, 'speed_accuracy': 0.0, 'heading': 0.0, 'time': 0.0},
  ));
  Rx<Position> position = Rx<Position>(Position.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  }));

  @override
  void onInit() {
    super.onInit();

    location.bindStream(Location().onLocationChanged);
    position.bindStream(Geolocator.getPositionStream());
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(
      GetMaterialApp(
        initialBinding: BindingsBuilder.put(() => PublicController()),
        supportedLocales: [
          Locale("id", "ID"),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: MyHomePage(),
      ),
    );
    // await AndroidAlarmManager.periodic(duration, id, callback)
  } catch (e) {
    print(e);
  }
}

class MyHomePage extends GetView<PublicController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PublicController());
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Html(
            data:
                "<p>ada deskripsi, dan ada download <a href='http://facebook.com'>disini</a> , &nbsp;silahkan dicoba <strong>Sekarang!</strong></p>",
            onLinkTap: (url, context, attributes, element) {
              return launch(url);
            },
          ),
        ),
      ),
    );
  }
}
