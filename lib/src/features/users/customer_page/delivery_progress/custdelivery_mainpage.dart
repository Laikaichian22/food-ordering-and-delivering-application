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
                      height: height*0.3,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: const Center(child: Text('Here show the map')),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: const Column(
                            children: [
                              Row(
                                children: [
                                  Text('Delivery process:'),
                                  SizedBox(width: 5),
                                  Text('In progress')
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Car plate number:'),
                                  SizedBox(width: 5),
                                  Text('ABC 1234')
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Current location:'),
                                  SizedBox(width: 5),
                                  Text('MA1')
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Next location:'),
                                  SizedBox(width: 5),
                                  Text('MA3')
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Estimated time:'),
                                  SizedBox(width: 5),
                                  Text('5 minutes')
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              right: isBarVisible ? 0 : -160,
              top: 265,
              bottom: 20,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: custColor,
                  shape: BoxShape.rectangle,
                  border: Border.all()
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_right_outlined,
                                size: 40,
                                color: Colors.black,
                              ),
                              onPressed: toggle,
                            ),
                          ],
                        ),
                        Column(
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
                                    height: 60,
                                    width: 120,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: 60,
                                          child: ListView(
                                            children: orders.map((OrderCustModel order) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    color: const Color.fromARGB(255, 83, 232, 255),
                                                    padding: const EdgeInsets.all(8),
                                                    child: Text(
                                                      '${order.orderDetails}',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            )
                          ],
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 60,
          width: 120,
          child: FloatingActionButton(
            backgroundColor: isCollected ? const Color.fromARGB(255, 185, 185, 185) :const Color.fromARGB(255, 12, 244, 19),
            onPressed: isCollected 
            ? null
            : (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      'Please double confirm that you have collected your order',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isCollected = true;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirm'),
                      )
                    ],
                  );
                },
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),     
            ),
            child: isCollected 
            ? const Text(
                'Collected',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              )
            : const Text(
                'Click here if you have collected order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black
                ),
              ),
          ),
        ),
      )
    );
  }
}