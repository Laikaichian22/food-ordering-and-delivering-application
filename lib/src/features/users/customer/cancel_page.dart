import 'dart:async';
import 'package:flutter/material.dart';
import 'view_order.dart'; // Import the ViewOrder

class CancelOrderPage extends StatefulWidget {
  @override
  _CancelOrderPageState createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  late Timer _timer;
  late DateTime closingTime;
  late Duration _remainingTime;

  // Dummy user information variables
  String _dummyUserEmail = 'sample@email.com';
  String _dummyUserName = 'John Doe';
  String _dummyUserPickupPlace = '123 Main Street';
  String _dummyUserPhoneNumber = '+1 123-456-7890';
  List<String> _dummyUserDishes = ['Chicken Rice', 'Nasi Lemak'];
  List<String> _dummyUserSideDishes = ['Egg', 'Sambal'];

  @override
  void initState() {
    super.initState();

    // Calculate initial closing time and remaining time
    _calculateClosingAndRemainingTime();

    // Set up a timer to update remaining time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCountdownTimer(),
            SizedBox(height: 16.0),
            _buildUserInfoContainer(),
            ElevatedButton(
              onPressed: _remainingTime.inSeconds > 0 ? _showConfirmationDialog : null,
              child: Text('Cancel Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    String remainingTimeString = _formatTime(_remainingTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Remaining Until Tomorrow 11:00 AM:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          remainingTimeString,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Customize the color as needed
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            _buildUserInfo('Email:', _dummyUserEmail),
            _buildUserInfo('Name:', _dummyUserName),
            _buildUserInfo('Pickup Place:', _dummyUserPickupPlace),
            _buildUserInfo('Phone Number:', _dummyUserPhoneNumber),
            SizedBox(height: 16.0),
            _buildUserInfo('Selected Dishes:', _dummyUserDishes.join(', ')),
            _buildUserInfo('Selected Side Dishes:', _dummyUserSideDishes.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label $value'),
        SizedBox(height: 8.0),
      ],
    );
  }

  String _formatTime(Duration duration) {
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((segment) => segment.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel Order'),
          content: Text('Are you sure you want to cancel your order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelOrder();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder() {
    setState(() {
      // Clear the dummy user information
      _dummyUserEmail = '';
      _dummyUserName = '';
      _dummyUserPickupPlace = '';
      _dummyUserPhoneNumber = '';
      _dummyUserDishes = [];
      _dummyUserSideDishes = [];
    });

    // Display a message indicating that the order is canceled
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order canceled successfully.'),
      ),
    );

    // Redirect to the ViewOrder page
    _redirectToViewOrder();
  }

  void _redirectToViewOrder() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ViewOrder()),
    );
  }
}
