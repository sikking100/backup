import 'package:meta/meta.dart';
import 'dart:convert';

ModelAlarm modelAlarmFromMap(String str) => ModelAlarm.fromMap(json.decode(str));

String modelAlarmToMap(ModelAlarm data) => json.encode(data.toMap());

class ModelAlarm {
  ModelAlarm({
    @required this.monday,
    @required this.tuesday,
    @required this.wednesday,
    @required this.thursday,
    @required this.friday,
    @required this.saturday,
    @required this.sunday,
  });

  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;
  Day sunday;

  factory ModelAlarm.fromMap(Map<String, dynamic> json) => ModelAlarm(
        monday: Day.fromMap(json["monday"]),
        tuesday: Day.fromMap(json["tuesday"]),
        wednesday: Day.fromMap(json["wednesday"]),
        thursday: Day.fromMap(json["thursday"]),
        friday: Day.fromMap(json["friday"]),
        saturday: Day.fromMap(json["saturday"]),
        sunday: Day.fromMap(json["sunday"]),
      );

  Map<String, dynamic> toMap() => {
        "monday": monday.toMap(),
        "tuesday": tuesday.toMap(),
        "wednesday": wednesday.toMap(),
        "thursday": thursday.toMap(),
        "friday": friday.toMap(),
        "saturday": saturday.toMap(),
        "sunday": sunday.toMap(),
      };

  static ModelAlarm get def =>
      ModelAlarm(monday: Day.def, tuesday: Day.def, wednesday: Day.def, thursday: Day.def, friday: Day.def, saturday: Day.def, sunday: Day.def);
}

class Day {
  Day({
    @required this.open,
    @required this.close,
    @required this.active,
  });

  DateTime open;
  DateTime close;
  bool active;

  factory Day.fromMap(Map<String, dynamic> json) => Day(
        open: DateTime.parse(json["open"]),
        close: DateTime.parse(json["close"]),
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "open": open.toIso8601String(),
        "close": close.toIso8601String(),
        "active": active,
      };

  static Day get def => Day(open: DateTime.now(), close: DateTime.now(), active: false);
}
