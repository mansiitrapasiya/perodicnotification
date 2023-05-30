// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:perodicnotification/helperr.dart';

// Future<void> createmyNotification(
//     NorificationWeekAndTime pickedSchedule) async {
//   await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//     id: createUniqueId(),
//     title: 'Take a deep breathe and have a faith !',
//     body: 'Get a life ',
//     notificationLayout: NotificationLayout.BigPicture,
//     channelKey: 'alerts',
//   ));
// }
 

// Future<void> createScheduleNotification() async {
//   final DateTime dateTime = DateTime.now().add(Duration(seconds: 10)).toLocal();

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: createUniqueId(),
//       title: 'Take a deep breathe and have a faith !',
//       body:
//           'Get a life ${DateFormat('dd/ MM/ yy   hh mm s ').format(dateTime)}',
//       channelKey: 'alerts',
//     ),
//     schedule: NotificationCalendar.fromDate(date: dateTime),
//   );

//  }




// import 'package:flutter/material.dart';

// int createUniqueId() {
//   return DateTime.now().microsecondsSinceEpoch.remainder(100000);
// }

// class NorificationWeekAndTime {
//   final int dayOftheWeek;
//   final TimeOfDay timeOfDay;
//   NorificationWeekAndTime(
//       {required this.dayOftheWeek, required this.timeOfDay});
// }
