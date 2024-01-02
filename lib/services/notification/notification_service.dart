import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  //instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission()async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');
    }else{
      print('User denied permission');
    }
  }

  Future<String> getDeviceToken() async{
    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken ?? '';
  }

  void isTokenRefresh() async{
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitialization = const AndroidInitializationSettings('@mipmap-hdpi/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();
      var initializationSetting = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitializationSettings
      );
      await _notificationPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){

      }
    );
  }

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode){
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      showNotification(message);
    });
    
  }

  Future<void> showNotification(RemoteMessage message)async{
    final randomNumber = Random.secure().nextInt(100000);
    final channelId = DateTime.now().millisecondsSinceEpoch.toString() + (randomNumber ?? 0).toString();

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      'High Importance Notifications',
      importance: Importance.max
    );
    print('id: ${channel.id.toString()}');
    print('name: ${channel.name.toString()}');

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(), 
      channel.name.toString(),
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );
    
    Future.delayed(
      Duration.zero, (){
        print('Showing notification');
        _notificationPlugin.show(
          1, 
          message.notification!.title.toString(), 
          message.notification!.body.toString(), 
          notificationDetails
        );
      }
    );
  }


  //initialize the notification with token of the user
  Future<String> initNotifications() async{
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken ?? '';
  }

  //handle the received messages
  void handleMessage(RemoteMessage? message){
    if(message == null) return;

  }

  //initialize foreground and background settings
  
  //handle notification in background or killer mode
  Future<void> backGroundHandler (RemoteMessage message) async{
    print('Handling a background message ${message.messageId}');
  }


}