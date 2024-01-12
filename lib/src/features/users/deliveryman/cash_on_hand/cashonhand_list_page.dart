import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/cash_on_hand/cash_on_hand_page.dart';

class DeliveryViewCashOnHandListPage extends StatefulWidget {
  const DeliveryViewCashOnHandListPage({super.key});

  @override
  State<DeliveryViewCashOnHandListPage> createState() => _DeliveryViewCashOnHandListPageState();
}

class _DeliveryViewCashOnHandListPageState extends State<DeliveryViewCashOnHandListPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'List of delivery', 
          barColor: deliveryColor, 
          textSize: 0,
          userRole: 'deliveryMan'
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
                              const Text(
                                'You can view the value of cash on hand for each delivery.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                )
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                children: [
                                  ListTile(
                                    tileColor: order.deliveryManId!=userID ? noSuchOrderColor : hasThisOrderColor,
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
                                          TextSpan(
                                            text: 'Delivery For: ',
                                            style: TextStyle(
                                              color: order.deliveryManId!=userID ? yellowColorText : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.menuOrderName,
                                            style: TextStyle(
                                              color: order.deliveryManId!=userID ? yellowColorText : Colors.black,
                                              fontSize: 14
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: order.deliveryManId!=userID ? const Text('No order for you',style: TextStyle(color: yellowColorText),) : const Text('Press to view order assigned'),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 40,
                                    ),
                                    onTap: order.deliveryManId!=userID 
                                    ? null 
                                    : () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => DeliveryCashOnHandPage(orderDelivery: order)
                                      );
                                      Navigator.push(context, route);
                                    },
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
            ),
          ),
        ),
      )
    );
  }
}