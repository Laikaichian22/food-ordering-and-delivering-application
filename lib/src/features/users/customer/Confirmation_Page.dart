import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer/payment_methode.dart';
 // Import the MakePaymentPage

class ConfirmationPage extends StatelessWidget {
  final String email;
  final String name;
  final String pickupPlace;
  final String phoneNumber;
  final List<String> dishes;
  final List<String> sideDishes;

  ConfirmationPage({
    required this.email,
    required this.name,
    required this.pickupPlace,
    required this.phoneNumber,
    required this.dishes,
    required this.sideDishes,
  });

  void _navigateToMakePayment(BuildContext context) {
    // Navigate to the MakePaymentPage with the stored data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>PaymentMethod(
          email: email,
          name: name,
          pickupPlace: pickupPlace,
          phoneNumber: phoneNumber,
          dishes: dishes,
          sideDishes: sideDishes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal details:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Email: $email'),
                  Text('Name: $name'),
                  Text('Pickup Place: $pickupPlace'),
                  Text('Phone Number: $phoneNumber'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Dishes:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishes.map((dish) => Text(dish)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Side Dishes:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sideDishes.map((sideDish) => Text(sideDish)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _navigateToMakePayment(context);
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
