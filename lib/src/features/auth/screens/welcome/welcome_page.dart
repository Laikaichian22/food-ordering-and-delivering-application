import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notification/notification_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState(){
    super.initState();
    notificationServices.requestPermission();
    notificationServices.firebaseInitNotification(context);
    notificationServices.setupInteractMessage(context);

    //!give your message on which user taps and it opens the app from terminated state
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if(message!=null){
    //     // final routeFromMessage = message.data['route'];
    //     Navigator.of(context).pushNamed(loginRoute);
    //   }
    // });

    //!foreground display notification, but does not show the notification bar
    // FirebaseMessaging.onMessage.listen((message) {
    //   if(message.notification != null){
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //   }
    //   NotificationServices().display(message);
    // });

    //!when app is in background but opened when user taps on notification, but the routing lead to incorrect page
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   //final routeFromMessage = message.data['route'];

    //   print(message.notification!.title.toString());
    // });

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tPaddingSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('images/homeImage.jpg', height: height * 0.6),
                const Column(
                  children: [
                    Text(
                      welcomeTitletxt,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          elevation: 10,
                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          loginBtntxt,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          elevation: 10,
                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          registerBtntxt,
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
