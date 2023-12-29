import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/deliverystart_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_order_details.dart';
import 'package:provider/provider.dart';

class DeliveryManTotalOrderPage extends StatefulWidget {
  const DeliveryManTotalOrderPage({super.key});

  @override
  State<DeliveryManTotalOrderPage> createState() => _DeliveryManTotalOrderPageState();
}

class _DeliveryManTotalOrderPageState extends State<DeliveryManTotalOrderPage> {
  final searchBarController = TextEditingController();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  late StreamController<List<OrderCustModel>> _streamController;
  late List<OrderCustModel> _allOrders;

  void _loadOrders() {
    custOrderService.getOrder().listen((List<OrderCustModel> orders) {
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
    OrderOwnerModel? currentOrderDelivery = Provider.of<DeliveryStartProvider>(context).currentOrderDelivery;
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Total Orders',
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: currentOrderDelivery == null
            ? Container(
                width: 400,
                height: 300,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(
                  child: Text(
                    'No orders for delivery.\nPlease contact business owner to know more.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  )
                ),  
              )
            : Column(
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
                        return Column(
                          children: orders.map((order) {
                            return Column(
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  tileColor: const Color.fromARGB(255, 0, 126, 229),
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
                                            fontSize: 18
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                            color: Colors.white
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
                                            color: Colors.white
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