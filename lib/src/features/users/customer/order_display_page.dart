// order_display_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer/payment_methode.dart';
import 'order_data.dart';
// Import the payment method page

class OrderDisplayPage extends StatefulWidget {
  final OrderData orderData;

  OrderDisplayPage({required this.orderData});

  @override
  _OrderDisplayPageState createState() => _OrderDisplayPageState();
}

class _OrderDisplayPageState extends State<OrderDisplayPage> {
  void _navigateToPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethod(
          // Pass the order data to the payment method page
          email: widget.orderData.email,
          name: widget.orderData.name,
          pickupPlace: widget.orderData.pickupPlace,
          phoneNumber: widget.orderData.phoneNumber,
          dishes: widget.orderData.dishes,
          sideDishes: widget.orderData.sideDishes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.orderData.email}'),
            Text('Name: ${widget.orderData.name}'),
            Text('Pickup Place: ${widget.orderData.pickupPlace}'),
            Text('Phone Number: ${widget.orderData.phoneNumber}'),
            SizedBox(height: 16.0),
            Text('Selected Dishes: ${widget.orderData.dishes.join(', ')}'),
            Text('Selected Side Dishes: ${widget.orderData.sideDishes.join(', ')}'),
            SizedBox(height: 16.0),
            // Add a "Next" button to navigate to the payment method page
            ElevatedButton(
              onPressed: _navigateToPaymentMethod,
              child: Text('Next to Payment Method'),
            ),
          ],
        ),
      ),
    );
  }
}
