import 'package:alarm_app/utils/alarm_fields.dart';

//
class AlarmModel {
  int? id;
  String title;
  DateTime alarmDateTime;
  bool isActive;

  AlarmModel({
    this.id,
    required this.title,
    required this.isActive,
    required this.alarmDateTime,
  });

  AlarmModel copy({
    int? id,
    String? title,
    bool? isActive,
    DateTime? alarmDateTime,
  }) =>
      AlarmModel(
        id: id ?? this.id,
        title: title ?? this.title,
        alarmDateTime: alarmDateTime ?? this.alarmDateTime,
        isActive: isActive ?? this.isActive,
      );

  static AlarmModel fromJson(Map<String, Object?> json) => AlarmModel(
        id: json[AlarmFields.id] as int?,
        isActive: json[AlarmFields.isActive] == 1,
        title: json[AlarmFields.title] as String,
        alarmDateTime:
            DateTime.parse(json[AlarmFields.alarmDateTime] as String),
      );

  Map<String, Object?> toJson() => {
        AlarmFields.id: id,
        AlarmFields.title: title,
        AlarmFields.isActive: isActive ? 1 : 0,
        AlarmFields.alarmDateTime: alarmDateTime.toIso8601String(),
      };
}
// class AlarmModel {
//   int? id;
//   String title;
//   TimeOfDay alarmTime;
//   bool isActive;
//
//   AlarmModel({
//     this.id,
//     required this.title,
//     required this.isActive,
//     required this.alarmTime,
//   });
//
//   AlarmModel copy({
//     int? id,
//     String? title,
//     bool? isActive,
//     TimeOfDay? alarmTime,
//   }) =>
//       AlarmModel(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         alarmTime: alarmTime ?? this.alarmTime,
//         isActive: isActive ?? this.isActive,
//       );
//
//   static AlarmModel fromJson(Map<String, Object?> json) => AlarmModel(
//         id: json[AlarmFields.id] as int?,
//         isActive: json[AlarmFields.isActive] == 1,
//         title: json[AlarmFields.title] as String,
//         alarmTime: TimeOfDay.fromDateTime(
//           DateTime.parse(json[AlarmFields.alarmDateTime] as String),
//         ),
//       );
//
//   Map<String, Object?> toJson() => {
//         AlarmFields.id: id,
//         AlarmFields.title: title,
//         AlarmFields.isActive: isActive ? 1 : 0,
//         AlarmFields.alarmDateTime: DateTime(
//           DateTime.now().year,
//           DateTime.now().month,
//           DateTime.now().day,
//           alarmTime.hour,
//           alarmTime.minute,
//         ).toIso8601String(),
//       };
// }
