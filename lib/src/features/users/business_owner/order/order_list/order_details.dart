import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';

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
  @override
  Widget build(BuildContext context) {
    Widget buildDetailTile(String title, String details){
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
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
                child: title == 'Payment Status'
                ? details == 'No'
                  ? const Text(
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
                      fontSize: 18,
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
              width: 200,
              height: 280,
              fit: BoxFit.cover,
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
          title: "${widget.orderSelected.custName}'s Order",
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
                            fontSize: 20
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
                                fontSize: 18
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
                            buildDetailTile('Email Address', '${order.email}'),
                            buildDetailTile('Phone Number', '${order.phone}'),
                            buildDetailTile('Destination', '${order.destination}'),
                            buildDetailTile('Name', '${order.custName}'),
                            buildDetailTile('Remark', '${order.remark}'),
                            buildDetailTile('Order 1', '${order.orderDetails}'),
                            buildDetailTile('Amount paid', 'RM${order.payAmount!.toStringAsFixed(2)}'),
                            buildDetailTile('Payment Method', '${order.payMethod}'),
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