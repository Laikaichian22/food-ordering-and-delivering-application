
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
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class ViewDeliveryManProgressPage extends StatefulWidget {
  const ViewDeliveryManProgressPage({
    required this.userSelected,
    super.key
  });

  final UserModel userSelected;

  @override
  State<ViewDeliveryManProgressPage> createState() => _ViewDeliveryManProgressPageState();
}

class _ViewDeliveryManProgressPageState extends State<ViewDeliveryManProgressPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  final UserDatabaseService userService = UserDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  List<String> selectedOrderDestinationList = [];
  bool isMultiSelectionEnabled = false;
  late List<String> sortedLocations;
  bool isOrderOpenForDelivery = false;
  late Future<void> orderDeliveryStatusFuture;
  OrderOwnerModel? currentOrderForDelivery;
  
  Future<void> loadOrderDeliveryState()async{
    currentOrderForDelivery = await ownerOrderService.getOrderOpenedForDelivery();
    if(currentOrderForDelivery != null){
      isOrderOpenForDelivery = true;
    }else{
      isOrderOpenForDelivery = false;
    }
  }

  @override
  void initState() {
    super.initState();
    orderDeliveryStatusFuture = loadOrderDeliveryState();
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
                  color: Colors.black
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
                width: 230,
                child: Text(
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
    
    Widget buildCurrentDeliveryTile(String title, String details){
      return Column(
        children: [
          Row(
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
                child: Text(
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
    
    Widget buildCurrentDeliveryLocationListTile(String title, List<String> locations){
      List<String> uniqueLocations = locations.toSet().toList();
      return Column(
        children: [
          Row(
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
                child: Text(
                  uniqueLocations.join(', '),
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
        : GeneralDirectAppBar(
            title: 'Delivery Man', 
            userRole: 'owner',
            onPress:(){
              Navigator.of(context).pushNamedAndRemoveUntil(
                ownerDeliveryManListRoute,
                (route) => false,
              );
            },
            barColor: ownerColor
          ),
        body: FutureBuilder<void>(
          future: orderDeliveryStatusFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    isOrderOpenForDelivery
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
                              stream: custOrderService.getOrderWithoutDeliveryManId(),
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
                          height: 100,
                          width: width,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'No delivery opened yet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Click 'start' button to start delivery",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15
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
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                          orderAddPageRoute, 
                                          (route) => false,
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
                                    buildDetailTile('Total Packages delivered', ''),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              currentOrderForDelivery == null
                              ? const Text(
                                  'There exists data of delivery for this delivery man. \nBut the delivery has not been opened yet.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19
                                  ),
                                )
                              : FutureBuilder<DeliveryModel?>(
                                  future: deliveryService.getDeliveryManInfo(widget.userSelected.userId!, currentOrderForDelivery!.id!),
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
                                                          buildCurrentDeliveryTile('Delivery for: ', '${orders.isNotEmpty ? orders[0].menuOrderName : ''}'),
                                                          buildCurrentDeliveryTile('Total orders', '${orders.length}'),
                                                          buildCurrentDeliveryTile('Total pending orders', '${pendingOrders.length}'),
                                                          buildCurrentDeliveryTile('Total delivered orders', '${completedOrders.length}'),
                                                          buildCurrentDeliveryLocationListTile('Delivery locations', orders.map((order) => order.destination!).toList()),
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
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
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
                    orderId: currentOrderForDelivery!.id,
                    location: selectedOrderDestinationList,
                  )
                );
                String docId = docRef.id;
                await deliveryService.updateDelivery(
                  DeliveryModel(
                    docId: docId,
                    deliveryUserId: widget.userSelected.userId,
                    orderId: currentOrderForDelivery!.id,
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ViewDeliveryManProgressPage(
                      userSelected: widget.userSelected,
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