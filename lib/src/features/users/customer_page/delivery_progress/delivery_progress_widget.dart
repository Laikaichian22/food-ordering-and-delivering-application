import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer_page/delivery_progress/custdelivery_mainpage.dart';

class DeliveryProgressWidget extends StatefulWidget {
  const DeliveryProgressWidget({super.key});

  @override
  State<DeliveryProgressWidget> createState() => _DeliveryProgressWidgetState();
}

class _DeliveryProgressWidgetState extends State<DeliveryProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, 
            spreadRadius: 0.0, 
            offset: const Offset(
              5.0, 
              5.0, 
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: const Color.fromARGB(255, 191, 220, 182),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const CustDeliveryProgressPage()
              );
              Navigator.push(context, route);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/food_delivery.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Delivery Progress',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const Text(
                        'Delivery has not started yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}