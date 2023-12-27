import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_completed_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_pending_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_total_order.dart';
//import 'package:flutter_application_1/src/routing/routes_const.dart';

//main page for deliveryman
class DeliveryManHomePage extends StatefulWidget {
  const DeliveryManHomePage({super.key});

  @override
  State<DeliveryManHomePage> createState() => _DeliveryManHomePageState();
}

class _DeliveryManHomePageState extends State<DeliveryManHomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    // AssetImage pizzaAsset = AssetImage('images/delivery.png');
    // Image image = Image(image: pizzaAsset, width: 400, height: 400);
    return Scaffold(
      drawer: DrawerFunction(userId: userId),
      appBar: AppBar(
        backgroundColor: deliveryColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        centerTitle: true,
      ),
      body:
          //const Text('Welcome Jack'),
          SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.30,
              child: Container(
                //height: 100,
                //width: 500,
                child: Column(
                  children: [
                    Text('Welcome Jack!',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    Image.asset(
                      'images/delivery2.png',
                      height: 200,
                      width: 600,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  children: [
                    //Image.asset('images/clock.png'),
                    //Headers(Text('Welcome Jack'),),
                    //const Text('Welcome Jack'),
                    TotalOrders(),
                    TotalPendingOrders(),
                    TotalCompletedOrders(),
                    TotalCashOnHand(),
                    //Testing(),
                  ],
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 10,
                  //   crossAxisSpacing: 10,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Row(
      //   children: <Widget>[
      //     Spacer(
      //       flex: 1,
      //     ),
      //     TotalOrders(),
      //     TotalCashOnHand(),
      //   ],
      // ),
    );
  }
}

class TotalOrders extends StatelessWidget {
  const TotalOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Color.fromARGB(255, 200, 240, 243),
          child: InkWell(
            //onHover: Color.fromARGB(255, 99, 157, 34),
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => deliveryManTotalOrderPage()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  //alignment: Alignment.topLeft,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/schedule.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Column(
                        children: [
                          Text('Total Orders',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('100',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
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

class TotalPendingOrders extends StatelessWidget {
  const TotalPendingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Color.fromARGB(255, 211, 169, 243),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryManPendingPage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  //alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/clock.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('Total Pending Orders',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('10',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
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

class TotalCompletedOrders extends StatelessWidget {
  const TotalCompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Color.fromARGB(255, 235, 221, 188),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryManCompletedPage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  //alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/shipped.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('Total Completed Orders',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('56',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
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

class TotalCashOnHand extends StatelessWidget {
  const TotalCashOnHand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Color.fromARGB(255, 191, 220, 182),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  //alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/cash.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('Cash on Hand',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('RM 100.23',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
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

// class Testing extends StatelessWidget {
//   const Testing({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // clipBehavior is necessary because, without it, the InkWell's animation
//       // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
//       // This comes with a small performance cost, and you should not set [clipBehavior]
//       // unless you need it.
//       clipBehavior: Clip.hardEdge,
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           debugPrint('Card tapped.');
//         },
//         child: const SizedBox(
//           width: 300,
//           height: 100,
//           child: Text('A card that can be tapped'),
//         ),
//       ),
//     );
//   }
// }

// class TotalCashOnHand extends StatelessWidget {
//   const TotalCashOnHand({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(top: 16.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('\$  ',
//                     style: new TextStyle(
//                       fontSize: 20.0,
//                       fontFamily: 'Roboto',
//                       color: new Color(0xFF26C6DA),
//                     )),
//                 Text(
//                   '3,435.23',
//                   style: new TextStyle(
//                       fontSize: 35.0,
//                       fontFamily: 'Roboto',
//                       color: new Color(0xFF26C6DA)),
//                 )
//               ],
//             ),
//           ),
//           Text('general balance'),
//         ],
//       ),
//     );
//   }
// }
// Container(
//       decoration:
//           const BoxDecoration(color: Color.fromARGB(255, 171, 128, 128)),
//       //color: Color.fromARGB(4, 100, 100, 100),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             height: 50,
//             //width: 200,

//             //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//             //alignment: Alignment.topLeft,
//             color: Colors.amber,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Image.asset(
//                   'icons/schedule.png',
//                   width: 50,
//                   height: 50,
//                   //alignment: Alignment.topRight,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: Text('number of total orders'),
//           ),
//           Container(
//             child: Text(
//               'Total Orders',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );