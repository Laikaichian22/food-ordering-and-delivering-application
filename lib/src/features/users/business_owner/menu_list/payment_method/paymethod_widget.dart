import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PayMethodWidget extends StatefulWidget {
  const PayMethodWidget({super.key});

  @override
  State<PayMethodWidget> createState() => _PayMethodWidgetState();
}

class _PayMethodWidgetState extends State<PayMethodWidget> {
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
          color: const Color.fromARGB(255, 232, 200, 243),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                payMethodPageRoute, 
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
                          'images/paymethod.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Payment Method',
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