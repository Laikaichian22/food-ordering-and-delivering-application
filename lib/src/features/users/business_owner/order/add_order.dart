import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/close_open_order.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/order_list/order_listpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/view_order.dart';
import 'package:intl/intl.dart';
import '../../../../routing/routes_const.dart';
import 'package:http/http.dart' as http;

class AddOrDisplayOrderPage extends StatefulWidget {
  const AddOrDisplayOrderPage({super.key});

  @override
  State<AddOrDisplayOrderPage> createState() => _AddOrDisplayOrderPageState();
}

class _AddOrDisplayOrderPageState extends State<AddOrDisplayOrderPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService(); 
  final OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();
  final UserDatabaseService userService = UserDatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showDialog(String content){
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          content: Text(content),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text('Ok')
            )
          ],
        );
      }
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
    } else {
      return 'N/A';
    }
  }
  
  Future<void> sendNotificationToDeliveryMan(List<String> deliveryManToken) async {
    const String serverKey = 'AAAARZkf7Aw:APA91bGSJTuexnDQR8qO4bdNFNCTsVqtLZUguj39lY_hUlMOiMQ7x6uf6mbP_dpEB5mRPFzGNdQd3KVfufllA3ccLcuZ_2mjaBQhoyK15Yz-QrMYTt0gmUyaHZewAxi0d-fsw_sV23vP';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> data = {
      'registration_ids': deliveryManToken,
      'priority': 'high',
      'notification': {
        'title': 'Delivery is ready!',
        'body': 'Please come over to pick the orders.',
      },
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A notification has been sent to delivery man'
          )
        )
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fail to send notification'
          )
        )
      );
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
  
    Widget buildOrderTile(OrderOwnerModel order, double width, double height){
      return InkWell(
        onTap: (){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewOrderPage(
              orderSelected: order
            )
          );
          Navigator.push(context, route);
        },
        child: Container(
          width: width*0.8,
          height: 150,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
            color: order.openedStatus == 'Yes' ? orderOpenedColor : Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Color.fromARGB(255, 117, 117, 117),
                offset: Offset(0, 6)
              )
            ]
          ),
          child: Column(
            children: [
              Text(
                'Order Name: ${order.orderName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),const SizedBox(height:10),
              Text(
                'Start time: ${_formatDateTime(order.startTime)}',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                'End time: ${_formatDateTime(order.endTime)}',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  order.openForDeliveryStatus == 'No' 
                  ? ElevatedButton(
                    //const Color.fromARGB(255, 196, 114, 255),
                      onPressed: (){
                        showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: const Text('Confirm to start delivery?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')
                                ),
                                TextButton(
                                  onPressed: ()async{
                                    List<OrderOwnerModel> orderOpenedForDelivery = await orderService.getOpenDeliveryOrderList();
                                    if(orderOpenedForDelivery.isNotEmpty){
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      _showDialog('Only one order can be opened for delivery at one time');
                                    }else{
                                      await orderService.updatetoOpenDeliveryStatus(order.id!);
                                      List<String> deliveryManToken = await userService.getDeliveryManToken();
                                      await sendNotificationToDeliveryMan(deliveryManToken);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    }
                                  }, 
                                  child: const Text('Confirm')
                                )
                              ],
                            );
                          }
                        );
                      }, 
                      child: const Text(
                        'Start delivery',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black
                        ),
                      )
                    ) 
                  :  ElevatedButton(
                    //const Color.fromARGB(255, 3, 255, 251),
                      onPressed: (){
                        showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: const Text('Confirm to end the delivery?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')
                                ),
                                TextButton(
                                  onPressed: ()async{
                                    await orderService.updatetoCloseDeliveryStatus(order.id!);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  }, 
                                  child: const Text('Confirm')
                                )
                              ],
                            );
                          }
                        );
                      }, 
                      child: const Text(
                        'Delivery opened',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      )
                    ),
                  order.openedStatus == 'Yes' 
                  ? StreamBuilder<List<OrderCustModel>>(
                      stream: custOrderService.getAllOrder(), 
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container(
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 197, 197, 197),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'No order placed yet',
                              style: TextStyle(
                                color: Colors.black
                              ),
                            ),
                          );
                        }else {
                          return InkWell(
                            onTap: (){
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => const OwnerViewOrderListPage(),
                              );
                              Navigator.push(context, route);
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: haveOrderColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 34, 146, 0).withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'View order here',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    ) 
                  : ElevatedButton(
                      onPressed: (){
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => CloseOpenOrderPage(
                            orderSelected: order
                          )
                        );
                        Navigator.push(context, route);
                      }, 
                      child: const Text(
                        'Open order',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black
                        ),
                      )
                    )
                ],
              )
            ],
          ),
        )
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralDirectAppBar(
          title: '', 
          userRole: 'owner',
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Start your order now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 30),

                  StreamBuilder<List<OrderOwnerModel>>(
                    stream: orderService.getOrderLists(),
                    builder: (context, AsyncSnapshot<List<OrderOwnerModel>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      List<OrderOwnerModel>? orderMethods = snapshot.data;
                      if (orderMethods == null || orderMethods.isEmpty) {
                        return Container(
                          width: width * 0.75,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 255, 196, 108)),
                            color: const Color.fromARGB(255, 255, 196, 108),
                          ),
                          child: const Center(
                            child: Text(
                              'No order available',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }
                      orderMethods.sort((a, b) => a.startTime!.compareTo(b.startTime!));
                      return Column(
                        children: orderMethods.map(
                          (order) {
                            return Column(
                              children: [
                                buildOrderTile(order, width, height),
                                const SizedBox(height: 20,)
                              ],
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              orderOpenPageRoute, 
              (route) => false,
            );
          },
          shape: const CircleBorder(
            side: BorderSide()
          ),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}