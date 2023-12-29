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

class OrderPendingPage extends StatefulWidget {
  const OrderPendingPage({super.key});

  @override
  State<OrderPendingPage> createState() => _OrderPendingPageState();
}

class _OrderPendingPageState extends State<OrderPendingPage> {
  final searchBarController = TextEditingController();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  late StreamController<List<OrderCustModel>> _streamController;
  late List<OrderCustModel> _allOrders;
  List<String> selectedOrderIdList = [];
  bool isMultiSelectionEnabled = false;

  void _loadOrders() {
    custOrderService.getPendingOrder().listen((List<OrderCustModel> orders) {
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
    'Status'
  ];
  var selectedFeature = 'Default';

  @override
  Widget build(BuildContext context) {
    OrderOwnerModel? currentOrderDelivery = Provider.of<DeliveryStartProvider>(context).currentOrderDelivery;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    InkWell getOrderList(OrderCustModel orderDetails){
      bool isSelected = selectedOrderIdList.contains(orderDetails.id);
      return InkWell(
        onTap:(){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => DeliveryManOrderDetails(orderSelected: orderDetails),
          );
          Navigator.push(context, route);
        },
        onLongPress: (){
          setState(() {
            isSelected = !isSelected;
            isMultiSelectionEnabled = !isMultiSelectionEnabled;
            if (isSelected) {
              selectedOrderIdList.add(orderDetails.id!);
            } else {
              selectedOrderIdList.remove(orderDetails.id);
            }
          });
        },
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 20.0, 
                  spreadRadius: 0.0,
                  offset: const Offset(
                    5.0, 
                    5.0,
                  ),
                )
              ]
            ),
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: isMultiSelectionEnabled
                ? const Color.fromARGB(255, 242, 183, 252)
                : const Color.fromARGB(255, 191, 220, 182),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orderDetails.custName!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.all(5),
                                width: 110,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: const Color.fromARGB(255, 13, 44, 198),
                                ),
                                child: const Text(
                                  'On the way',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.white
                                  )
                                )
                              ),
                              isMultiSelectionEnabled
                              ? Checkbox(
                                  value: isSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      isSelected = value!;
                                      if (isSelected) {
                                        selectedOrderIdList.add(orderDetails.id!);
                                      } else {
                                        selectedOrderIdList.remove(orderDetails.id);
                                      }
                                    });
                                  }
                                )
                              : Container()
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Payment Type: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    TextSpan(
                                      text: orderDetails.payMethod!,
                                    )
                                  ]
                                ),
                              ),
                              isMultiSelectionEnabled
                              ? InkWell(
                                onTap: (){
                                  setState(() {
                                    isMultiSelectionEnabled = !isMultiSelectionEnabled;
                                  });
                                },
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  )
                                )
                              : Container()
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Destination: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  TextSpan(
                                    text: orderDetails.destination!,
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Amount: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  TextSpan(
                                    text: 'RM${orderDetails.payAmount.toString()}',
                                  )
                                ]
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: 110,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(width:0.5),
                                color: orderDetails.receipt == '' 
                                ? const Color.fromARGB(255, 255, 17, 0)
                                : const Color.fromARGB(255, 2, 255, 10)
                              ),
                              child: orderDetails.receipt == ''
                              ? const Text(
                                'Not Yet Paid',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 215, 95),
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
                      ],
                    ),
                  )  
                ),
              ),
            ),
          ),
        )
      );
    }
    
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Pending Order', 
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
                children: [
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
                      const SizedBox(width: 10),
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
                                : selectedFeature == 'Status'
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
                              "No order found",
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
                        }else if (selectedFeature == 'Status') {
                          orders.sort((a, b) => a.paid!.compareTo(b.paid!));
                        }
                        
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: height,
                              width: width,
                              child: ListView(
                                children: orders.map((order){
                                  return Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child: SizedBox(
                                      height: 150.0,
                                      child: getOrderList(order),
                                    )
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        );
                      }
                    }
                  ),
                ],
              )
          ),
        ),
      )
    );
  }
}