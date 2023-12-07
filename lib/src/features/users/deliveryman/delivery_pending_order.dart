//import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
//import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order_details.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/upload_photo_page.dart';
//import 'package:flutter/widgets.dart';

class DeliveryManPendingPage extends StatefulWidget {
  const DeliveryManPendingPage({super.key});

  @override
  State<DeliveryManPendingPage> createState() => _DeliveryManPendingPageState();
}

class _DeliveryManPendingPageState extends State<DeliveryManPendingPage> {
  // final List<int> selectedIndexes = [];
  // final List<String> _wordName = [
  //   "Engaged in my Life",
  //   "Feel Alive",
  //   "Happy",
  //   "Love my Life",
  // ];
  //bool showButton = false;
  bool isDark = false;
  HashSet<DeliveryOrder> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;
  final List<DeliveryOrder> orderList = [
    DeliveryOrder("Jack", "QFSD34234", "29 Jun 2023", "6:45 PM", "COD",
        "Done paid", "RM6.00", "On the way"),
    DeliveryOrder("Jack", "YBDD43823", "15 Nov 2023", "3:45 PM", "Touch N Go",
        "Done paid", "RM6.50", "On the way"),
    DeliveryOrder("Jack", "DFDD43823", "15 Nov 2023", "5:45 PM", "Touch N Go",
        "Done paid", "RM6.00", "On the way"),
    DeliveryOrder("Jack", "TGFG43823", "15 Nov 2023", "2:45 PM", "Touch N Go",
        "Not yet paid", "RM6.50", "On the way"),
    DeliveryOrder("Jack", "ERGF43823", "15 Nov 2023", "3:00 PM", "Touch N Go",
        "Not yet paid", "RM7.00", "On the way"),
  ];
  //List<int> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deliveryColor,
        centerTitle: isMultiSelectionEnabled ? false : true,
        leading: isMultiSelectionEnabled
            ? IconButton(
                onPressed: () {
                  selectedItem.clear();
                  isMultiSelectionEnabled = false;
                  setState(() {});
                },
                icon: Icon(Icons.close))
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryManHomePage()));
                },
              ),
        title: Text(
          isMultiSelectionEnabled ? getSelectedItemCount() : "Running Orders",
          style: TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        actions: [
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  selectedItem.forEach((nature) {
                    orderList.remove(nature);
                  });
                  selectedItem.clear();
                  setState(() {});
                },
              )),
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              )),
          Visibility(
              visible: isMultiSelectionEnabled,
              child: IconButton(
                icon: Icon(
                  Icons.select_all,
                  color: selectedItem.length == orderList.length
                      ? Colors.red
                      : Colors.black,
                ),
                onPressed: () {
                  if (selectedItem.length == orderList.length) {
                    selectedItem.clear();
                  } else {
                    for (int index = 0; index < orderList.length; index++) {
                      selectedItem.add(orderList[index]);
                    }
                  }
                  setState(() {});
                },
              )),
          Visibility(
            visible: isMultiSelectionEnabled,
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => uploadPhotoPage()));
                setState(() {});
              },
            ),
          ),
        ],
      ),
      // AppBar(
      //   title: const Text('Running Orders'),
      //   //elevation: 0.0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => DeliveryManHomePage()));
      //     },
      //   ),
      //   centerTitle: isMultiSelectionEnabled ? false : true,
      // ),
      body: Column(
        children: [
          Column(
            //padding: const EdgeInsets.all(8.0),
            children: [
              buildSearchInput(),
            ],
          ),
          Expanded(
            child: ListView(
              children:
                  // [
                  //   RunningOrders(),
                  //   RunningOrders(),
                  // ]
                  orderList.map((DeliveryOrder nature) {
                return Card(
                    //elevation: 20,
                    //margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      // margin: const EdgeInsets.only(
                      //     left: 10, right: 10, top: 5, bottom: 5),
                      height: 150.0,
                      child: getListItem(nature),
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
      // Column(
      //   children: <Widget>[
      //     //Spacer(),
      //     RunningOrders(),
      //     Spacer(),
      //   ],
      // ),
    );
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? selectedItem.length.toString() + " item selected"
        : "No item selected";
  }

  void doMultiSelection(DeliveryOrder nature) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(nature)) {
        selectedItem.remove(nature);
      } else {
        selectedItem.add(nature);
      }
      setState(() {});
    } else {
      //Other logic
    }
  }

  // Color getMultiSelectionColor(DeliveryOrder nature) {
  //   Color barecolor;
  //   if (isMultiSelectionEnabled) {
  //     if (selectedItem.contains(nature)) {
  //       barecolor = Color.fromARGB(255, 179, 235, 162);
  //     } else {
  //       barecolor = Color.fromARGB(255, 221, 154, 233);
  //     }
  //     setState(() {});
  //   } else {
  //     //Other logic
  //   }
  //   return barecolor;
  // }

  InkWell getListItem(DeliveryOrder nature) {
    return InkWell(
      onTap: () {
        doMultiSelection(nature);
      },
      onLongPress: () {
        isMultiSelectionEnabled = true;
        doMultiSelection(nature);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              //color:selectedItem = ?,
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
                //child:
                color: isMultiSelectionEnabled
                    ? Color.fromARGB(255, 242, 183, 252)
                    : Color.fromARGB(255, 191, 220, 182),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                    //getMultiSelectionColor(nature);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveryManOrderDetails()));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        //alignment: Alignment.topLeft,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.space,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Need to read from firestore
                                Text(nature.id,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  height: 23,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Color.fromARGB(255, 13, 44, 198),
                                    ), //Need to read from firestore
                                    child: Text(nature.deliveryStatus,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Payment Type: ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.grey,
                                    )),
                                //Need to read from the firestore
                                Text(nature.paymentType,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(nature.date + ' ' + nature.time,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                                //Need to read from the firestore
                                Text(nature.price,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: isMultiSelectionEnabled,
                          // child: Container(
                          //   selectedItem.contains(nature)
                          //        ?
                          //       : Icons.radio_button_unchecked,
                          //   size: 30,
                          //   color: Colors.red,
                          // ),
                          child: Icon(
                            selectedItem.contains(nature)
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 30,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            //getMultiSelectionColor(nature);
          },
        ),
      ),
      // Stack(alignment: Alignment.centerRight, children: [
      //   Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Image.network(
      //       //   nature.url,
      //       //   height: 100,
      //       //   width: 100,
      //       // ),
      //       const SizedBox(
      //         width: 10,
      //       ),
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             const SizedBox(
      //               height: 10,
      //             ),
      //             SizedBox(
      //               width: double.infinity,
      //               height: 18.0,
      //               child: Text(nature.id),
      //             ),
      //             const SizedBox(
      //               height: 10,
      //             ),
      //             SizedBox(
      //               width: double.infinity,
      //               height: 14.0,
      //               child: Text(nature.price),
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      //   Visibility(
      //       visible: isMultiSelectionEnabled,
      //       child: Icon(
      //         selectedItem.contains(nature)
      //             ? Icons.check_circle
      //             : Icons.radio_button_unchecked,
      //         size: 30,
      //         color: Colors.red,
      //       ))
      // ])
    );
  }
}

// AppBar(
//         centerTitle: isMultiSelectionEnabled ? false : true,
//         leading: isMultiSelectionEnabled
//             ? IconButton(
//                 onPressed: () {
//                   selectedItem.clear();
//                   isMultiSelectionEnabled = false;
//                   setState(() {});
//                 },
//                 icon: Icon(Icons.close))
//             : null,
//         title: Text(isMultiSelectionEnabled
//             ? getSelectedItemCount()
//             : "Listview Multi Selection"),
//         actions: [
//           Visibility(
//               visible: selectedItem.isNotEmpty,
//               child: IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () {
//                   selectedItem.forEach((nature) {
//                     natureList.remove(nature);
//                   });
//                   selectedItem.clear();
//                   setState(() {});
//                 },
//               )),
//           Visibility(
//               visible: selectedItem.isNotEmpty,
//               child: IconButton(
//                 icon: Icon(Icons.share),
//                 onPressed: () {},
//               )),
//           /*Visibility(
//               visible: isMultiSelectionEnabled,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.select_all,
//                   color: selectedItem.length == natureList.length
//                       ? Colors.black
//                       : Colors.white,
//                 ),
//                 onPressed: () {
//                   if (selectedItem.length == natureList.length) {
//                     selectedItem.clear();
//                   } else {
//                     for (int index = 0; index < natureList.length; index++) {
//                       selectedItem.add(natureList[index]);
//                     }
//                   }
//                   setState(() {});
//                 },
//               )),*/
//         ],
//       ),
//       body:

// GridView.builder(
//           scrollDirection: Axis.vertical,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 3,
//             mainAxisSpacing: 2,
//             childAspectRatio: (16 / 8),
//           ),
//           itemCount: _wordName.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 debugPrint('hello');
//                 setState(() {
//                   if (selectedIndexes.contains(index)) {
//                     selectedIndexes.remove(index);
//                   } else {
//                     selectedIndexes.remove(index);
//                   }
//                   showButton = true;
//                 });
//               },
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: selectedIndexes == index
//                       ? Color(0xffDEB988).withOpacity(0.2)
//                       : Color(0xffF4F4F6).withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(5.0),
//                   border: Border.all(
//                       color: selectedIndexes == index
//                           ? Color(0xffDEB988)
//                           : Colors.transparent,
//                       width: 0.5),
//                   // image: const DecorationImage(
//                   //   image: AssetImage('images/clock.png'),
//                   //   fit: BoxFit.cover,
//                   // ),
//                 ),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: Center(
//                         child: Text(
//                           _wordName[index].toUpperCase(),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: selectedIndexes == index
//                                 ? Color(0xffDEB988)
//                                 : Colors.black,
//                             fontWeight: selectedIndexes == index
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                             fontFamily: "Poppins",
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),

class RunningOrders extends StatelessWidget {
  const RunningOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        //width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      //alignment: Alignment.topLeft,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.space,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Need to read from firestore
                              Text('#Order id',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 23,
                                width: 100,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: Color.fromARGB(255, 13, 44, 198),
                                  ), //Need to read from firestore
                                  child: Text('On the way',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Payment Type: ',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                  )),
                              //Need to read from the firestore
                              Text('Cash or Touch N GO',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('20 Dec 2023, 6:45 AM',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  )),
                              //Need to read from the firestore
                              Text('RM 6.00',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildSearchInput() => Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 30,
              color: Colors.grey,
            ),
            Flexible(
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );

// class CardWidget extends StatelessWidget {
//   const CardWidget({
//     required this.title,
//     //required this.iconBtn,
//     //required this.subTitle,
//     required this.cardColor,
//     required this.onTap,
//     super.key,
//   });

//   final String title;
//   //final String subTitle;
//   final Color cardColor;
//   final VoidCallback onTap;
//   //final IconData iconBtn;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.75,
//           height: MediaQuery.of(context).size.height * 0.18,
//           child: Card(
//             clipBehavior: Clip.hardEdge,
//             shadowColor: const Color.fromARGB(255, 116, 192, 255),
//             elevation: 9,
//             color: cardColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 //image: DecorationImage(image:, fit:BoxFit.fitWidth),
//               ),
//               child: Column(
//                 //mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   //trailing: Icon(iconBtn, size: 35),
//                   Title(
//                     color: Colors.black,
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 23,
//                         fontWeight: FontWeight.bold,
//                         color: textBlackColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
