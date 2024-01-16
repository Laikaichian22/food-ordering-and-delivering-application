import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_selected_orderpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CustViewOrderListPage extends StatefulWidget {
  const CustViewOrderListPage({super.key});

  @override
  State<CustViewOrderListPage> createState() => _CustViewOrderListPageState();
}

class _CustViewOrderListPageState extends State<CustViewOrderListPage> {
  @override
  Widget build(BuildContext context) {
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Order List', 
          userRole: 'customer',
          onPress: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              customerRoute,
              (route) => false,
            );
          },
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Your order list',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<List<OrderCustModel>>(
                  stream: custOrderService.getOrderById(userID), 
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
                            "You haven't placed any order yet",
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
                        if (a.delivered == 'Yes' && b.delivered != 'Yes') {
                          return -1;
                        } else if (a.delivered != 'Yes' && b.delivered == 'Yes') {
                          return 1; 
                        } else {
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
                                    tileColor: order.delivered == 'Yes' ? orderDeliveredColor : Colors.white,
                                    shape: BeveledRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    contentPadding: const EdgeInsetsDirectional.all(16),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Order for: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.menuOrderName,
                                            style: const TextStyle(
                                              fontSize: 14
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Your order: ${order.orderDetails}\nOrder placed at: ${DateFormat('yyyy-MM-dd hh:mm a').format(order.dateTime!)}',
                                      style: const TextStyle(
                                        fontSize: 13
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 50,
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => CustViewOrderPage(orderSelected: order, type: 'Place'),
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
                                          height: 23,
                                          width: 80,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: deliveredClipBarTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (order.isCollected == 'Yes')
                                    Positioned(
                                      top: 0,
                                      right: 250,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: collectedBarColor, 
                                          height: 23,
                                          width: 80,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Collected',
                                            style: TextStyle(
                                              color: collectedBarTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (order.isCollected == 'No' && order.delivered == 'Yes')
                                    Positioned(
                                      top: 0,
                                      right: 165,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: statusRedColor,
                                          height: 23,
                                          width: 130,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Not yet collected',
                                            style: TextStyle(
                                              color: yellowColorText,
                                              fontWeight: FontWeight.bold,
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
      )
    );
  }
}