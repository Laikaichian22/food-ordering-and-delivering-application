import 'dart:convert';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_pending_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/notification/selectedOrderManager.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//exactly for customer(now for try)
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  //final List<String> selectedOrders;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> orders = SelectedOrdersManager.getSelectedOrders();
  String? mtoken = "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  //request permission from user's device
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //get user token
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  //save into firebase usertoken and userid
  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc("userId")
        .set({
      'token': token,
    });
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      //special import as http
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=REPLACETHISWITHYOURAPIKEY',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'android_channel_id': "dbfood",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'title': title,
              'body': body,
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  void sendPushMessagesToUsers(String body, String title) async {
    List<String> userIds = SelectedOrdersManager.getSelectedOrders();
    for (String userId in userIds) {
      DocumentSnapshot snap = await userCollection.doc(userId).get();
      String token = snap['token'].toString();
      print(token);
      sendPushMessage(body, title, token);
    }
  }

  void initInfo() {}

  // void accessSelectedOrderIds() {
  //DeliveryManPendingPage deliveryManPendingPage = DeliveryManPendingPage();
  //   List<String> selectedOrderIds = deliveryPendingOrderRoute.

  //   // Now `selectedOrderIds` contains the list of selected order IDs
  //   // Use this list as needed in this class
  // }

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextFormField(
          //   controller: id,
          // ),
          TextFormField(
            controller: title,
          ),
          TextFormField(
            controller: body,
          ),
          GestureDetector(
            //do a button for trigger to save to firebase and send noti to user
            child:
                // Container(
                //   margin: const EdgeInsets.all(20),
                //   height: 40,
                //   width: 200,
                // ),
                Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: deliveryColor,
                      minimumSize: const Size(188, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      //change the border to rounded side
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        side: BorderSide(width: 1, color: Colors.black),
                      ),
                      //construct shadow color
                      elevation: 10,
                      shadowColor: shadowClr,
                    ).copyWith(
                      //change color onpressed
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue;
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () async {
                      final userId = orders;
                      //= id.text.trim();
                      //"ZDeU7ka8IQTWjyK4cv0xkxokh6G2";
                      String titleText = title.text;
                      String bodyText = body.text;
                      sendPushMessagesToUsers(bodyText, titleText);
                      // if (userId != "") {
                      //   DocumentSnapshot snap =
                      //       await userCollection.doc(userId).get();

                      //   String token = snap['token'].toString();
                      //   print(token);

                      //   sendPushMessage(titleText, bodyText, token);
                      // }
                    },
                    child: Text("ok"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
    //   //get the notification message and display on screen
    //   final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Notification"),
    //     ),
    //     body: Column(
    //       children: [
    //         Text(message.notification!.title.toString()),
    //         Text(message.notification!.body.toString()),
    //         Text(message.data.toString()),
    //       ],
    //     ),
    //   );
  }

  String receiveOrderIds(List<String> userIds) {
    // Handle the received orderIds here
    //print('Received order IDs in AnotherClass: $userIds');
    // Perform actions with the received order IDs
    if (userIds.isNotEmpty) {
      return userIds.toString(); // Returning the first order ID
    } else {
      return ''; // Return an empty string if there are no order IDs
    }
  }
}

// class SelectedOrdersProvider extends DeliveryManPendingPage {
//   List<String> _selectedOrderIds = [];

//   List<String> get selectedOrderIds => _selectedOrderIds;

//   void updateSelectedOrders(List<String> orders) {
//     _selectedOrderIds = orders;
//     //notifyListeners();
//   }
// }

//exactly should be userid

