import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order_details.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
//import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class deliveryManTotalOrderPage extends StatefulWidget {
  const deliveryManTotalOrderPage({super.key});

  @override
  State<deliveryManTotalOrderPage> createState() =>
      _deliveryManTotalOrderPageState();
}

class _deliveryManTotalOrderPageState extends State<deliveryManTotalOrderPage> {
  //bool isDark = false;
  final searchBarController = TextEditingController();
  List<DeliveryOrder> orderList = allOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deliveryColor,
        title: const Text('Total Orders'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //searchOrdersRoute;
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: searchBarController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search order',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              onChanged: searchOrders,
              //(text) {
              //  text = text.toLowerCase();
              //  filter(text);
              //},
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orderList[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey,
                    color: deliveryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      child: ListTile(
                        splashColor: Colors.blue.withAlpha(30),
                        title: Text(order.id),
                        subtitle: Text(
                          "Order Name: " +
                              order.name +
                              "\nDestination: " +
                              order.destination,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeliveryManOrderDetails(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void searchOrders(String query) {
    final suggestions = allOrders.where((order) {
      final orderTitle = order.destination.toLowerCase();
      final input = query.toLowerCase();
      return orderTitle.contains(input);
    }).toList();
    this.setState(() => orderList = suggestions);
  }
}

//    return Scaffold(
    //   body: SafeArea(
    //     child: FloatingSearchBar(
    //       minimumChars: 1,
    //       searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
    //       headerPadding: EdgeInsets.symmetric(horizontal: 10),
    //       listPadding: EdgeInsets.symmetric(horizontal: 10),
    //       onSearch: _getALlPosts,
    //       searchBarController: _searchBarController,
    //       placeHolder: Center(
    //           child: Text(
    //         "PlaceHolder",
    //         style: TextStyle(fontSize: 30),
    //       )),
    //       cancellationWidget: Text("Cancel"),
    //       emptyWidget: Text("empty"),
    //       onCancelled: () {
    //         print("Cancelled triggered");
    //       },
    //       mainAxisSpacing: 10,
    //       onItemFound: (Post post, int index) {
    //         return Container(
    //           color: Colors.lightBlue,
    //           child: ListTile(
    //             title: Text(post.title),
    //             isThreeLine: true,
    //             subtitle: Text(post.body),
    //             onTap: () {
    //               Navigator.of(context)
    //                   .push(MaterialPageRoute(builder: (context) => Detail()));
    //             },
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     backgroundColor: deliveryColor,
    //     title: const Text(
    //       'All Orders',
    //       style: TextStyle(
    //         fontSize: 20,
    //         color: textBlackColor,
    //       ),
    //     ),
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back, color: Colors.black),
    //       onPressed: () {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => DeliveryManHomePage()));
    //       },
    //     ),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: ListView(
    //       children: [
    //         buildSearchInput(),
    //       ],
    //     ),
    //     // child: SearchAnchor(
    //     //     builder: (BuildContext context, SearchController controller) {
    //     //   return SearchBar(
    //     //     controller: controller,
    //     //     padding: const MaterialStatePropertyAll<EdgeInsets>(
    //     //         EdgeInsets.symmetric(horizontal: 16.0)),
    //     //     onTap: () {
    //     //       controller.openView();
    //     //     },
    //     //     onChanged: (_) {
    //     //       controller.openView();
    //     //     },
    //     //     leading: const Icon(Icons.search),
    //     //     trailing: <Widget>[
    //     //       Tooltip(
    //     //         message: 'Change brightness mode',
    //     //         child: IconButton(
    //     //           isSelected: isDark,
    //     //           onPressed: () {
    //     //             setState(() {
    //     //               isDark = !isDark;
    //     //             });
    //     //           },
    //     //           icon: const Icon(Icons.wb_sunny_outlined),
    //     //           selectedIcon: const Icon(Icons.brightness_2_outlined),
    //     //         ),
    //     //       )
    //     //     ],
    //     //   );
    //     // }, suggestionsBuilder:
    //     //         (BuildContext context, SearchController controller) {
    //     //   return List<ListTile>.generate(5, (int index) {
    //     //     final String item = 'item $index';
    //     //     return ListTile(
    //     //       title: Text(item),
    //     //       onTap: () {
    //     //         setState(() {
    //     //           controller.closeView(item);
    //     //         });
    //     //       },
    //     //     );
    //     //   });
    //     // }),
    //   ),
    // );