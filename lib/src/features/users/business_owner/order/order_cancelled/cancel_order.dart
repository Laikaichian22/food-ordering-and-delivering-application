import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/order_list/order_details.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CancelledOrderInOwnerPage extends StatefulWidget {
  const CancelledOrderInOwnerPage({super.key});

  @override
  State<CancelledOrderInOwnerPage> createState() => _CancelledOrderInOwnerPageState();
}

class _CancelledOrderInOwnerPageState extends State<CancelledOrderInOwnerPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Order cancelled', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute,
              (route) => false,
            );
          }, 
          barColor: ownerColor, 
          userRole: 'owner'
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder(
                  stream: custOrderService.getAllCancelledOrder(), 
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
                            "No order cancelled",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )
                        ),
                      );
                    }else{
                      List<OrderCustModel> orders = snapshot.data!;
                      return Column(
                        children: orders.map((order){
                          return Column(
                            children: [
                              const Text(
                                "For the orders with 'Paid' payment status, You can refund the money back to the customer.",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListTile(
                                tileColor: order.refund == 'Yes' ? refundColor : notYetRefundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsetsDirectional.all(10),
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Customer Name: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: order.custName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: purpleColorText
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Location: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.destination,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                          const TextSpan(
                                            text: '\nOrder detail: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.orderDetails,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                          const TextSpan(
                                            text: '\nPayment method: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: order.payMethod,
                                            style: const TextStyle(
                                              color: purpleColorText
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Payment status:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 110,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11),
                                            color: order.paid == 'No' 
                                            ? statusRedColor
                                            : statusYellowColor
                                          ),
                                          child: order.paid == 'No'
                                          ? const Text(
                                            'Not Yet Paid',
                                            style: TextStyle(
                                              color: yellowColorText,
                                              fontWeight: FontWeight.bold
                                            ),
                                            )
                                          : const Text(
                                              'Paid',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Text(
                                          'Refund status:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 110,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11),
                                            color: order.refund == 'Yes' 
                                            ? statusYellowColor
                                            : statusRedColor
                                          ),
                                          child: order.refund == 'Yes'
                                          ? const Text(
                                            'Refund',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                            ),
                                            )
                                          : const Text(
                                              'Not yet refund',
                                              style: TextStyle(
                                                color: yellowColorText,
                                                fontWeight: FontWeight.w500
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 105, 1, 107),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => OwnerViewSelectedOrderPage(orderSelected: order, type: 'Cancel'),
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