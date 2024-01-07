import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_list_order.dart';

class ViewOrderWidget extends StatefulWidget {
  const ViewOrderWidget({super.key});

  @override
  State<ViewOrderWidget> createState() => _ViewOrderWidgetState();
}

class _ViewOrderWidgetState extends State<ViewOrderWidget> {
  @override
  Widget build(BuildContext context) {
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    
    Widget displayBar(String text, bool placed){
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          color: placed == true ? orderOpenedColor : orderClosedColor
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: placed == true ? Colors.black : errorTextColor
          ),
        ),
      );
    }

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
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const CustViewOrderListPage()
              );
              Navigator.push(context, route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/view_order_detail.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'View Order Details',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 5),
                      StreamBuilder<List<OrderCustModel>>(
                        stream: custOrderService.getOrderById(userID), 
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return displayBar('Error: ${snapshot.error}', false);
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return displayBar('No order placed yet', false);
                          }else {
                            List<OrderCustModel> orders = snapshot.data!;
                            int totalOrders = orders.length;
                            return Column(
                              children: [
                                displayBar('You have place $totalOrders order', true),
                                const SizedBox(height: 10),
                                Text(
                                  '$totalOrders',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              ],
                            );
                          }
                        }   
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