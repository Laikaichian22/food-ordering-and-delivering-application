import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/completed_order/completed_delivery_list_page.dart';

class TotalCompletedOrders extends StatefulWidget {
  const TotalCompletedOrders({
    required this.orderDeliveryOpened,
    super.key
  });

  final OrderOwnerModel? orderDeliveryOpened;

  @override
  State<TotalCompletedOrders> createState() => _TotalCompletedOrdersState();
}

class _TotalCompletedOrdersState extends State<TotalCompletedOrders> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  @override
  Widget build(BuildContext context) { 
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
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
          color: const Color.fromARGB(255, 235, 221, 188),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryViewCompletedOrders(orderDeliveryOpened: widget.orderDeliveryOpened)
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
                          'images/delivered_order.png',
                          width: 80,
                          height: 80,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Total Delivered Orders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: widget.orderDeliveryOpened == null
                        ? Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: statusRedColor
                            ),
                            child: const Text(
                              'No order for delivery',
                              style: TextStyle(
                                color: yellowColorText
                              ),
                            ),
                          )
                        : StreamBuilder(
                          stream: custOrderService.getCompletedOrder(widget.orderDeliveryOpened!.id!), 
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
                                  fontSize: 19.0,
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
