import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_selected_orderpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CustCancelOrderPage extends StatefulWidget {
  const CustCancelOrderPage({super.key});

  @override
  State<CustCancelOrderPage> createState() => _CustCancelOrderPageState();
}

class _CustCancelOrderPageState extends State<CustCancelOrderPage> {
  Widget buildOwnerDetails(String title, String details){
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black
        ),
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            )
          ),
          TextSpan(
            text: details,
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final UserDatabaseService userService = UserDatabaseService();
    final PayMethodDatabaseService paymentService = PayMethodDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Order Cancelled', 
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'If you have make your payment, please contact the business owner for MONEY REFUND.',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('\nHere are the contact information:')
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: FutureBuilder<UserModel?>(
                    future: userService.getBusinessOwnerData(), 
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data');
                      } else {
                        UserModel deliveryData = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildOwnerDetails('Name: \t', deliveryData.fullName!),
                            buildOwnerDetails('Phone number: \t', deliveryData.phone!),
                            buildOwnerDetails('Email: \t', deliveryData.email!),
                          ],
                        );
                      }
                    }
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
                      orders.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
                      return Column(
                        children: orders.map((order){
                          return Column(
                            children: [
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
                                    FutureBuilder(
                                      future: paymentService.getPayMethodDetails(order.payMethodId!), 
                                      builder:(context, snapshot) {
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const CircularProgressIndicator();
                                        }else if (snapshot.hasError){
                                          return const Text('Error in fetching payment data');
                                        }else if(!snapshot.hasData || snapshot.data == null){
                                          return const Text('No data available');
                                        }else{
                                          PaymentMethodModel payMethodDetails = snapshot.data!;
                                          return Column(
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
                                                      text: payMethodDetails.methodName,
                                                      style: const TextStyle(
                                                        color: purpleColorText
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
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
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11),
                                            color: order.paid == 'No' 
                                            ? statusRedColor
                                            : statusYellowColor
                                          ),
                                          child: order.paid == 'No'
                                          ? const Text(
                                              'Not need to pay',
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
                                    order.paid == 'Yes'
                                    ? Row(
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
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(11),
                                              color: order.refund == 'Yes' 
                                              ? statusYellowColor
                                              : statusRedColor
                                            ),
                                            child: 
                                            order.refund == 'Yes'
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
                                    : Container()
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 105, 1, 107),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => CustViewOrderPage(orderSelected: order, type: 'Cancel'),
                                  );
                                  Navigator.push(context, route);
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList()
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