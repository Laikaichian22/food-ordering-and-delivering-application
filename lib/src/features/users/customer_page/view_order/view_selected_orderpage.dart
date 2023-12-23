import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:intl/intl.dart';

class ViewCustOrderPage extends StatefulWidget {
  const ViewCustOrderPage({super.key});

  @override
  State<ViewCustOrderPage> createState() => _ViewCustOrderPageState();
}

class _ViewCustOrderPageState extends State<ViewCustOrderPage> {
  OrderCustDatabaseService custOrderService = OrderCustDatabaseService();

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    Widget buildDetailTile(String title, String details){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 300,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Text(
              details,
              style: const TextStyle(
              fontSize: 17
            ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            thickness: 3,
          ),
        ]
      );
    }
    Widget buildReceiptTile(String title, String receiptUrl){
      return Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(height: 5),
          Image.network(
            receiptUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        ]
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Your order', 
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<OrderCustModel?>(
              future: custOrderService.getCustOrderById(userID), 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
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
                } else{
                  OrderCustModel order = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu: ${order.menuOrder}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Order placed at ${DateFormat('yyyy-MM-dd hh:mm:ss').format(order.dateTime!)}',
                        style: const TextStyle(
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: Column(
                          children: [
                            buildDetailTile('Email address', '${order.email}'),
                            buildDetailTile('Phone number', '${order.phone}'),
                            buildDetailTile('Pickup your Oder at?', '${order.destination}'),
                            buildDetailTile('Name', '${order.custName}'),
                            buildDetailTile('Remark', '${order.remark}'),
                            buildDetailTile('Order 1', '${order.orderDetails}'),
                            buildDetailTile('Amount paid', '${order.payAmount}'),
                            buildDetailTile('Payment method', '${order.payMethod}'),
                            order.receipt == '' 
                            ? Container()
                            : buildReceiptTile('Receipt', '${order.receipt}')
                          ],
                        ),
                      )
                    ],
                  );
                }
              }
            ),
          )   
        ),
      )
    );
  }
}