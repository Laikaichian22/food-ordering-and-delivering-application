import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  
  DateTime currentTime = DateTime.now();
  late Timer timer;
  late DateTime selectedStartTime;
  late DateTime selectedEndTime;
  late Duration remainingTime;

  Future<void> _selectDateAndTime(
    BuildContext context,
    bool isStartTime,
  ) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: isStartTime
        ? widget.orderSelected.startTime ?? DateTime.now()
        : widget.orderSelected.endTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStartTime
              ? widget.orderSelected.startTime ?? DateTime.now()
              : widget.orderSelected.endTime ?? DateTime.now(),
        ),
      );

      if (pickedTime != null) {
        setState(() {
          if (isStartTime) {
            selectedStartTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          } else {
            selectedEndTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Format the DateTime with seconds having leading zeros
    return DateFormat('yyyy-MM-dd HH:mm:ss a').format(dateTime);
  }


  @override
  void initState() {
    super.initState();
    selectedStartTime = widget.orderSelected.startTime ?? DateTime.now();
    selectedEndTime = widget.orderSelected.endTime ?? DateTime.now();
    // Calculate the initial remaining time
    remainingTime = widget.orderSelected.endTime!.difference(DateTime.now());

    // Set up a timer to update the remaining time every second
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        remainingTime = widget.orderSelected.endTime!.difference(DateTime.now());

        // If the remaining time is negative, stop the timer
        if (remainingTime.isNegative) {
          timer.cancel();
          remainingTime = Duration.zero;
        }
      });
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
        appBar: AppBarNoArrow(
          title: widget.orderSelected.orderName!, 
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
                            onTap: () => _selectDateAndTime(context, false),
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
                                        onPressed: (){
                                          Provider.of<OrderProvider>(context, listen: false).setCurrentOrder(widget.orderSelected);
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
                                        onPressed: (){
                                          Provider.of<OrderProvider>(context, listen: false).closeOrder();
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