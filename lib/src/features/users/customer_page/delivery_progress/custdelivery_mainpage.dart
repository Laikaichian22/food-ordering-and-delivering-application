import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';

class CustDeliveryProgressPage extends StatefulWidget {
  const CustDeliveryProgressPage({super.key});

  @override
  State<CustDeliveryProgressPage> createState() => _CustDeliveryProgressPageState();
}

class _CustDeliveryProgressPageState extends State<CustDeliveryProgressPage> {
  bool isBarVisible = false;
  bool isCollected = false; 

  void toggle(){
    setState(() {
      isBarVisible = !isBarVisible;
    });
  }

  @override 
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Lunch order delivery', 
          barColor: custColor
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(40)
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(160),
                          1: FixedColumnWidth(100),
                        },
                        children: const [
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery process: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'In progress',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Car plate number: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ABC1223',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current location: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MA1',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Next location: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MA2',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated time: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '5 minutes',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your order:',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 5),
                          StreamBuilder<List<OrderCustModel>>(
                            stream: custOrderService.getOrderById(userID), 
                            builder: (context, snapshot){
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text(
                                  "You haven't placed any order yet",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }else {
                                List<OrderCustModel> orders = snapshot.data!;
                                return SizedBox(
                                  width: 280,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 290,
                                              child: Card(
                                                clipBehavior: Clip.hardEdge,
                                                color: orders[index].delivered == 'No' ? const Color.fromARGB(255, 255, 131, 7) : const Color.fromARGB(255, 0, 206, 252),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: [
                                                      Table(
                                                        columnWidths: const {
                                                          0: FixedColumnWidth(90),
                                                          1: FixedColumnWidth(100),
                                                        },
                                                        children: [
                                                          TableRow(
                                                            children: [
                                                              const Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Name: ',
                                                                    style: TextStyle(
                                                                      fontSize: 17,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    orders[index].custName!,
                                                                    style: const TextStyle(
                                                                      fontSize: 17,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          TableRow(
                                                            children: [
                                                              const Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Order: ',
                                                                    style: TextStyle(
                                                                      fontSize: 17,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    orders[index].orderDetails!,
                                                                    style: const TextStyle(
                                                                      fontSize: 17,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          TableRow(
                                                            children: [
                                                              const Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Location: ',
                                                                    style: TextStyle(
                                                                      fontSize: 17,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    orders[index].destination!,
                                                                    style: const TextStyle(
                                                                      fontSize: 17,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ], 
                                                  ),
                                                ),
                                              ),
                                            ),
                                            orders[index].delivered == 'Yes'
                                            ? orders[index].orderDeliveredImage == null 
                                              ? Container(
                                                  padding: const EdgeInsets.all(5),
                                                  child: const Text(
                                                    'Do contact the delivery man if you do not find the delivered order',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Container(
                                                  width: 260,
                                                  padding: const EdgeInsets.all(5), 
                                                  child: Column(
                                                    children: [
                                                      const Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          'Pick up your meal at: ', 
                                                          style: TextStyle(fontSize: 16)
                                                        )
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Image.network(
                                                        orders[index].orderDeliveredImage!,
                                                        width: 120,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                    ],
                                                  ),
                                                )
                                            : Container(), 
                                          ],
                                        )
                                      );
                                    },
                                  ),
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
            
          ],
        ),
        // floatingActionButton: SizedBox(
        //   height: 60,
        //   width: width*0.9,
        //   child: FloatingActionButton(
        //     backgroundColor: isCollected ? const Color.fromARGB(255, 185, 185, 185) :const Color.fromARGB(255, 12, 244, 19),
        //     onPressed: isCollected 
        //     ? null
        //     : (){
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             content: const Text(
        //               'Please double confirm that you have collected your order',
        //             ),
        //             actions: [
        //               TextButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: const Text('Cancel'),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   setState(() {
        //                     isCollected = true;
        //                   });
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: const Text('Confirm'),
        //               )
        //             ],
        //           );
        //         },
        //       );
        //     },
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20.0),     
        //     ),
        //     child: isCollected 
        //     ? const Text(
        //         'Enjoy your meal',
        //         style: TextStyle(
        //           fontSize: 20,
        //           color: Colors.black
        //         ),
        //       )
        //     : const Text(
        //         'Click here if you have collected order',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 17,
        //           color: Colors.black
        //         ),
        //       ),
        //   ),
        // ),
      )
    );
  }
}