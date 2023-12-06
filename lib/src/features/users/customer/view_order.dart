import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';



class ViewOrder extends StatefulWidget {
  @override 
  State<ViewOrder> createState() => _ViewOrderState();
   Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UmaiFood',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
 
}
}
class _ViewOrderState extends State<ViewOrder> {
  // A variable to store the remaining time for placing an order
  Duration _remainingTime = Duration(hours: 6, minutes: 3, seconds: 23);

  // A timer that updates the remaining time every second
  late Timer _timer;

  // A method that starts the timer when the widget is initialized
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Decrease the remaining time by one second
        _remainingTime = _remainingTime - Duration(seconds: 1);
        // If the remaining time is zero, stop the timer and show a message
        if (_remainingTime.inSeconds == 0) {
          _timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order closed'),
            ),
          );
        }
      });
    });
  }

  // A method that stops the timer when the widget is disposed
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // A method that formats the remaining time as hh:mm:ss
  String _formatTime(Duration duration) {
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((segment) => segment.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UmaiFood'),
        actions: [
          // A hamburger menu icon
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // TODO: Add logic for opening the menu
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // The "Place order" section
          Container(
  color: Colors.yellow,
  margin: const EdgeInsets.all(10.0),
  child: ExpansionTile(
    title: const Text('Place order'),
    subtitle: const Text('Lunch Thursday'),
    trailing: const Text('Open'),
    initiallyExpanded: true,
    children: [
      // A row that shows the closing time and the remaining time
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Close order on 26 October 2023, 9:30am'),
          Text('Closing in ${_formatTime(_remainingTime)}'),
        ],
      ),
      // TODO: Add logic for placing an order
    ],
  ),
),
          // The "View order details" section
        
          const ListTile(
            title: Text('View order details'),
            subtitle: Text('You haven\'t place any order'),
            enabled: false,
            // TODO: Add logic for viewing order details
          ),
          // The "Cancel order" section
          const ListTile(
            title: Text('Cancel order'),
            subtitle: Text('Delivery hasn\'t start'),
            enabled: false,
            // TODO: Add logic for canceling order
          ),
        ],
      ),
    );
  }
}
