import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_selected_orderpage.dart';

class ViewCustOrderListPage extends StatefulWidget {
  const ViewCustOrderListPage({super.key});

  @override
  State<ViewCustOrderListPage> createState() => _ViewCustOrderListPageState();
}

class _ViewCustOrderListPageState extends State<ViewCustOrderListPage> {
  @override
  Widget build(BuildContext context) {
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;


    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Order List', 
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
                      return Center(
                        child: Container(
                          height: 100,
                          width: 300,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              OrderCustModel order = orders[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Order for: ${order.menuOrder}',
                                      style: const TextStyle(
                                        fontSize: 18
                                      ),
                                    ),
                                    subtitle: Text('Your order: ${order.orderDetails}'),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 50,
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => const ViewCustOrderPage()
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  const SizedBox(height:10),
                                ],
                              );
                            },
                          ),
                        ),
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