// cancel_order_page.dart
import 'package:flutter/material.dart';
import 'view_order.dart'; // Import the ViewOrder

class CancelOrderPage extends StatefulWidget {
  @override
  _CancelOrderPageState createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  String userEmail = 'sample@email.com';
  String userName = 'John Doe';
  String userPickupPlace = '123 Main Street';
  String userPhoneNumber = '+1 123-456-7890';
  List<String> userDishes = ['Chicken Rice', 'Nasi Lemak'];
  List<String> userSideDishes = ['Egg', 'Sambal'];

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
      // Clear the user information
      userEmail = '';
      userName = '';
      userPickupPlace = '';
      userPhoneNumber = '';
      userDishes = [];
      userSideDishes = [];
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
            Text(
              'User Information:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: $userEmail'),
                  Text('Name: $userName'),
                  Text('Pickup Place: $userPickupPlace'),
                  Text('Phone Number: $userPhoneNumber'),
                  SizedBox(height: 16.0),
                  Text('Selected Dishes: ${userDishes.join(', ')}'),
                  Text('Selected Side Dishes: ${userSideDishes.join(', ')}'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child: Text('Cancel Order'),
            ),
          ],
        ),
      ),
    );
  }
}
