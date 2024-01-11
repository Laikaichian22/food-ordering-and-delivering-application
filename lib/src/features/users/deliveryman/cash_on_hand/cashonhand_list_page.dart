import 'package:flutter/material.dart';
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

    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: '', 
          barColor: deliveryColor, 
          textSize: 0,
          userRole: 'deliveryMan'
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'List of delivery',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight:FontWeight.bold
                  )
                ),
                const SizedBox(height: 20),
                const Text(
                  'You can view the value of cash on hand for each delivery.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  )
                ),
                const SizedBox(height: 10),
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
                                    contentPadding: const EdgeInsetsDirectional.all(11),
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
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => DeliveryCashOnHandPage(orderDelivery: order)
                                      );
                                      Navigator.push(context, route);
                                    },
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
            ),
          ),
        ),
      )
    );
  }
}