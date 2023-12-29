import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';

class DeliveryManCompletedPage extends StatefulWidget {
  const DeliveryManCompletedPage({super.key});

  @override
  State<DeliveryManCompletedPage> createState() =>
      _DeliveryManCompletedPageState();
}

class _DeliveryManCompletedPageState extends State<DeliveryManCompletedPage> {
  final searchBarController = TextEditingController();
  List<DeliveryOrder> orderList = allOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 91, 159, 182),
        backgroundColor: deliveryColor,
        centerTitle: true,
        title: const Text(
          'Completed Orders',
          style: TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DeliveryManHomePage()));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: searchBarController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search order',
                hintStyle: const TextStyle(
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
                          "Order Name: ${order.name}\nDestination: ${order.destination}",
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const DeliveryManOrderDetails(),
                          //   ),
                          // );
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
    setState(() => orderList = suggestions);
  }
}
