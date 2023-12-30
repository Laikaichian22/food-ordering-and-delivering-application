import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:image_picker/image_picker.dart';

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
  File? image;
  final picker = ImagePicker();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();

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

                            return Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding:const EdgeInsets.all(10),
                                
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${orderData.custName}'),
                                    Text('Destination: ${orderData.destination}'),
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
                      onPressed: (){
                        //udpate the data of 'delivered' for the customer list
                        //send picture to the customer, but how to store it is a problem 
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