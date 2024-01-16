import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';

import '../../../../../../services/firestoreDB/paymethod_db_service.dart';

class OwnerViewSelectedOrderPage extends StatefulWidget {
  const OwnerViewSelectedOrderPage({
    required this.orderSelected,
    required this.type,
    super.key
  });

  final OrderCustModel orderSelected;
  final String type;

  @override
  State<OwnerViewSelectedOrderPage> createState() => _OwnerViewSelectedOrderPageState();
}

class _OwnerViewSelectedOrderPageState extends State<OwnerViewSelectedOrderPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final PayMethodDatabaseService paymentService = PayMethodDatabaseService();
  @override
  Widget build(BuildContext context) {
    
    Widget buildRefund(String title, String details){
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: details == '' 
                ? InkWell(
                    onTap: ()async{
                      await custOrderService.updateRefundState(widget.orderSelected.id!);
                      setState(() {
                        details = 'Yes';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                        color: Colors.amber,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), 
                            spreadRadius: 2,
                            blurRadius: 1.5,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Click to refund', 
                          style: TextStyle(
                            fontSize: 17
                          )
                        )
                      ),
                    ),
                  )
                : Container(
                  padding: const EdgeInsets.all(3),
                  color: const Color.fromARGB(255, 0, 255, 8),
                    child: const Center(
                      child: Text(
                        'Refunded',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
          const SizedBox(height: 5),
          const Divider(thickness: 3),
        ],
      );
    }

    Widget buildDetailTile(String title, String details){
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: title == 'Payment Status'
                ? details == 'No'
                  ? widget.type == 'Cancel' 
                    ? const Text(
                        "Not need to pay",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 34, 0),
                          fontSize: 20
                        ),
                      )
                    : const Text(
                        "Not yet paid",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 34, 0),
                          fontSize: 20
                        ),
                      )
                  : const Text(
                      "Paid",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 185, 9),
                        fontSize: 20
                      ),
                    )
                : Text(
                    details,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
              ),
            ]
          ),
          const SizedBox(height: 5),
          const Divider(thickness: 3),
        ],
      );
    }

    Widget buildReceiptTile(String title, String subtitle, String receiptUrl){
      return Center(
        child: Column(     
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 18
              ),
            ),
            const SizedBox(height: 5),
            Image.network(
              receiptUrl,
              width: 280,
              height: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 3),
          ] 
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: widget.type == 'Place' ? "${widget.orderSelected.custName}'s Order" : "${widget.orderSelected.custName}'s Cancelled Order",
          userRole: 'owner',
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<OrderCustModel?>(
              future: widget.type == 'Place' ? custOrderService.getCustOrderById(widget.orderSelected.id!) : custOrderService.getCustCancelledOrderById(widget.orderSelected.id!),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    child: const Center(
                      child: Text(
                        "Error in fetching data of this order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30
                        ),
                      )
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    child: const Center(
                      child: Text(
                        "No data for this order",
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
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18
                          ),
                          children: [
                            const TextSpan(
                              text: 'Order for menu: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            TextSpan(
                              text: order.menuOrderName, 
                              style: const TextStyle(
                                fontSize: 16
                              )
                            )
                          ]
                        )
                      ),
                      
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            order.paid == 'Yes' 
                            ? widget.type == 'Cancel' 
                              ? buildRefund('Refund', '${order.refund}') 
                              : Container() 
                            : Container(),
                            buildDetailTile('Email Address', '${order.email}'),
                            buildDetailTile('Phone Number', '${order.phone}'),
                            buildDetailTile('Destination', '${order.destination}'),
                            buildDetailTile('Name', '${order.custName}'),
                            buildDetailTile('Remark', '${order.remark}'),
                            buildDetailTile('Order 1', '${order.orderDetails}'),
                            buildDetailTile('Amount paid', 'RM${order.payAmount!.toStringAsFixed(2)}'),
                            FutureBuilder(
                              future: paymentService.getPayMethodDetails(order.payMethodId!), 
                              builder:(context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const CircularProgressIndicator();
                                }else if (snapshot.hasError){
                                  return buildDetailTile('Error', 'Error in fetching payment data');
                                }else if(!snapshot.hasData || snapshot.data == null){
                                  return buildDetailTile('Error', 'No data available');
                                }else{
                                  PaymentMethodModel payMethodDetails = snapshot.data!;
                                  return buildDetailTile('Payment Method', '${payMethodDetails.methodName}');
                                }
                              },
                            ),
                            buildDetailTile('Payment Status', '${order.paid}'),
                            buildDetailTile('Feedback', '${order.feedback}'),
                            order.receipt == ''
                            ? Container()
                            : buildReceiptTile('Receipt', 'Payment details.', '${order.receipt}'),
                            
                            widget.type == 'Place'
                            ? Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                color: order.delivered == 'Yes' ? const Color.fromARGB(255, 0, 255, 8) : Colors.amber,
                                child: order.delivered == 'Yes'
                                ? const Text(
                                    'This order has been delivered.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  )
                                : const Text(
                                    'This order has not been delivered yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                              )
                            : Container(),
                            const SizedBox(height: 10),
                            order.delivered == 'Yes'
                            ? Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                color: order.isCollected == 'Yes' ? const Color.fromARGB(255, 0, 255, 8) : Colors.amber,
                                child: 
                                order.isCollected == 'Yes'
                                ? const Text(
                                    'Customer has collected this order.',
                                    textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                  )
                                : const Text(
                                    'Customer has not collect this order yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ) 
                            : Container()  
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
            )
          ),
        ),
      )
    );
  }
}