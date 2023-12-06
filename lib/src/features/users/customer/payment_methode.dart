import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:path/path.dart';
import 'dart:ffi';
class paymentMethode extends StatefulWidget {
   const paymentMethode({super.key});
 
 State<paymentMethode> createState() => _PaymentMethodestate();
}
class _PaymentMethodestate extends State<paymentMethode> {

  // Declare a variable to store the selected payment method
  String? _paymentMethod;

  // Declare a list of payment methods
  List<String> _paymentMethods = [
    'Cash',
    'Online Bank Transfer',
    'TNG',
  ];

  // Declare a function to show the receipt
  
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umai Food'),
      
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lunch Thursday 26/10/2023',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                // Add a title for the payment method section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Add a list of radio list tiles for each payment method
                for (String paymentMethod in _paymentMethods)
                  RadioListTile<String>(
                    value: paymentMethod,
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      // Update the state when the user selects a payment method
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                    title: Text(paymentMethod),
                  ),
              ],
            ),
          ),
          // Add a container with a button to view the receipt
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: null,
                child: Text('View Receipt'),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
