import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/services/notification/notification_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/user.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  //final List<String> selectedOrders;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  NotificationServices notificationService = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken().then((value) => print('device token: $value'));
    notificationService.isTokenRefresh();

    notificationService.firebaseInit();
    
  }

  void sendPushMessage (String title, String body, String token) async {
    try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAARZkf7Aw:APA91bGSJTuexnDQR8qO4bdNFNCTsVqtLZUguj39lY_hUlMOiMQ7x6uf6mbP_dpEB5mRPFzGNdQd3KVfufllA3ccLcuZ_2mjaBQhoyK15Yz-QrMYTt0gmUyaHZewAxi0d-fsw_sV23vP', // Replace with your Firebase server key
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': token,
        },
      ),
    );
    print('Notification sent successfully');
  } catch (e) {
    print('Error sending notification: $e');
  }
  }

  @override
  Widget build(BuildContext context){
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Test Notification', 
          barColor: ownerColor
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: title,
                ),
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: body,
                ),
              ),
              ElevatedButton(
                onPressed: ()async{
                  String titleText = title.text;
                  String bodyText = body.text;
                  try{
                    UserModel? user = await UserDatabaseService().getUserDetails(userId);
                    if(user!=null){
                      sendPushMessage(titleText, bodyText, user.token!);
                    }else{
                      print('User not found');
                    }
                  }catch(error){
                    print('Error fetching user details: $error');
                  }
                }, 
                child: const Text('Send notification')
              )
            ],
          ),
        ),
      )
    );
  }

}