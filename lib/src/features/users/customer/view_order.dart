import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer/cancel_page.dart';
import 'package:flutter_application_1/src/features/users/customer/order_data.dart';
import 'package:flutter_application_1/src/features/users/customer/order_detail.dart';
import 'package:flutter_application_1/src/features/users/customer/order_display_page.dart';
import 'package:intl/intl.dart';

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
        if (_remainingTime.inSeconds <= 0) {
          _timer.cancel();
          _showOrderClosedDialog();
        }
      });
    });
  }

  void _calculateRemainingTime() {
    _remainingTime = closingTime.difference(DateTime.now());
    if (_remainingTime.isNegative) {
      _calculateClosingAndRemainingTime();
    }
  }

  void _calculateClosingAndRemainingTime() {
    DateTime now = DateTime.now();
    closingTime = DateTime(now.year, now.month, now.day, 11, 0, 0);

    // If closing time is in the past, set it to the next day
    if (closingTime.isBefore(now)) {
      closingTime = closingTime.add(Duration(days: 1));
    }

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

  void _viewOrderDetails() async {
    String userEmail = 'sample@email.com';
    String userName = 'John Doe';
    String userPickupPlace = '123 Main Street';
    String userPhoneNumber = '+1 123-456-7890';
    List<String> userDishes = ['Chicken Rice', 'Nasi Lemak'];
    List<String> userSideDishes = ['Egg', 'Sambal'];

    OrderData orderData = OrderData(
      email: userEmail,
      name: userName,
      pickupPlace: userPickupPlace,
      phoneNumber: userPhoneNumber,
      dishes: userDishes,
      sideDishes: userSideDishes,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDisplayPage(orderData: orderData),
      ),
    );
  }

  void _cancelOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CancelOrderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOrderButtonEnabled = _remainingTime.inSeconds > 0;
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
          ListTile(
            title: Text('Cancel order'),
            subtitle: Text('Delivery hasn\'t started'),
            enabled: false,
          ),
          ElevatedButton(
            onPressed: _cancelOrder,
            child: Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}
