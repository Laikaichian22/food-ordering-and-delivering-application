import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:intl/intl.dart';

class DeliveryStartMainPage extends StatefulWidget {
  const DeliveryStartMainPage({super.key});

  @override
  State<DeliveryStartMainPage> createState() => _DeliveryStartMainPageState();
}

class _DeliveryStartMainPageState extends State<DeliveryStartMainPage> {
  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('HH:mm a').format(currentTime);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Delivery start', 
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery start at $formattedTime'),
                const SizedBox(height: 5),
                Container(
                  height: height*0.3,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: const Center(child: Text('Here show the map')),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text('Delivery process:'),
                          SizedBox(width: 5),
                          Text('In progress')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Car plate number:'),
                          SizedBox(width: 5),
                          Text('ABC 1234')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Current location:'),
                          SizedBox(width: 5),
                          Text('MA1')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Next location:'),
                          SizedBox(width: 5),
                          Text('MA3')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Estimated time:'),
                          SizedBox(width: 5),
                          Text('5 minutes')
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}