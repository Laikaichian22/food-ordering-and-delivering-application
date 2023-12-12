import 'package:flutter/material.dart';

import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/mainPage/business_owner_page/owner_homepage.dart';
import 'package:flutter_application_1/mainPage/customer_page/price_list_page.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/logout.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    // final currentUser = AuthService.firebase().currentUser!;
    // final userId = currentUser.id;
    // AssetImage pizzaAsset = AssetImage('images/delivery.png');
    // Image image = Image(image: pizzaAsset, width: 400, height: 400);
    return Scaffold(
      // drawer: DrawerFunction(userId: userId),
      appBar: AppBar(
        // backgroundColor: deliveryColor,
        title: const Text(
          'Customer',
          style: TextStyle(
            fontSize: 20,
            // color: textBlackColor,
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
              height: MediaQuery.of(context).size.height * 0.35,
              child: Container(
                //height: 100,
                //width: 500,
                child: Column(
                  children: [
                    Text('Welcome!',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'images/R.jpeg',
                      height: 200,
                      width: 500,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage()));
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
                          'images/B.jpeg',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Column(
                        children: [
                          Text('Place Order',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text('100',
                          //       style: TextStyle(
                          //         fontSize: 20.0,
                          //         fontFamily: 'Roboto',
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.bold,
                          //       )),
                          // ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage()));
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
                          'images/B.jpeg',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('View Order Details',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('10',
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         fontFamily: 'Roboto',
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //       )),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage()));
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
                          'images/B.jpeg',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('Cancel Order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('56',
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         fontFamily: 'Roboto',
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //       )),
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
                          'images/B.jpeg',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Text('Delivery Progress',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('RM 100.23',
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         fontFamily: 'Roboto',
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //       )),
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
//       ),
//     );
// class CustomerHomePage extends StatefulWidget {
//   const CustomerHomePage({super.key});

//   @override
//   State<CustomerHomePage> createState() => _CustomerHomePageState();
// }

// class _CustomerHomePageState extends State<CustomerHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     Widget categoriesContainer({required String image, required String name}) {
//       return Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(left: 15),
//             height: 90,
//             width: 90,
//             decoration: BoxDecoration(
//                 image: DecorationImage(image: AssetImage(image)),
//                 color: Color.fromARGB(255, 228, 225, 219),
//                 borderRadius: BorderRadius.circular(10)),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Text(
//             name,
//             style: TextStyle(fontSize: 15, color: Colors.black),
//           )
//         ],
//       );
//     }

//     Widget bottomContainer({required String image, required String name}) {
//       return Container(
        
//         height: 250,
//         width: 200,
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          
//           CircleAvatar(
//             radius: 60,
//             backgroundImage: AssetImage(image),
//           ),
//           ListTile(
//             leading: Text(
//               name,
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.star,
//                   color: Colors.white,
//                 ),
//                 Icon(
//                   Icons.star,
//                   color: Colors.white,
//                 ),
//                 Icon(
//                   Icons.star,
//                   color: Colors.white,
//                 )
//               ],
//             ),
//           )
//         ]),
//       );
//     }

//     return Scaffold(
//         drawer: Drawer(
//           child: Container(
//             //color: Color.fromARGB(255, 234, 118, 255),
//             child: ListView(
//               children: [
//                 Container(
//                   child: DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 227, 73, 254),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 46,
//                           child: CircleAvatar(
//                               radius: 42, backgroundColor: Colors.amber),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(15.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Welcome",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(
//                                 height: 15,
//                               ),
//                               Text("This is customer page"),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 ListTile(
//                     leading: Icon(
//                       Icons.home_outlined,
//                     ),
//                     title: Text('Home', style: TextStyle(color: Colors.black)),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   new BusinessOwnerHomePage()));
//                     }),
//                 ListTile(
//                     leading: Icon(
//                       Icons.person_outlined,
//                     ),
//                     title: Text('My profile',
//                         style: TextStyle(color: Colors.black)),
//                     onTap: () {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         custProfileRoute,
//                         (route) => false,
//                       );
//                     }),
//                 ListTile(
//                     leading: Icon(
//                       Icons.settings_outlined,
//                     ),
//                     title:
//                         Text('Setting', style: TextStyle(color: Colors.black)),
//                     onTap: () {}),
//                 ListTile(
//                     leading: Icon(
//                       Icons.format_quote_outlined,
//                     ),
//                     title: Text('FAQs', style: TextStyle(color: Colors.black)),
//                     onTap: () {}),
//                 ListTile(
//                     leading: Icon(
//                       Icons.logout_outlined,
//                     ),
//                     title:
//                         Text('Logout', style: TextStyle(color: Colors.black)),
//                     onTap: () async {
//                       final shouldLogout = await showLogOutDialog(context);
//                       //devtools.log(shouldLogout.toString()); //give special output in terminal
//                       if (shouldLogout) {
//                         await AuthService.firebase().logOut();
//                         Navigator.of(context).pushNamedAndRemoveUntil(
//                           loginRoute,
//                           (_) => false,
//                         );
//                       }
//                     }),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
//                   child: Container(
//                     height: 300,
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Contact Support",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'Call us:',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               '0123456789',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'Mail us:',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               'abc@gmail.com',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.purple,
//           elevation: 0.0,
//           //leading: Icon(Icons.sort),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(9.0),
//               child: CircleAvatar(
//                 backgroundImage: AssetImage('images/homeImage.jpg'),
//               ),
//             )
//           ],
//         ),
//         body: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       hintText: "Search Food",
//                       hintStyle: TextStyle(color: Colors.white),
//                       prefixIcon: Icon(Icons.search, color: Colors.white),
//                       filled: true,
//                       fillColor: Colors.grey,
//                       border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10))),
//                 ),
//               ),
//               // SingleChildScrollView(
//               //   scrollDirection: Axis.horizontal,
//               //   child: Row(
//               //     children: [
//               //       categoriesContainer(image: 'images/R.jpeg', name: 'Rice1'),
//               //       categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
//               //       categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
//               //       categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
//               //       categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
//               //     ],
//               //   ),
//               // ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 1),
//                 height: 520,
//                 child: GridView.count(
//                   shrinkWrap: false,
//                   primary: false,
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.8,
//                   crossAxisSpacing: 20,
//                   mainAxisSpacing: 20,
//                   children: [
//                     bottomContainer(
//                         image: 'images/R.jpeg', name: 'Place Order'),
//                     bottomContainer(
//                         image: 'images/R.jpeg', name: 'View Order Details'),
//                     bottomContainer(
//                         image: 'images/R.jpeg', name: 'Cancel Order'),
//                     bottomContainer(
//                         image: 'images/B.jpeg', name: 'Delivery Progress'),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
