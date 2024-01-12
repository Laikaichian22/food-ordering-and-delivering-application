import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/delivery_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/delivery.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/pending_order/complete_pending_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_order_details.dart';

class DeliveryStartMainPage extends StatefulWidget {
  const DeliveryStartMainPage({
    required this.orderDeliveryOpened,
    super.key
  });
  final OrderCustModel orderDeliveryOpened;
  @override
  State<DeliveryStartMainPage> createState() => _DeliveryStartMainPageState();
}

class _DeliveryStartMainPageState extends State<DeliveryStartMainPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final platNumController = TextEditingController();
  final messageController = TextEditingController();
  final yourNameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isEditPressed = false;
  bool anyChanges = false;
  bool isDeliveryStarted = false;
  final userId = AuthService.firebase().currentUser?.id;
  final UserDatabaseService userService = UserDatabaseService();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  List<String> selectedOrderIdList = [];
  List<String> locationList = [];
  bool isMultiSelectionEnabled = false;
  String detectDeliveryStatus = '';
  
  Widget buildLocationTile(String location, String deliveredStatus){
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        color: deliveredStatus == 'No'? Colors.blue : Colors.grey,
      ),
      child: Center(
        child: Text(
          location,
          style: TextStyle(
            fontSize: 16,
            color: deliveredStatus == 'No'? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildArrow() {
    return const Icon(
      Icons.arrow_forward,
      size: 30,
      color: Colors.black,
    );
  }
  
  Future<void> _fetchUserData() async {
    try {
      UserModel? userData = await UserDatabaseService().getUserDataById(userId!);
      yourNameController.text = userData?.fullName ?? '';
      phoneController.text = userData?.phone ?? '';
      platNumController.text = userData?.carPlateNum ?? '';
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error fetching user data: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  InkWell getOrderList(OrderCustModel orderDetails){
    bool isSelected = selectedOrderIdList.contains(orderDetails.id);
    return InkWell(
      onTap:(){
        isMultiSelectionEnabled 
        ? setState(() {
            isSelected = !isSelected;
            
            if (isSelected) {
              selectedOrderIdList.add(orderDetails.id!);
            } else {
              selectedOrderIdList.remove(orderDetails.id);
            }
          })
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryManOrderDetails(orderSelected: orderDetails),
            )
          );
      },
      onLongPress: (){
        setState(() {
          isSelected = !isSelected;
          isMultiSelectionEnabled = !isMultiSelectionEnabled;
          if (isSelected) {
            selectedOrderIdList.add(orderDetails.id!);
          } else {
            selectedOrderIdList.remove(orderDetails.id);
          }
        });
      },
      child: GestureDetector(
        child: Container(
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
            clipBehavior: Clip.hardEdge,
            child: Material(
              color: isMultiSelectionEnabled
              ? longPressCardColor
              : orderHasNotDeliveredColor,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
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
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: (){
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text('Update delivered status'),
                                      content: const Text("Click 'Delivered' button if this order is delivered"),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text('Cancel')
                                        ),
                                        TextButton(
                                          onPressed:()async{
                                            await custOrderService.updateDeliveredInOrder(orderDetails.id!);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text('Delivered')
                                        )
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 110,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: onTheWayBarColor,
                                ),
                                child: const Text(
                                  'On the way',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    color: yellowColorText
                                  )
                                )
                              ),
                            ),
                            isMultiSelectionEnabled
                            ? Checkbox(
                                value: isSelected, 
                                onChanged: (value){
                                  setState(() {
                                    isSelected = value!;
                                    if (isSelected) {
                                      selectedOrderIdList.add(orderDetails.id!);
                                    } else {
                                      selectedOrderIdList.remove(orderDetails.id);
                                    }
                                  });
                                }
                              )
                            : Container()
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 20,
                        child: Row(
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
                            isMultiSelectionEnabled
                            ? InkWell(
                              onTap: (){
                                setState(() {
                                  isMultiSelectionEnabled = !isMultiSelectionEnabled;
                                  selectedOrderIdList.clear();
                                });
                              },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                )
                              )
                            : Container()
                          ],
                        ),
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
                )  
              ),
            ),
          ),
        ),
      )
    );
  }

  void _updateAnyChanges() {
    setState(() {
      anyChanges = true;
    });
  }

  Widget displayTextField(TextEditingController inputController, String title, String hint, String errorMessage){
    return Row(
      children: [
        SizedBox(
          width: 130,
          height: 60,
          child: TextFormField(
            readOnly: isEditPressed ? false : true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: inputController,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12
              ),
              labelText: title,
              labelStyle: const TextStyle(
                fontSize: 15
              ),
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            validator: (value) {
              if(value==null||value.isEmpty){
                return errorMessage;
              }
              return null;
            },
            onChanged: (value) {
              _updateAnyChanges();
            },
          ),
        ),
        InkWell(
          onTap: ()async{
            setState(() {
              isEditPressed = true;
            });
            if(anyChanges){
              if(_formKey.currentState!.validate()){
                await userService.updateDeliveryManInfo(
                  userId!, 
                  yourNameController.text.trim(), 
                  phoneController.text.trim(), 
                  platNumController.text.trim()
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Information updated successfully', 
                      style: TextStyle(color: Colors.black)
                    ),
                    backgroundColor: Colors.amber,
                  )
                );
                setState(() {
                  anyChanges = false;
                  isEditPressed = false;
                });
              }
            }
          },
          child: anyChanges == true 
          ? const Icon(Icons.check)
          : const Icon(Icons.edit_outlined)
        )
      ],
    );
  }

  @override
  void initState(){
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose(){
    super.dispose();
    platNumController.dispose();
    messageController.dispose();
    yourNameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //DateTime currentTime = DateTime.now();
    //String formattedTime = DateFormat('HH:mm a').format(currentTime);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: DirectAppBarNoArrow(
          textSize: 0,
          title: 'Start Your Delivery', 
          userRole: 'deliveryMan',
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: FutureBuilder<DeliveryModel?>(
                    future: deliveryService.getDeliveryManInfo(userId!, widget.orderDeliveryOpened.menuOrderID!),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return  const Center(
                          child:Text(
                            'No order assign to you yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        );
                      } else {
                        DeliveryModel deliveryData = snapshot.data!;  
                        return StreamBuilder<List<OrderCustModel>>(
                          stream: custOrderService.getOrderForDeliveryMan(deliveryData.location, deliveryData.orderId!),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Empty orders",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                )
                              );
                            }else{
                              List<OrderCustModel> orders = snapshot.data!;
                              locationList = orders.map((order) => order.destination!).toList();
                              Set<String> uniqueDestinations = <String>{};
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (int i = 0; i < orders.length; i++)
                                    if (uniqueDestinations.add(orders[i].destination!)) ...[
                                      buildLocationTile(orders[i].destination!, orders[i].delivered!),
                                      if (i < orders.length - 1 && !uniqueDestinations.contains(orders[i + 1].destination!)) 
                                        buildArrow(),
                                    ],
                                ],
                              );
                            }
                          }
                        );
                      }
                    }
                  )
                ),

                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              displayTextField(yourNameController, 'Name', 'Name', 'Cannot be empty'),
                              const SizedBox(height: 20),
                              displayTextField(phoneController, 'Phone Number', 'Phone number', 'Cannot be empty'),
                              const SizedBox(height: 20),
                              displayTextField(platNumController, 'Car Plate Number', 'Car plate number', 'Cannot be empty')
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              SizedBox(
                                height: 130,
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isDeliveryStarted
                                    ? const Text(
                                      'Delivery started.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      )
                                    : const Text(
                                      'You can start your delivery on any time.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              FutureBuilder<DeliveryModel?>(
                                future: deliveryService.getDeliveryManInfo(userId!, widget.orderDeliveryOpened.menuOrderID!),
                                builder: (context, snapshot){
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator()
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData) {
                                    return Container(
                                      width: 140,
                                      color: Colors.lime,
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'No order assign to you yet.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15
                                        ),
                                      ),
                                    );
                                  } else {
                                    DeliveryModel deliveryData = snapshot.data!;
                                    return deliveryData.deliveryStatus == 'End' || deliveryData.deliveryStatus == ''
                                    ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 174, 0, 255),
                                        elevation: 6,
                                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                      ),
                                      onPressed: ()async{
                                        await deliveryService.updateDeliveryStatusToStart(userId!, widget.orderDeliveryOpened.menuOrderID!);
                                        await custOrderService.updateDeliveryToStart(locationList);
                                        setState(() {
                                          isDeliveryStarted = true;
                                        });
                                      }, 
                                      child: const Text(
                                        'Start delivery',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: yellowColorText
                                        ),
                                      )
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 0, 8, 255),
                                        elevation: 6,
                                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                      ),
                                      onPressed: ()async{
                                        await deliveryService.updateDeliveryStatusToEnd(userId!, widget.orderDeliveryOpened.menuOrderID!);
                                        await custOrderService.updateDeliveryToEnd(locationList);
                                        setState(() {
                                          isDeliveryStarted = false;
                                        });
                                      }, 
                                      child: const Text(
                                        'End delivery',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: yellowColorText
                                        ),
                                      )
                                    );
                                  }
                                }
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'Order Pending',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      StreamBuilder<List<OrderCustModel>>(
                        //get the orders assigned to delivery man
                        stream: custOrderService.getDeliveryManSpecificPendingOrder(widget.orderDeliveryOpened.menuOrderID!, userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Container(
                              height: 200,
                              width: 400,
                              decoration: BoxDecoration(
                                border: Border.all()
                              ),
                              child: const Center(
                                child: Text(
                                  "No order found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                )
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Container(
                              height: 200,
                              width: 400,
                              decoration: BoxDecoration(
                                border: Border.all()
                              ),
                              child: const Center(
                                child: Text(
                                  "No order found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                )
                              ),
                            );
                          }else{
                            List<OrderCustModel> orders = snapshot.data!;
                            //will sort based on the destination
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height*0.6,
                                  width: width,
                                  color: const Color.fromARGB(255, 244, 255, 141),
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
                        },
                      )
                    ],
                  ),
                )   
              ],
            )
          ),
        ),
        floatingActionButton: isMultiSelectionEnabled
        ? SizedBox(
            height: 60,
            width: 150,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 238, 255, 0),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryManCompletePendingOrderPage(completeOrderList: selectedOrderIdList)
                  )
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),     
              ),
              child: const Text(
                'Completed order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
            ),
          )
        : Container()
      )
    );
  }
}