
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/delivery_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/delivery.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';

class ViewDeliveryManProgressPage extends StatefulWidget {
  const ViewDeliveryManProgressPage({
    required this.orderSelected,
    required this.userSelected,
    super.key
  });

  final UserModel userSelected;
  final OrderOwnerModel orderSelected;

  @override
  State<ViewDeliveryManProgressPage> createState() => _ViewDeliveryManProgressPageState();
}

class _ViewDeliveryManProgressPageState extends State<ViewDeliveryManProgressPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  final UserDatabaseService userService = UserDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  double? wige;
  List<String> selectedOrderDestinationList = [];
  bool isMultiSelectionEnabled = false;
  late List<String> sortedLocations;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    
    Widget buildLocationTile(String location, int total) {
      bool isSelected = selectedOrderDestinationList.contains(location);
      return GestureDetector(
        onTap: (){
          isMultiSelectionEnabled
          ? setState((){
              isSelected = !isSelected;
              if(isSelected){
                selectedOrderDestinationList.add(location);
              }else{
                selectedOrderDestinationList.remove(location);
              }
            })
          : null;
        },
        onLongPress: (){
          setState(() {
            isSelected = !isSelected;
            isMultiSelectionEnabled = !isMultiSelectionEnabled;
            if (isSelected) {
              selectedOrderDestinationList.add(location);
            } else {
              selectedOrderDestinationList.remove(location);
            }
          });
        },
        child: Container(
          height: 80,
          width: 60,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(),
            color: isMultiSelectionEnabled ? Colors.amber : Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              Text(
                total.toString(),
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white
                ),
              ),
              isMultiSelectionEnabled
              ? Checkbox(
                  value: isSelected, 
                  onChanged: (value){
                    setState(() {
                      isSelected = value!;
                      if (isSelected) {
                        selectedOrderDestinationList.add(location);
                      } else {
                        selectedOrderDestinationList.remove(location);
                      }
                    });
                  }
                )
              : Container()
            ],
          ),
        ),
      );
    }

    Widget buildDetailTile(String title, String details){
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  details,
                  style: const TextStyle(
                    fontSize: 16,
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
    
    Widget buildCurrentDeliveryTile(String title, String details){
      return Column(
        children: [
          Row(
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
                width: 140,
                child: Text(
                  details,
                  style: const TextStyle(
                    fontSize: 16,
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
    
    Widget buildCurrentDeliveryLocationListTile(String title, List<String> locations){
      List<String> uniqueLocations = locations.toSet().toList();
      return Column(
        children: [
          Row(
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
                width: 140,
                child: Text(
                  uniqueLocations.join(', '),
                  style: const TextStyle(
                    fontSize: 16,
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

    return SafeArea(
      child: Scaffold(
        appBar: isMultiSelectionEnabled 
        ? AppBar(
            automaticallyImplyLeading: false,
            actions: [
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    selectedOrderDestinationList.clear();
                    selectedOrderDestinationList.addAll(sortedLocations);
                  });
                }, 
                child: const Text(
                  'Select All',
                  style: TextStyle(
                    fontSize: 19
                  ),
                )
              ),
              IconButton(
                icon: const Icon(
                  Icons.cancel_sharp,
                  color: Colors.red,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    isMultiSelectionEnabled = !isMultiSelectionEnabled;
                    selectedOrderDestinationList.clear();
                  });
                },
              ),
            ],
          )
        : DirectAppBarNoArrow(
            title: 'Delivery Man', 
            userRole: 'owner',
            textSize: 0,
            barColor: ownerColor
          ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                widget.orderSelected.openForDeliveryStatus == 'Yes'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current order available',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      const Text(
                        'You can select the orders and assign to this delivery man.',
                        style: TextStyle(
                          fontSize: 13
                        ),
                      ),
                      Container(
                        height: 119,
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: StreamBuilder<List<OrderCustModel>>(
                          stream: custOrderService.getSpecificOrderWithoutDeliveryManId(widget.orderSelected.id!),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No order available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                )
                              );
                            }else{
                              List<OrderCustModel> orders = snapshot.data!;
                              Map<String, int> locationCountMap = {};
                              for (var order in orders) {
                                String location = order.destination!;
                                locationCountMap[location] = (locationCountMap[location] ?? 0) + 1;
                              }
                              sortedLocations = locationCountMap.keys.toList()..sort();
    
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: sortedLocations.map((location) {
                                  return buildLocationTile(location, locationCountMap[location]!);
                                }).toList(),
                              );
                            }
                          }
                        )
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 60,
                      width: width,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'No delivery opened yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19
                            ),
                          ),
                          Text(
                            "Back to previous page to open for delivery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                
                const SizedBox(height: 20),
                FutureBuilder<UserModel?>(
                  future: userService.getUserDataById(widget.userSelected.userId!), 
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
                            "Error in fetching data of delivery man",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )
                        ),
                      );
                    }else{
                      UserModel deliveryMan = snapshot.data!;
                      return Column(
                        children: [
                          const Text(
                            "DeliveryMan's details",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            border: Border.all()
                          ),
                            child: Column(
                              children: [
                                buildDetailTile('Name', '${deliveryMan.fullName}'),
                                buildDetailTile('Phone Number', '${deliveryMan.phone}'),
                                buildDetailTile('Email', '${deliveryMan.email}'),
                                buildDetailTile('Car Plate Number', '${deliveryMan.carPlateNum}'),
                                buildDetailTile('Total Packages delivered', '${deliveryMan.totalDeliveredPackage}'),
                                buildDetailTile('Salary', 'RM${deliveryMan.moneyEarned!.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          widget.orderSelected.openForDeliveryStatus == 'No'
                          ? Container()
                          : FutureBuilder<DeliveryModel?>(
                              future: deliveryService.getDeliveryManInfo(widget.userSelected.userId!, widget.orderSelected.id!),
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator()
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData) {
                                  return const Text(
                                    'No order assign to this delivery man yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  );
                                } else {
                                  DeliveryModel deliveryData = snapshot.data!;
                                  return Column(
                                    children: [
                                      const Text(
                                        "Current delivery",
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: const Color.fromARGB(255, 255, 250, 180),
                                        ),
                                        child: Column(
                                          children: [
                                            //read data from customer order
                                            StreamBuilder<List<OrderCustModel>>(
                                              stream: custOrderService.getOrderForDeliveryMan(deliveryData.location, deliveryData.orderId!),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                  return const Center(
                                                    child: Text(
                                                      "No order",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 30
                                                      ),
                                                    )
                                                  );
                                                }else{
                                                  List<OrderCustModel> orders = snapshot.data!;
                                                  List<OrderCustModel> pendingOrders = orders.where((order) => order.delivered == 'No').toList();
                                                  List<OrderCustModel> completedOrders = orders.where((order) => order.delivered == 'Yes').toList();
                                                  return Column(
                                                    children: [
                                                      buildCurrentDeliveryTile('Delivery for: ', '${widget.orderSelected.orderName}, ${widget.orderSelected.openDate}'),
                                                      buildCurrentDeliveryTile('Total orders', '${orders.length}'),
                                                      buildCurrentDeliveryTile('Total pending orders', '${pendingOrders.length}'),
                                                      buildCurrentDeliveryTile('Total delivered orders', '${completedOrders.length}'),
                                                      buildCurrentDeliveryLocationListTile('Delivery locations', orders.map((order) => order.destination!).toList()),
                                                      buildCurrentDeliveryTile('Cash On Hand', 'RM${deliveryData.finalCashOnHand!.toStringAsFixed(2)}')
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                            ),
                          ],
                        );
                      }
                    }
                  )
                ],
              ),
            ),
          ),
        floatingActionButton: isMultiSelectionEnabled
        ? SizedBox(
            height: 60,
            width: 150,
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: ()async{
                DocumentReference docRef = await deliveryService.addOrderDeliveryInfo(
                  DeliveryModel(
                    docId: '',
                    deliveryUserId: widget.userSelected.userId,
                    orderId: widget.orderSelected.id,
                    location: selectedOrderDestinationList,
                  )
                );
                String docId = docRef.id;
                await deliveryService.updateDelivery(
                  DeliveryModel(
                    docId: docId,
                    deliveryUserId: widget.userSelected.userId,
                    orderId: widget.orderSelected.id,
                    location: selectedOrderDestinationList,
                  )
                );

                // Update the deliveryManId in selected customer orders
                await custOrderService.updateOrderDeliveryManId(selectedOrderDestinationList, widget.userSelected.userId!);
                
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Orders assigned successfully', 
                      style: TextStyle(color: Colors.black)
                    ),
                    backgroundColor: Colors.amber,
                  )
                );

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewDeliveryManProgressPage(
                      userSelected: widget.userSelected,
                      orderSelected: widget.orderSelected,
                    ),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), 
                side: const BorderSide(width: 1)    
              ),
              child: const Text(
                'Assign order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
            ),
          )
        : Container()
      ),
    );
  }
}