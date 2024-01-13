import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delivery_progress/deliveryman_list.dart';

class OrderDeliveryListPage extends StatefulWidget {
  const OrderDeliveryListPage({super.key});

  @override
  State<OrderDeliveryListPage> createState() => _OrderDeliveryListPageState();
}

class _OrderDeliveryListPageState extends State<OrderDeliveryListPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final OrderOwnerDatabaseService orderOpenedService = OrderOwnerDatabaseService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'Order List For Delivery', 
          barColor: ownerColor, 
          textSize: 20,
          userRole: 'owner'
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder<List<OrderOwnerModel>>(
                  stream: orderOpenedService.getOrderLists(),
                  builder: (context, AsyncSnapshot<List<OrderOwnerModel>> snapshot) {
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
                      List<OrderOwnerModel> orderList = snapshot.data!;
                      orderList.sort((a, b) => a.startTime!.compareTo(b.startTime!));
                      return Column(
                        children: orderList.map((order){
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    tileColor: order.openForDeliveryStatus == 'Yes' ? orderOpenedForDeliveryColor : orderClosedForDeliveryColor,
                                    shape: BeveledRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    contentPadding: const EdgeInsetsDirectional.all(11),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Order: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.orderName,
                                            style: const TextStyle(
                                              fontSize: 18
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 58, 58, 58),
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Created Date: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.openDate,
                                            style: const TextStyle(
                                              fontSize: 14
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
                                        builder: (context) => DeliveryManListPage(orderSelected: order)
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  Positioned(
                                    top: 70,
                                    right: 20,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        color: order.openForDeliveryStatus == 'Yes' ? statusYellowColor : statusRedColor, 
                                        height: 23,
                                        width: 170,
                                        alignment: Alignment.center,
                                        child: Text(
                                          order.openForDeliveryStatus == 'Yes' ? 'Ready for delivery' : 'Not ready for delivery',
                                          style: TextStyle(
                                            color: order.openForDeliveryStatus == 'Yes' ?Colors.black : yellowColorText,
                                            fontSize: 16
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20,)
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}