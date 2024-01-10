import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/users/customer_page/delivery_progress/delivery_list_page.dart';

class DeliveryProgressWidget extends StatefulWidget {
  const DeliveryProgressWidget({
    required this.orderOpened,
    super.key
  });

  final OrderOwnerModel? orderOpened;

  @override
  State<DeliveryProgressWidget> createState() => _DeliveryProgressWidgetState();
}

class _DeliveryProgressWidgetState extends State<DeliveryProgressWidget> {

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
            fontSize: 16,
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
          color: const Color.fromARGB(255, 191, 220, 182),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const CustViewDeliveryListPage()
              );
              Navigator.push(context, route);
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
                          'images/food_delivery.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Delivery Progress',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<List<OrderCustModel>>(
                        stream: custOrderService.getOrderById(userID), 
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return displayBar('Error: ${snapshot.error}', false);
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty){
                            return displayBar('No order placed', false);
                          } else{
                            List<OrderCustModel> orders = snapshot.data!;
                            bool isDeliveryStart = orders.any((order) => order.deliveryStatus == 'Start');
                            if (isDeliveryStart) {
                              return displayBar('Delivery start', true);
                            }else{
                              return displayBar('Delivery end', false);
                            }
                          }
                        }
                      )
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