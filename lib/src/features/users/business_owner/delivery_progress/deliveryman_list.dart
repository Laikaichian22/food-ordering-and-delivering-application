import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/delivery_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/delivery.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delivery_progress/delivery_man_page.dart';
import 'package:http/http.dart' as http;

class DeliveryManListPage extends StatefulWidget {
  const DeliveryManListPage({
    required this.orderSelected,
    super.key
  });

  final OrderOwnerModel orderSelected;

  @override
  State<DeliveryManListPage> createState() => _DeliveryManListPageState();
}

class _DeliveryManListPageState extends State<DeliveryManListPage> {
  final UserDatabaseService userService = UserDatabaseService();
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget deliveryStatusBar(String detailsTxt){
    return Positioned(
      top: 0,
      right: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: detailsTxt == 'Delivery start' ? statusYellowColor : statusRedColor, 
          height: 23,
          width: 180,
          alignment: Alignment.center,
          child: Text(
            detailsTxt,
            style: TextStyle(
              color: detailsTxt == 'Delivery start' ? Colors.black : yellowColorText,
              fontSize: detailsTxt == 'Delivery start' ? 16 : 14
            ),
          ),
        ),
      ),
    );
  }
 
  Future<void> _showDialog(String content){
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            )
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontSize: 20,
                  color: okTextColor
                ),
              )
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: DirectAppBarNoArrow(
          title: 'Delivery Man List',
          userRole: 'owner', 
          textSize: 0,
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                widget.orderSelected.openForDeliveryStatus == 'No'
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 100,
                      width: width,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: orderClosedColor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'This order is not ready for delivery',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              color: yellowColorText
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Click 'start' button to start delivery",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: yellowColorText
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 30,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                                    elevation: 10,
                                    shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                  ),
                                  onPressed: (){
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: const Text('Confirm to start delivery?',style:TextStyle(fontSize: 20)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
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
                                              onPressed: ()async{
                                                List<OrderOwnerModel> orderOpenedForDelivery = await ownerOrderService.getOpenDeliveryOrderList();
                                                if(orderOpenedForDelivery.isNotEmpty){
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  _showDialog('Only one order can be opened for delivery at one time');
                                                }else{
                                                  await ownerOrderService.updatetoOpenDeliveryStatus(widget.orderSelected.id!);
                                                  List<String> deliveryManToken = await userService.getDeliveryManToken();
                                                  await sendNotificationToDeliveryMan(deliveryManToken);
                                                  
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    widget.orderSelected.openForDeliveryStatus = 'Yes';
                                                  });
                                                }
                                              }, 
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: confirmTextColor
                                                ),
                                              )
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  }, 
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.black
                                    ),
                                  ),
                                ), 
                              ),
                              const SizedBox(height: 5),
                            ],
                          )
                        ],
                      )
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 100,
                      width: width,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: orderOpenedColor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'This order is ready for delivery',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Click 'end' button to end delivery",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 30,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: statusRedColor,
                                    elevation: 10,
                                    shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                  ),
                                  onPressed: (){
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: const Text('Confirm to end delivery?',style:TextStyle(fontSize: 20)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
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
                                              onPressed: ()async{
                                                await ownerOrderService.updatetoCloseDeliveryStatus(widget.orderSelected.id!);
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  widget.orderSelected.openForDeliveryStatus = 'No';
                                                });
                                              }, 
                                              child: const Text(
                                                'Confirm',style: TextStyle(
                                                  fontSize: 20,
                                                  color: confirmTextColor
                                                ),
                                              )
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  }, 
                                  child: const Text(
                                    'End',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: yellowColorText
                                    ),
                                  ),
                                ), 
                              ),
                              const SizedBox(height: 5),
                            ],
                          )
                        ],
                      )
                    ),
                  ),
                const SizedBox(height: 10),
    
                StreamBuilder<List<UserModel>>(
                  stream: userService.getDeliveryManList(), 
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
                        child: const Text('No delivery man registered yet.'),
                      );
                    }else{
                      List<UserModel> deliveryMan = snapshot.data!;
                      return Column(
                        children: deliveryMan.map((delivery){
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: const Color.fromARGB(255, 92, 190, 255),
                                    contentPadding: const EdgeInsetsDirectional.all(10),
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: delivery.fullName,
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
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Phone Number: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: delivery.phone,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: purpleColorText
                                                )
                                              ),
                                              const TextSpan(
                                                text: '\nCar plate Number: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: delivery.carPlateNum,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: purpleColorText
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 50,
                                      color: Color.fromARGB(255, 105, 1, 107),
                                    ),
                                    onTap: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                        builder: (context) => ViewDeliveryManProgressPage(userSelected: delivery, orderSelected: widget.orderSelected),
                                      );
                                      Navigator.push(context, route);
                                    },
                                  ),
                                  widget.orderSelected.openForDeliveryStatus == 'No'
                                  ? deliveryStatusBar('Delivery has not opened yet')
                                  : FutureBuilder<DeliveryModel?>(
                                      future: deliveryService.getDeliveryManInfo(delivery.userId!, widget.orderSelected.id!),
                                      builder: (context, snapshot){
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return deliveryStatusBar('Error: ${snapshot.error}');
                                        } else if (!snapshot.hasData) {
                                          return deliveryStatusBar('No order assigned');
                                        } else {
                                          DeliveryModel deliveryData = snapshot.data!;
                                          return deliveryData.deliveryStatus == 'Start'
                                          ? deliveryStatusBar('Delivery start')
                                          : deliveryStatusBar('No delivery started');
                                        }
                                      }
                                    ),
                                ],
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
        )
      )
    );
  }
}