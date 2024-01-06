import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CustCancelOrderPage extends StatefulWidget {
  const CustCancelOrderPage({super.key});

  @override
  State<CustCancelOrderPage> createState() => _CustCancelOrderPageState();
}

class _CustCancelOrderPageState extends State<CustCancelOrderPage> {
  @override
  Widget build(BuildContext context) {
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Order List', 
          userRole: 'customer',
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
                  'Order cancelled',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<List<OrderCustModel>>(
                  stream: custOrderService.getCancelledOrderById(userID), 
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
                            "Empty order cancelled",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )
                        ),
                      );
                    }else{
                      List<OrderCustModel> orders = snapshot.data!;
                      orders.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
                      return Column(
                        children: [

                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}