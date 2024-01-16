import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/completed_order/delivery_completed.dart';

class DeliveryViewCompletedOrders extends StatefulWidget {
  const DeliveryViewCompletedOrders({
    super.key
  });

  @override
  State<DeliveryViewCompletedOrders> createState() => _DeliveryViewCompletedOrdersState();
}

class _DeliveryViewCompletedOrdersState extends State<DeliveryViewCompletedOrders> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  Widget orderStatusBar(String detailsTxt, bool greenStatus){
    return Positioned(
      top: 55,
      right: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: greenStatus ? hasThisOrderColor : noSuchOrderColor, 
          height: 23,
          width: 210,
          alignment: Alignment.center,
          child: Text(
            detailsTxt,
            style: TextStyle(
              color: greenStatus ?Colors.black : yellowColorText,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'Completed Order List', 
          barColor: deliveryColor, 
          userRole: 'deliveryMan',
          textSize: 21,
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
                      return Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: const Center(
                          child: Text(
                            "No order for delivery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )
                        ),
                      );
                    } else {
                      List<OrderCustModel> distinctOrdersMenuId = snapshot.data!;
                      return Column(
                        children: distinctOrdersMenuId.map((order){
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    tileColor: orderForDeliveryTile,
                                    shape: BeveledRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    contentPadding: const EdgeInsetsDirectional.all(11),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Order For: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.menuOrderName,
                                            style: const TextStyle(
                                              fontSize: 15
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
                                        builder: (context) => OrderCompletedPage(orderDeliveryOpened: order, userId: userId,)
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  StreamBuilder<List<OrderCustModel>>(
                                    stream: custOrderService.getDeliveryManSpecificCompletedOrder(order.menuOrderID!, userId),
                                    builder: (context, snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return orderStatusBar('Error: ${snapshot.error}', false);
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return orderStatusBar('No completed order', false);
                                      }else {
                                        List<OrderCustModel> orders = snapshot.data!;
                                        int totalOrders = orders.length;
                                        return totalOrders > 1 
                                        ? orderStatusBar('Total: $totalOrders completed orders', true)
                                        : orderStatusBar('Total: $totalOrders completed order', true);
                                      }
                                    }
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20)
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