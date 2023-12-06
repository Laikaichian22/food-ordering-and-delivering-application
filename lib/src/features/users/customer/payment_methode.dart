import 'package:flutter/material.dart';

class paymentMethode extends StatefulWidget {
  const paymentMethode({Key? key}) : super(key: key);

  @override
  State<paymentMethode> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<paymentMethode> {
  // Declare a variable to store the selected payment method
  String? _paymentMethod;

  // Declare a list of payment methods
  List<String> _paymentMethods = [
    'Cash',
    'Online Bank Transfer',
    'TNG',
  ];

  @override
  Widget build(BuildContext context) {
    // Get the current date and format it
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Umai Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your order at $currentDate',
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
          Spacer(),
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
