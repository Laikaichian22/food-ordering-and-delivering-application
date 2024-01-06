import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/order_list/order_details.dart';

class OwnerViewOrderListPage extends StatefulWidget {
  const OwnerViewOrderListPage({super.key});

  @override
  State<OwnerViewOrderListPage> createState() => _OwnerViewOrderListPageState();
}

class _OwnerViewOrderListPageState extends State<OwnerViewOrderListPage> {
  final searchBarController = TextEditingController();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  late StreamController<List<OrderCustModel>> _streamController;
  late List<OrderCustModel> _allOrders;

  void _loadOrders() {
    custOrderService.getAllOrder().listen((List<OrderCustModel> orders) {
      _allOrders = orders;
      _applySearchFilter();
    });
  }
  void _loadOriginalOrder() {
    _loadOrders();
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

  var options = [
    'Default',
    'Location',
    'DishType',
    'Name',
    'PayMethod',
    'PayStatus'
  ];
  var selectedFeature = 'Default';
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const DirectAppBarNoArrow(
          title: 'Order List',
          userRole: 'owner',
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 210,
                      child: TextField(
                        controller: searchBarController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                          ),
                          labelText: 'Search by destination',
                          labelStyle: const TextStyle(
                            fontSize: 15
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged:(_) => _applySearchFilter(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              items: options.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value)
                                );
                              }).toList(),
                              onChanged: (newValueSelected){
                                setState(() {
                                  selectedFeature = newValueSelected!;
                                  if (selectedFeature == 'Default') {
                                    _loadOriginalOrder(); 
                                  }
                                });
                              },
                              value: selectedFeature,
                            ),
                          ],
                        )
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'List arrangement:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      selectedFeature == 'Default'
                      ? 'Default'
                      : selectedFeature == 'Location'
                        ? 'Sorted by destination'
                        : selectedFeature == 'DishType'
                          ? 'Sorted by Type of Dish'
                          : selectedFeature == 'Name'
                            ? 'Sorted by Customer Name'
                            : selectedFeature == 'PayMethod'
                              ? 'Sorted by Payment Method'
                              : selectedFeature == 'PayStatus'
                                ? 'Sorted by Payment Status'
                                : 'Default'
                    )
                  ]
                ),
                const SizedBox(height: 10),
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
                      if (selectedFeature == 'Location') {
                        orders.sort((a, b) => a.destination!.toLowerCase().compareTo(b.destination!.toLowerCase()));
                      }else if (selectedFeature == 'DishType') {
                        orders.sort((a, b) => a.orderDetails!.toLowerCase().compareTo(b.orderDetails!.toLowerCase()));
                      }else if (selectedFeature == 'Name') {
                        orders.sort((a, b) => a.custName!.toLowerCase().compareTo(b.custName!.toLowerCase()));
                      }else if (selectedFeature == 'PayMethod') {
                        orders.sort((a, b) => a.payMethod!.compareTo(b.payMethod!));
                      }else if (selectedFeature == 'PayStatus') {
                        orders.sort((a, b) => a.paid!.compareTo(b.paid!));
                      }
                      return Column(
                        children: orders.map((order) {
                          return Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: order.delivered == 'No' ? orderHasNotDeliveredColor : orderDeliveredColor, 
                                contentPadding: const EdgeInsetsDirectional.all(10),
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 18,
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
                                          fontSize: 18,
                                          color: purpleColorText
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15
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
                                          const TextSpan(
                                            text: '\nPayment method: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.payMethod,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Payment status:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 110,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11),
                                            color: order.paid == 'No' 
                                            ? statusRedColor
                                            : statusYellowColor
                                          ),
                                          child: order.paid == 'No'
                                          ? const Text(
                                            'Not Yet Paid',
                                            style: TextStyle(
                                              color: yellowColorText,
                                              fontWeight: FontWeight.bold
                                            ),
                                            )
                                          : const Text(
                                              'Paid',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    order.delivered == 'No'
                                    ? Row(
                                        children: [
                                          const Text(
                                            'Order status:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: 140,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(11),
                                              color: statusRedColor
                                            ),
                                            child: const Text(
                                              'Not yet delivered',
                                              style: TextStyle(
                                                color: yellowColorText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        ]
                                      )
                                    : Row(
                                        children: [
                                          const Text(
                                            'Order status:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: 140,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(11),
                                              color: order.isCollected == 'No' 
                                              ? statusRedColor
                                              : statusYellowColor
                                            ),
                                            child: order.isCollected == 'No'
                                            ? const Text(
                                                'Not Yet Collected',
                                                style: TextStyle(
                                                  color: yellowColorText,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              )
                                            : const Text(
                                                'Complete',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                                
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 105, 1, 107),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => OwnerViewSelectedOrderPage(orderSelected: order),
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
      )
    );
  }
}