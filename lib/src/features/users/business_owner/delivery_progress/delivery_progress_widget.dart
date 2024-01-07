import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

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
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0, 
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
          color: const Color.fromARGB(255, 243, 200, 200),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                ownerDeliveryManListRoute, 
                (route) => false,
              );  
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
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
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}