import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/pending_order/pending_order_list_page.dart';

class TotalPendingOrders extends StatefulWidget {
  const TotalPendingOrders({
    required this.orderDeliveryOpened,
    super.key
  });

  final OrderOwnerModel? orderDeliveryOpened;

  @override
  State<TotalPendingOrders> createState() => _TotalPendingOrdersState();
}

class _TotalPendingOrdersState extends State<TotalPendingOrders> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  
  @override
  Widget build(BuildContext context) { 
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0, 
            spreadRadius: 0.0,
            offset: const Offset(
              5.0, 
              5.0, 
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: const Color.fromARGB(255, 211, 169, 243),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryViewPendingOrderPage()
                )
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/pending_order.png',
                          width: 80,
                          height: 80,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Total Pending Orders',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: custOrderService.getDeliveryManPendingOrder(userId), 
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              );
                            }else {
                              List<OrderCustModel> orders = snapshot.data!;
                              int totalOrders = orders.length;
                              return Text(
                                '$totalOrders',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              );
                            }
                          }
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}