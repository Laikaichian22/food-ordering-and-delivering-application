import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/delivery_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/pending_order/complete_pending_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/delivery_order_details.dart';
import 'package:intl/intl.dart';

class DeliveryStartMainPage extends StatefulWidget {
  const DeliveryStartMainPage({
    required this.orderDeliveryOpened,
    super.key
  });
  final OrderOwnerModel? orderDeliveryOpened;
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
  bool isLoading = false;
  bool isEditPressed = false;
  bool anyChanges = false;
  final userId = AuthService.firebase().currentUser?.id;
  final UserDatabaseService userService = UserDatabaseService();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  final DeliveryDatabaseService deliveryService = DeliveryDatabaseService();
  List<String> selectedOrderIdList = [];
  bool isMultiSelectionEnabled = false;
  
  Widget buildCircle(String text) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
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
      print('Error fetching user data: $e');
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
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('HH:mm a').format(currentTime);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: const AppBarNoArrow(
          title: 'Delivery start', 
          barColor: deliveryColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:  widget.orderDeliveryOpened == null
            ? Center(
              child: Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                child: const Center(
                  child: Text(
                    "No order for delivery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30
                    ),
                  )
                ),
              )
            )
            : Column(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildCircle('MA1'),
                        buildArrow(),
                        buildCircle('MA2'),
                        buildArrow(),
                        buildCircle('MA3'),
                        buildArrow(),
                        buildCircle('MA4'),
                        buildArrow(),
                        buildCircle('MA5'),
                      ],
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
                                displayTextField(platNumController, 'Car Plate Number', 'Car plate number', 'Cannot be empty'),

                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 130,
                                  width: 180,
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all()
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                            width: 80,
                                            child: Text(
                                              'Current Location',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            width:80,
                                            decoration: BoxDecoration(
                                              border: Border.all()
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                            width: 80,
                                            child: Text(
                                              'Next Location',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            width:80,
                                            decoration: BoxDecoration(
                                              border: Border.all()
                                            ),
                                          )
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: (){

                                  }, 
                                  child: const Text(
                                    'Start delivery',
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  )
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
                          stream: custOrderService.getPendingOrder(widget.orderDeliveryOpened!.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Container(
                                height: 400,
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