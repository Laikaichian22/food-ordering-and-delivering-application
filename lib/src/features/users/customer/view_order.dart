import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer/Confirmation_Page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/src/features/users/customer/order_detail.dart';

class ViewOrder extends StatefulWidget {
  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  late Timer _timer;
  late DateTime closingTime;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();

    // Calculate initial closing time and remaining time
    _calculateClosingAndRemainingTime();

    // Set up a timer to update remaining time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
        if (_remainingTime.inSeconds == 0) {
          _timer.cancel();
          _showOrderClosedDialog();
        }
      });
    });
  }

  void _calculateRemainingTime() {
    // Calculate the difference between closing time and current time
    _remainingTime = closingTime.difference(DateTime.now());

    // If the closing time has already passed for the day, calculate for the next day
    if (_remainingTime.isNegative) {
      _calculateClosingAndRemainingTime();
    }
  }

  void _calculateClosingAndRemainingTime() {
    // Calculate the closing time for the next day at 11 a.m.
    DateTime now = DateTime.now();
    closingTime = DateTime(now.year, now.month, now.day + 1, 11, 0, 0);

    // Recalculate the remaining time
    _calculateRemainingTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((segment) => segment.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  void _showOrderClosedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Closed'),
          content: Text('The order has been closed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetails()),
    );
  }
void _viewOrderDetails() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ConfirmationPage(
        // Replace with actual order details
        email: 'sample@email.com',
        name: 'John Doe',
        pickupPlace: 'Sample Place',
        phoneNumber: '+1234567890',
        dishes: const ['Dish1', 'Dish2'],
        sideDishes: const ['SideDish1', 'SideDish2'],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    bool isOrderButtonEnabled = _remainingTime.inSeconds > 0;

    // Get the current date and format it
    String currentDate = DateFormat('EEEE').format(DateTime.now());
    String displayDate = 'Lunch $currentDate';

    return Scaffold(
      appBar: AppBar(
        title: const Text('UmaiFood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // TODO: Add logic for opening the menu
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.all(10.0),
            child: ExpansionTile(
              title: Text('Place order'),
              subtitle: Text(displayDate),
              trailing: const Text('Open'),
              initiallyExpanded: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Close order at ${DateFormat('h:mm a').format(closingTime)}'),
                    Text('Closing in ${_formatTime(_remainingTime)}'),
                  ],
                ),
                ElevatedButton(
                  onPressed: isOrderButtonEnabled ? _placeOrder : null,
                  child: Text('Place Order'),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.lightBlueAccent,
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('View order details'),
              subtitle: Text('You haven\'t placed any order'),
              onTap: _viewOrderDetails,
            ),
          ),
          const ListTile(
            title: Text('Cancel order'),
            subtitle: Text('Delivery hasn\'t started'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
