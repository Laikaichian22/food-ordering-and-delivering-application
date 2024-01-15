import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/screens/login/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  // void initialize(BuildContext context, RemoteMessage message){
  //   const InitializationSettings initializationSettings = InitializationSettings(
  //     android: AndroidInitializationSettings('@mipmap/ic_launcher')
  //   );

  //   _flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     //when tapping notification at the moment the notification show up in foreground
  //     onDidReceiveNotificationResponse: (payload){
  //       handleMessage(context, message);
  //     }
  //   );
  // }

  // void display(RemoteMessage message)async{
  //   try {
  //     final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      
  //     AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       Random.secure().nextInt(100000).toString(),  
  //       'High Importance Notification',
  //       importance: Importance.max
  //     );
      
      
  //     final notificationDetails = NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id.toString(), 
  //         channel.name.toString(),
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       )
  //     );
      
  //     await _flutterLocalNotificationsPlugin.show(
  //       id, 
  //       message.notification!.title, 
  //       message.notification!.body, 
  //       notificationDetails,
  //       payload: message.data['type'],
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }



  //---------------------------------------------------------------------------------------------------------------------
  
  //handle the initialization of notification and also showing the notification bar in foreground
  void firebaseInitNotification(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
        
      initLocalNotification(context, message);
      showNotification(message);
    });
  }
  
  //move to login page when user click on it
  void handleMessage(BuildContext context, RemoteMessage message){
    if(message.data['type'] == 'login'){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const LoginPage()
        )
      );
    }
  }

  //when app is terminated, does not showing notification bar!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Future<void> setupInteractMessage(BuildContext context) async{
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
      showNotification(initialMessage);
    }

    //when app in background, does not showing notification bar!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    FirebaseMessaging.onMessageOpenedApp.listen((message){
      handleMessage(context, message);
      showNotification(message);
    });
  }

  void initLocalNotification(BuildContext context, RemoteMessage message)async{
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    
    var initializationSetting = InitializationSettings(
      android: androidInitialization,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(context, message);
      }
    );
  }

  Future<void> showNotification(RemoteMessage message)async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),  
      'High Importance Notification',
      importance: Importance.max
    );

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
        _flutterLocalNotificationsPlugin.show(
          0, 
          message.notification!.title.toString(), 
          message.notification!.body.toString(), 
          notificationDetails
        );
      }
    );
  } 

  void requestPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    ); 
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint('User granted provisional permission');
    }else{
      debugPrint('User denied permission');
    }
  }

  Future<String>getDeviceToken()async{
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint('refresh');
    });
  }



}