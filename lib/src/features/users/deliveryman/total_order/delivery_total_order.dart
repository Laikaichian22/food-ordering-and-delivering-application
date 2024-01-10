import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_order_details.dart';

class DeliveryManTotalOrderPage extends StatefulWidget {
  const DeliveryManTotalOrderPage({
    required this.orderDeliveryOpened,
    super.key
  });

  final OrderCustModel orderDeliveryOpened;

  @override
  State<DeliveryManTotalOrderPage> createState() => _DeliveryManTotalOrderPageState();
}

class _DeliveryManTotalOrderPageState extends State<DeliveryManTotalOrderPage> {
  final searchBarController = TextEditingController();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  late StreamController<List<OrderCustModel>> _streamController;
  late List<OrderCustModel> _allOrders;

  void _loadOrders() {
    custOrderService.getOrderByOrderId(widget.orderDeliveryOpened.menuOrderID!)
    .listen((List<OrderCustModel> orders) {
      _allOrders = orders;
      _applySearchFilter();
    });
  }
  void _applySearchFilter() {
    final String query = searchBarController.text.toLowerCase();
    final List<OrderCustModel> filteredOrders = _allOrders.where((order) {
      return order.destination!.toLowerCase().contains(query);
    }).toList();

    _streamController.add(filteredOrders);
  }

  @override
  void initState() {
    super.initState();
    _allOrders = [];
    _streamController = StreamController<List<OrderCustModel>>.broadcast();
    _loadOrders();
  }
  @override
  void dispose(){
    super.dispose();
    searchBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Total Orders',
          userRole: 'deliveryMan',
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: searchBarController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search order by destination",
                    hintStyle: const TextStyle(
                      fontSize: 17,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onChanged: (_) => _applySearchFilter(),
                ),
          
                const SizedBox(height: 30),
        
                StreamBuilder<List<OrderCustModel>>(
                  stream: _streamController.stream, 
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: const Center(
                          child: Text(
                            "No order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )
                        ),
                      );
                    }else {
                      List<OrderCustModel> orders = snapshot.data!;
                      orders.sort((a, b) {
                        if (a.delivered == 'No' && b.delivered == 'Yes') {
                          return -1; // a comes first if 'delivered' is 'No'
                        } else if (a.delivered == 'Yes' && b.delivered == 'No') {
                          return 1; // b comes first if 'delivered' is 'No'
                        } else {
                          // Sort based on other criteria if 'delivered' status is the same
                          return b.dateTime!.compareTo(a.dateTime!);
                        }
                      });
                      return Column(
                        children: orders.map((order) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: order.delivered == 'Yes' ? orderDeliveredColor : orderHasNotDeliveredColor,
                                    contentPadding: const EdgeInsetsDirectional.all(10),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Location: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.destination,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Customer Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.custName,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                          const TextSpan(
                                            text: '\nOrder detail: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.orderDetails,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 50,
                                      color: Color.fromARGB(255, 7, 0, 141),
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => DeliveryManOrderDetails(orderSelected: order),
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  if (order.delivered == 'Yes')
                                    Positioned(
                                      top: 0,
                                      right: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: deliveredClipBarColor, 
                                          height: 30,
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: deliveredClipBarTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}