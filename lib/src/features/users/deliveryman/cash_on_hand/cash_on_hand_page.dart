import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/delivery_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/delivery.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';

class DeliveryCashOnHandPage extends StatefulWidget {
  const DeliveryCashOnHandPage({
    required this.orderDelivery,
    super.key
  });
  final OrderCustModel orderDelivery;

  @override
  State<DeliveryCashOnHandPage> createState() => _DeliveryCashOnHandPageState();
}

class _DeliveryCashOnHandPageState extends State<DeliveryCashOnHandPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController cashOnHandController = TextEditingController();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Widget getOrderList(OrderCustModel orderDetails){
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 20.0, 
              spreadRadius: 0.0,
              offset: const Offset(
                5.0, 
                5.0,
              ),
            )
          ]
        ),
        child: Card(
          color: orderDetails.delivered == 'Yes' ? orderDeliveredColor : orderHasNotDeliveredColor,
          clipBehavior: Clip.hardEdge,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderDetails.custName!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: orderDetails.delivered == 'Yes' ? statusYellowColor : onTheWayBarColor
                      ),
                      child: orderDetails.delivered == 'Yes' 
                      ? const Text(
                          'Delivered',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          )
                        )
                      : const Text(
                          'On the way',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: yellowColorText
                          )
                        )
                    )
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Payment Type: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: orderDetails.payMethod!,
                          )
                        ]
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Destination: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: orderDetails.destination!,
                          )
                        ]
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Amount: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold 
                            )
                          ),
                          TextSpan(
                            text: 'RM${orderDetails.payAmount!.toStringAsFixed(2)}',
                          )
                        ]
                      ),
                    ),
                    InkWell(
                      onTap: orderDetails.paid == 'No'
                      ? () {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text('Update payment status'),
                              content: const Text("Click 'Paid' button if the customer has made the payment"),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text('Cancel')
                                ),
                                TextButton(
                                  onPressed:()async{
                                    await custOrderService.updatePaymentStatus(orderDetails.id!);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text('Paid')
                                )
                              ],
                            );
                          }
                        );
                      }
                      : (){},
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 110,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(width:0.5),
                          color: orderDetails.paid == 'No' 
                          ? statusRedColor
                          : statusYellowColor
                        ),
                        child: orderDetails.paid == 'No'
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
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: 'Cash On Hand', 
          barColor: deliveryColor, 
          userRole: 'deliveryMan',
          textSize: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  FutureBuilder<DeliveryModel?>(
                    future: deliveryService.getDeliveryManInfo(userId, widget.orderDelivery.menuOrderID!), 
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator()
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text(
                          'No order assigned to you',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20
                          ),
                        );
                      } else{
                        DeliveryModel deliveryData = snapshot.data!;
                        return Column(
                          children: [
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Enter the current amount of cash on hand.')
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 270,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: cashOnHandController,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.money_outlined),
                                            labelText: 'Cash on Hand',
                                            hintText: 'Cash on Hand',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator:(value) {
                                            if(value!.isEmpty){
                                              return 'Cash On Hand can not be empty';
                                            }else if(!isNumeric(value)){
                                              return 'Please enter a valid number';
                                            }else{
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: ()async{
                                          if(_formkey.currentState!.validate()){
                                            double cashOnHand = double.tryParse(cashOnHandController.text)!;
                                            await deliveryService.updateCashOnHandById(userId, widget.orderDelivery.menuOrderID!, cashOnHand);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DeliveryCashOnHandPage(orderDelivery: widget.orderDelivery),
                                              ),
                                            );
                                          }
                                        }, 
                                        child: const Text('OK')
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(5),
                                  child: const Text(
                                    'Initial amount',
                                    style: TextStyle(
                                      fontSize: 25
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 160,
                                  padding: const EdgeInsets.all(5), 
                                  child: Text(
                                    'RM${deliveryData.cashOnHand!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                      fontSize: 25
                                    ),
                                  )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(5),
                                  child: const Text(
                                    'Expected final amount:',
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 160,
                                  color: Colors.lime,
                                  padding: const EdgeInsets.all(5),
                                  child: StreamBuilder<List<OrderCustModel>>(
                                    stream: custOrderService.getOrderListWithCOD(userId, widget.orderDelivery.menuOrderID!), 
                                    builder: (context, snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return const Text('No order with COD payment');
                                      }else {
                                        List<OrderCustModel> orders = snapshot.data!;
                                        double totalPayAmount = orders.fold(0.0, (sum, order) => sum + order.payAmount!);
                                        double expectedFinalAmount = totalPayAmount + deliveryData.cashOnHand!;
                                        return Text(
                                          'RM${expectedFinalAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 25
                                          ),
                                        );
                                      }
                                    }
                                  )
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(5),
                                  child: const Text(
                                    'Actual final amount:',
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 160,
                                  color: const Color.fromARGB(255, 63, 194, 255),
                                  padding: const EdgeInsets.all(5),
                                  child: StreamBuilder<List<OrderCustModel>>(
                                    stream: custOrderService.getOrderListWithPaidCOD(userId, widget.orderDelivery.menuOrderID!), 
                                    builder: (context, snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Text(
                                          'RM${deliveryData.cashOnHand!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 25
                                          ),
                                        );
                                      }else {
                                        List<OrderCustModel> orders = snapshot.data!;
                                        double totalPayAmount = orders.fold(0.0, (sum, order) => sum + order.payAmount!);
                                        double finalAmount = totalPayAmount + deliveryData.cashOnHand!;
                                        deliveryService.updateFinalCashOnHandById(userId, widget.orderDelivery.menuOrderID!, finalAmount);
                                        return Text(
                                          'RM${finalAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 25
                                          ),
                                        );
                                      }
                                    }
                                  )
                                )
                              ],
                            ),
                          ],
                        );
                      }
                    }
                  ),
                  
                  const SizedBox(height: 20),
                  StreamBuilder<List<OrderCustModel>>(
                    stream: custOrderService.getOrderListWithCOD(userId, widget.orderDelivery.menuOrderID!), 
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No order with COD payment');
                      }else {
                        List<OrderCustModel> orders = snapshot.data!;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: height,
                              width: width,
                              child: ListView(
                                children: orders.map((order){
                                  return Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child: SizedBox(
                                      height: 150.0,
                                      child: getOrderList(order),
                                    )
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        );
                      }
                    }
                  )
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}