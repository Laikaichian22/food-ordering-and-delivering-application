import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/cash_on_hand/cashonhand_list_page.dart';

class TotalCashOnHand extends StatefulWidget {
  const TotalCashOnHand({super.key});

  @override
  State<TotalCashOnHand> createState() => _TotalCashOnHandState();
}

class _TotalCashOnHandState extends State<TotalCashOnHand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
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
          color: const Color.fromARGB(255, 191, 220, 182),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryViewCashOnHandListPage()
                )
              );
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
                          'images/cash.png',
                          width: 80,
                          height: 80,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Cash on Hand',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'RM 100.23',
                      //     style: TextStyle(
                      //       fontSize: 20.0,
                      //       fontFamily: 'Roboto',
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold,
                      //     )
                      //   ),
                      // ),
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