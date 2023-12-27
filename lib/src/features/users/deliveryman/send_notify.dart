// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// //!local notification only / cannot send the notification to specific user
// class SendNoti {
//   static Future initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize =
//         new AndroidInitializationSettings("mipmap/ic_launcher");
//     //var iOSInitialize = new IOSInitializationSettings();
//     var initializationSettings = new InitializationSettings(
//       android: androidInitialize,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static Future showBigTextNotification(
//       {var id = 0,
//       required String title,
//       required String body,
//       //required String image,
//       var payload,
//       required FlutterLocalNotificationsPlugin fln}) async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         new AndroidNotificationDetails(
//       "Notify_Order_Reached",
//       "channel_Name",
//       playSound: true,
//       //icon: "ic_notification",
//       //sound: RawResourceAndroidNotificationSound('notification'),
//       importance: Importance.max,
//       priority: Priority.high,
//       enableVibration: true,
//     );

//     var not = NotificationDetails(android: androidPlatformChannelSpecifics);
//     //
//     await fln.show(0, title, body, not);
//   }
// }
