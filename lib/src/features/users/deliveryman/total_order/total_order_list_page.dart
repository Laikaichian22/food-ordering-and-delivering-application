import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_total_order.dart';

class DeliveryViewTotalOrderPage extends StatefulWidget {
  const DeliveryViewTotalOrderPage({super.key});

  @override
  State<DeliveryViewTotalOrderPage> createState() => _DeliveryViewTotalOrderPageState();
}

class _DeliveryViewTotalOrderPageState extends State<DeliveryViewTotalOrderPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  Widget orderStatusBar(String detailsTxt){
    return Positioned(
      top: 55,
      right: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.amber, 
          height: 23,
          width: 160,
          alignment: Alignment.center,
          child: Text(
            detailsTxt,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'Total Orders', 
          barColor: deliveryColor, 
          userRole: 'deliveryMan',
          textSize: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder<List<OrderCustModel>>(
                  future: custOrderService.getDistinctMenuOrderIds(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No Menu_orderId found');
                    } else{
                      List<OrderCustModel> distinctOrdersMenuId = snapshot.data!;
                      return Column(
                        children: distinctOrdersMenuId.map((order) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    tileColor: const Color.fromARGB(255, 36, 255, 251),
                                    shape: BeveledRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    contentPadding: const EdgeInsetsDirectional.all(12),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Orders For: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.menuOrderName,
                                            style: const TextStyle(
                                              fontSize: 16
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => DeliveryManTotalOrderPage(orderDeliveryOpened: order)
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  StreamBuilder<List<OrderCustModel>>(
                                    stream: custOrderService.getOrderByOrderId(order.menuOrderID!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return orderStatusBar('No order');
                                      }else{
                                        List<OrderCustModel> orders = snapshot.data!;
                                        int totalOrders = orders.length;
                                        return totalOrders > 1 
                                        ? orderStatusBar('Total: $totalOrders orders')
                                        : orderStatusBar('Total: $totalOrders order');
                                      }
                                    },
                                  ),
                                ],
                              )
                            ]
                          );
                        }).toList(),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}