import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_total_order.dart';

class TotalOrders extends StatefulWidget {
  const TotalOrders({
    required this.orderDeliveryOpened,
    super.key
  });

  final OrderOwnerModel? orderDeliveryOpened;

  @override
  State<TotalOrders> createState() => _TotalOrdersState();
}

class _TotalOrdersState extends State<TotalOrders> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  
  @override
  Widget build(BuildContext context) {

    return Container(
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
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: const Color.fromARGB(255, 200, 240, 243),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryManTotalOrderPage(orderDeliveryOpened: widget.orderDeliveryOpened,)
                )
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/schedule.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            'Total Orders',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                              stream: custOrderService.getOrderByOrderId(widget.orderDeliveryOpened!.id!), 
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 10.0,
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