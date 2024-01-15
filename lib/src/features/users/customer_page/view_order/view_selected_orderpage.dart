import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/edit_order.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CustViewOrderPage extends StatefulWidget {
  const CustViewOrderPage({
    required this.orderSelected,
    required this.type,
    super.key
  });

  final OrderCustModel orderSelected;
  final String type;

  @override
  State<CustViewOrderPage> createState() => _CustViewOrderPageState();
}

class _CustViewOrderPageState extends State<CustViewOrderPage> {

  OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  PayMethodDatabaseService paymentService = PayMethodDatabaseService();
  DateTime now = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  OrderOwnerModel? currentOrderOpened;
  late Future<void> orderOpenedStatusFuture;
  Future<void> loadOpenedStatusState()async{
    currentOrderOpened = await ownerOrderService.getTheOpenedOrder();
  }

  @override
  void initState(){
    super.initState();
    orderOpenedStatusFuture = loadOpenedStatusState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget buildRefundTile(String title, String details){
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
              border: Border.all(),
              color: details == '' ? notYetRefundColor : refundColor
            ),
            child: Text(
              details == '' ? 'Not yet refund' : 'Refunded',
              style: const TextStyle(
              fontSize: 17
            ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(thickness: 3),
        ]
      );
    }

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
          const Divider(thickness: 3),
        ]
      );
    }
    Widget buildReceiptTile(String title, String subtitle, String receiptUrl){
      return Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15
            ),
          ),
          const SizedBox(height: 5),
          Image.network(
            receiptUrl,
            width: 250,
            height: 500,
            fit: BoxFit.fill,
          )
        ] 
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: DirectAppBarNoArrow(
          title: 'Your order', 
          userRole: 'customer',
          textSize: 0,
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<OrderCustModel?>(
              future: widget.type == 'Cancel' ? custOrderService.getCustCancelledOrderById(widget.orderSelected.id!) : custOrderService.getCustOrderById(widget.orderSelected.id!), 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                        "Error in fetching data of your order. Press try again",
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
                        'Menu: ${order.menuOrderName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Order placed at ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(order.dateTime!)}',
                        style: const TextStyle(
                          fontSize: 16
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
                            order.paid == 'Yes' 
                            ? widget.type == 'Cancel' 
                              ? buildRefundTile('Refund', '${order.refund}') 
                              : Container() 
                            : Container(),
                            buildDetailTile('Email Address', '${order.email}'),
                            buildDetailTile('Phone Number', '${order.phone}'),
                            buildDetailTile('Pickup your Oder at?', '${order.destination}'),
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
                            order.receipt == '' 
                            ? const Text(
                                "You haven't paid for this order yet, please make sure you make your payment by today.",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 34, 0),
                                  fontSize: 20
                                ),
                              )
                            : buildReceiptTile('Receipt', 'You have made your payment. This is your receipt.', '${order.receipt}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      widget.type == 'Cancel' 
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.lime,
                            child: const Text(
                              'You have cancelled this order.',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                        )
                      : order.delivered == 'No' 
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              currentOrderOpened == null 
                              ? Container(
                                padding: const EdgeInsets.all(5),
                                  width: width*0.39,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: const Color.fromARGB(255, 213, 213, 213)
                                  ),
                                  child: const Text('Order closed. No more cancellation allowed'),
                                )
                              : SizedBox(
                                  height: 50,
                                  width: width*0.41,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 255, 38, 23), 
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                      ),
                                      elevation: 10,
                                      shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                    ),
                                    onPressed: (){
                                      DateTime currentTime = DateTime.now();
                                      if(currentTime.isBefore(currentOrderOpened!.endTime!)){
                                        showDialog(
                                          context: _scaffoldKey.currentContext!,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: const Text(
                                                'Order cancellation',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                                ),
                                              ),
                                              content: const Text('Confirm to cancel this order?', style: TextStyle(fontSize: 22),),
                                              actions: [
                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: cancelTextColor
                                                    ),
                                                  )
                                                ),
                                                TextButton(
                                                  onPressed: ()async {
                                                    await custOrderService.cancelOrder(widget.orderSelected);
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                      viewCustOrderListPageRoute,
                                                      (route) => false,
                                                    );
                                                  }, 
                                                  child: const Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: confirmTextColor
                                                    ),
                                                  )
                                                ),
                                              ],
                                            );
                                          }
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Cancel order',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 255, 221, 120)
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 50,
                                width: width*0.37,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 0, 255, 8), 
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                    ),
                                    elevation: 10,
                                    shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                  ),
                                  onPressed: (){
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context) => CustEditSelectedOrderPage(orderSelected: widget.orderSelected)
                                    );
                                    Navigator.push(context, route);
                                  },
                                  child: const Text(
                                    'Edit order',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(
                          width: double.infinity,
                          height: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          color: orderDeliveredColor,
                          child: const Text(
                            'Order delivered',
                            style: TextStyle(
                              fontSize: 40
                            ),
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