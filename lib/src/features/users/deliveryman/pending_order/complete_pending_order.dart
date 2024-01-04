import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DeliveryManCompletePendingOrderPage extends StatefulWidget {
  const DeliveryManCompletePendingOrderPage({
    required this.completeOrderList,
    super.key
  });

  final List<String> completeOrderList;

  @override
  State<DeliveryManCompletePendingOrderPage> createState() => _DeliveryManCompletePendingOrderPageState();
}

class _DeliveryManCompletePendingOrderPageState extends State<DeliveryManCompletePendingOrderPage> {
  final UserDatabaseService userService = UserDatabaseService();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  File? image;
  final picker = ImagePicker();
  List<String> userIdListFromOrder = [];

  Future<String> uploadImage(File? imageFile)async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String randomChars = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    var storageRef = FirebaseStorage.instance.ref().child('photoDelivered/$fileName$randomChars'); 
    var uploadTask = storageRef.putFile(imageFile!);
    var snapshot = await uploadTask;
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //send notification to selected customer
  Future<void> sendNotificationToCustomers(List<String> customerTokens) async {
    const String serverKey = 'AAAARZkf7Aw:APA91bGSJTuexnDQR8qO4bdNFNCTsVqtLZUguj39lY_hUlMOiMQ7x6uf6mbP_dpEB5mRPFzGNdQd3KVfufllA3ccLcuZ_2mjaBQhoyK15Yz-QrMYTt0gmUyaHZewAxi0d-fsw_sV23vP';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> data = {
      'registration_ids': customerTokens,
      'priority': 'high',
      'notification': {
        'title': 'Order delivered!',
        'body': 'Please come down to collect your order.',
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
            'A notification has been sent to customer'
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

    // Check if customerTokens[0] is null
    // if (customerTokens.isNotEmpty) {
    //   print('Customer Token[0]: ${customerTokens[0]}');
    // } else {
    //   print('Customer Tokens is empty');
    // }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
       image = File(pickedFile.path);
      }
    });
  }
  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null){
        image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please select your option:'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  onTap: (){
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_outlined,size: 30),
                  title: const Text('Camera', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: (){
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image_outlined, size: 30),
                  title: const Text('Gallery', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Completing pending order', 
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'One more step',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You can choose to either send or not send image of delivered order to these customers.',
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Customer List',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      for(String id in widget.completeOrderList)
                      FutureBuilder<OrderCustModel?>(
                        future: custOrderService.getOrderDataById(id), 
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator()
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return Text('No data found for ID: $id');
                          } else {
                            OrderCustModel orderData = snapshot.data!;
                            userIdListFromOrder.add(orderData.userid!);
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding:const EdgeInsets.all(10),
                                
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: "Name: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          TextSpan(
                                            text: orderData.custName,
                                          )
                                        ]
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 18.0,
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
                                            text: orderData.destination,
                                          )
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                InkWell(
                  onTap: () {
                    showOptions();
                  },
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    child: image == null 
                    ? const Icon(Icons.camera_alt_outlined, size: 30)
                    : Image.file(
                        image!,
                        fit: BoxFit.fill,
                      ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_outlined),
                      onPressed: ()async{
                        String downloadUrl = 
                        image == null 
                        ? ''
                        : await uploadImage(image);
                        
                        for(String id in widget.completeOrderList) {
                          await custOrderService.updateDeliveredInOrder(id);
                          await custOrderService.updateORderDeliveredImage(id, downloadUrl);
                        }
                        
                        List<String> customerTokens = await userService.getCustomersTokenById(userIdListFromOrder);
                        await sendNotificationToCustomers(customerTokens);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }, 
                      label: const Text(
                        'Complete & Send',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ), 
                    )
                  ]
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}