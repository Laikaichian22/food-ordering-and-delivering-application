import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/delivery_progress/custdelivery_mainpage.dart';

class CustViewDeliveryListPage extends StatefulWidget {
  const CustViewDeliveryListPage({super.key});

  @override
  State<CustViewDeliveryListPage> createState() => _CustViewDeliveryListPageState();
}

class _CustViewDeliveryListPageState extends State<CustViewDeliveryListPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'Delivery List', 
          barColor: custColor,
          textSize: 0,
          userRole: 'customer'
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Order Delivery list',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<OrderCustModel>>(
                  future: custOrderService.getDistinctMenuOrderIds(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No Menu_orderId found');
                    } else {
                      List<OrderCustModel> distinctOrdersMenuId = snapshot.data!;
                      return Column(
                        children: distinctOrdersMenuId.map((order){
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    tileColor: Colors.lime,
                                    shape: BeveledRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    contentPadding: const EdgeInsetsDirectional.all(10),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Delivery For: ',
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
                                    subtitle: StreamBuilder<List<OrderCustModel>>(
                                      stream: custOrderService.getOrderByOrderId(order.menuOrderID!),
                                      builder: (context, snapshot){
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Text('Empty data');
                                        }else {
                                          List<OrderCustModel> orders = snapshot.data!;
                                          int totalOrders = orders.length;
                                          return totalOrders > 1 
                                          ? Center(
                                            child: Text(
                                              'You have $totalOrders orders',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: purpleColorText
                                              ),
                                            ),
                                          )
                                          : Text(
                                              'You have $totalOrders order',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: purpleColorText
                                              ),
                                            );
                                        }
                                      }
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => CustDeliveryProgressPage(orderSelected: order)
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  if(order.deliveryStatus == 'Start')
                                    Positioned(
                                      top: 0,
                                      right: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: deliveredClipBarColor, 
                                          height: 23,
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Delivery Start',
                                            style: TextStyle(
                                              color: deliveredClipBarTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(order.deliveryStatus == 'End')
                                    Positioned(
                                      top: 0,
                                      right: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: statusRedColor, 
                                          height: 23,
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Delivery End',
                                            style: TextStyle(
                                              color: yellowColorText,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}