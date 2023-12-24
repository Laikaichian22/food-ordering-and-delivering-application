import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_selected_orderpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

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
        appBar: GeneralAppBar(
          title: 'Order List', 
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
                      return Column(
                        children: orders.map((order) {
                          return Column(
                            children: [
                              ListTile(
                                shape: BeveledRectangleBorder(
                                  side: const BorderSide(width: 0.5),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                contentPadding: const EdgeInsetsDirectional.all(10),
                                title: Text(
                                  'Order for: ${order.menuOrderName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text('Your order: ${order.orderDetails}'),
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 50,
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => CustViewOrderPage(orderSelected: order),
                                  );
                                  Navigator.push(context, route);
                                },
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