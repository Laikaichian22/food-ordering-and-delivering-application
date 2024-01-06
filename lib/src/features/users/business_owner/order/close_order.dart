import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CloseOrderPage extends StatefulWidget {
  const CloseOrderPage({
    required this.orderSelected,
    super.key
  });

  final OrderOwnerModel orderSelected;

  @override
  State<CloseOrderPage> createState() => _CloseOrderPageState();
}

class _CloseOrderPageState extends State<CloseOrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserDatabaseService userService = UserDatabaseService();
  final OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();
  DateTime currentTime = DateTime.now();
  bool endTimeChange = false;
  late Timer timer;
  late DateTime selectedStartTime;
  late DateTime selectedEndTime;
  late Duration remainingTime = Duration.zero;

  Future<void> _selectDateAndTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: widget.orderSelected.endTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      // ignore: use_build_context_synchronously
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.orderSelected.endTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          if (timer.isActive) {
            timer.cancel();
            remainingTime = Duration.zero;
          }
          selectedEndTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          orderService.updateOrderEndTime(widget.orderSelected.id!, selectedEndTime);
          remainingTime = selectedEndTime.difference(DateTime.now());
          // Set up a timer to update the remaining time every second
          timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
            setState(() {
              remainingTime = selectedEndTime.difference(DateTime.now());

              // If the remaining time is negative, stop the timer
              if (remainingTime.isNegative) {
                timer.cancel();
                remainingTime = Duration.zero;
              }
            });
          });
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Format the DateTime with seconds having leading zeros
    return DateFormat('yyyy-MM-dd HH:mm:ss a').format(dateTime);
  }

  Future<void> sendNotificationToCustomers(List<String> customerTokens, String choice) async {
    const String serverKey = 'AAAARZkf7Aw:APA91bGSJTuexnDQR8qO4bdNFNCTsVqtLZUguj39lY_hUlMOiMQ7x6uf6mbP_dpEB5mRPFzGNdQd3KVfufllA3ccLcuZ_2mjaBQhoyK15Yz-QrMYTt0gmUyaHZewAxi0d-fsw_sV23vP';
    const String url = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> data = choice == 'Open'
    ? {
        'registration_ids': customerTokens,
        'priority': 'high',
        'notification': {
          'title': 'New Order!',
          'body': 'A new order has been opened and ready to accept your order.',
        },
      }
    : {
        'registration_ids': customerTokens,
        'priority': 'high',
        'notification': {
          'title': 'Order closed!',
          'body': 'Get ready to receive your meal.',
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
  }

  @override
  void initState() {
    super.initState();
    selectedStartTime = widget.orderSelected.startTime ?? DateTime.now();
    selectedEndTime = widget.orderSelected.endTime ?? DateTime.now();
    remainingTime = selectedEndTime.difference(DateTime.now());
      // Calculate the initial remaining time
      remainingTime = widget.orderSelected.endTime!.difference(DateTime.now());
      // Set up a timer to update the remaining time every second
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        setState(() {
          remainingTime = widget.orderSelected.endTime!.difference(DateTime.now());
        });
        // If the remaining time is negative, stop the timer
        if (remainingTime.inMilliseconds <= 0) {
          timer.cancel();
          remainingTime = Duration.zero;
          Provider.of<OrderProvider>(context, listen: false).closeOrder();
          List<String> customerToken = await userService.getCustomerToken();
          await sendNotificationToCustomers(customerToken, 'Close');
        }
      });

  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '$hours : $minutes : $seconds ';
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: DirectAppBarNoArrow(
          title: widget.orderSelected.orderName!, 
          userRole: 'owner',
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: currentOrder==null ? orderClosedColor : orderOpenedColor,
                  child: Center(
                    child: Text(
                      currentOrder == null ? 'Order is in closed status' : 'Order is in open status',
                      style: const TextStyle(
                        fontSize: 30
                      ),
                    )
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        currentOrder == null ? 'You can still re-open the order.' : 'You can still extend the ending time.',
                        style: const TextStyle(
                          fontSize: 20
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Start time: ',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          
                          Text(
                            _formatDateTime(selectedStartTime),
                            style: const TextStyle(
                              fontSize: 21
                            ),
                          ),
                        
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'End time: ',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          Text(
                            _formatDateTime(selectedEndTime),
                            style: const TextStyle(
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () => _selectDateAndTime(context),
                            child: const Icon(
                              Icons.calendar_month_outlined,
                              size: 30,
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const SizedBox(
                            width: 150,
                            child: Text(
                              'Time left before closing order: ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width:150,
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                            child: Center(
                              child: Text(
                                currentOrder == null ? '-' : _formatDuration(remainingTime),
                                style: const TextStyle(
                                  fontSize: 21
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 90),
                      currentOrder == null
                      ? SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orderOpenedColor,
                              elevation: 10,
                              shadowColor: const Color.fromARGB(255, 92, 90, 85),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: const Text('Confirm to re-open order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel')
                                      ),
                                      TextButton(
                                        onPressed: ()async{
                                          Provider.of<OrderProvider>(context, listen: false).setCurrentOrder(widget.orderSelected);
                                          List<String> customerToken = await userService.getCustomerToken();
                                          await sendNotificationToCustomers(customerToken, 'Open');
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
                              'Open order',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ) 
                      : SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orderClosedColor,
                              elevation: 10,
                              shadowColor: const Color.fromARGB(255, 92, 90, 85),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: const Text('Confirm to close order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel')
                                      ),
                                      TextButton(
                                        onPressed: ()async{
                                          Provider.of<OrderProvider>(context, listen: false).closeOrder();
                                          List<String> customerToken = await userService.getCustomerToken();
                                          await sendNotificationToCustomers(customerToken, 'Close');
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
                              'Close order',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}