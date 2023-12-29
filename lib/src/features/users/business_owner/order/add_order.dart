import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/deliverystart_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/order_list/order_listpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/view_order.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../routing/routes_const.dart';

class AddOrDisplayOrderPage extends StatefulWidget {
  const AddOrDisplayOrderPage({super.key});

  @override
  State<AddOrDisplayOrderPage> createState() => _AddOrDisplayOrderPageState();
}

class _AddOrDisplayOrderPageState extends State<AddOrDisplayOrderPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService(); 
  final OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
    } else {
      return 'N/A';
    }
  }
  
  Widget buildOrderTile(OrderOwnerModel order, double width, double height){
    return InkWell(
      onTap: (){
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ViewOrderPage(
            orderSelected: order
          )
        );
        Navigator.push(context, route);
      },
      child: Container(
        width: width*0.75,
        height: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 117, 117, 117),
              offset: Offset(0, 6)
            )
          ]
        ),
        child: Column(
          children: [
            Text(
              'Order Name: ${order.orderName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),const SizedBox(height:10),
            Text(
              'Start time: ${_formatDateTime(order.startTime)}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              'End time: ${_formatDateTime(order.endTime)}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: const Text('Confirm to start delivery?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')
                            ),
                            TextButton(
                              onPressed: (){
                                Provider.of<DeliveryStartProvider>(context, listen: false).setOrderDelivery(order);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  ownerDlvryProgressRoute, 
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'A notification has been sent to delivery man'
                                  )
                                )
                              );
                              }, 
                              child: const Text('Confirm')
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15,5,15,5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 157, 0),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 34, 146, 0).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text('Start delivery'),
                  ),
                ),
                StreamBuilder<List<OrderCustModel>>(
                  stream: custOrderService.getOrder(), 
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 197, 197, 197),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('No order placed yet'),
                      );
                    }else {
                      return InkWell(
                        onTap: (){
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => const OwnerViewOrderListPage(),
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 9, 255, 17),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 34, 146, 0).withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: const Text('View order here'),
                        ),
                      );
                    }
                  }
                )
              ],
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: '', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Start your order now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),

                  const SizedBox(height: 30),

                  StreamBuilder<List<OrderOwnerModel>>(
                    stream: orderService.getOrderMethods(),
                    builder: (context, AsyncSnapshot<List<OrderOwnerModel>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      List<OrderOwnerModel>? orderMethods = snapshot.data;
                      if (orderMethods == null || orderMethods.isEmpty) {
                        return Container(
                          width: width * 0.75,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 255, 196, 108)),
                            color: const Color.fromARGB(255, 255, 196, 108),
                          ),
                          child: const Center(
                            child: Text(
                              'No order available',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: orderMethods.map(
                          (order) {
                            return buildOrderTile(order, width, height);
                          },
                        ).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              orderOpenPageRoute, 
              (route) => false,
            );
          },
          shape: const CircleBorder(
            side: BorderSide()
          ),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}