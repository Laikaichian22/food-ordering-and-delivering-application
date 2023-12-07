import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/customer/view_order.dart';
import 'order_detail.dart'; // Assuming you have a file named order_detail.dart for the OrderDetail page

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key, required String email, required String name, required String pickupPlace, required String phoneNumber, required List<String> dishes, required List<String> sideDishes}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? _paymentMethod;
  List<String> _paymentMethods = ['Cash', 'Online Bank Transfer', 'TNG'];

  @override
  Widget build(BuildContext context) {
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
                for (String paymentMethod in _paymentMethods)
                  RadioListTile<String>(
                    value: paymentMethod,
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                    title: Text(paymentMethod),
                  ),
              ],
            ),
          ),
          // Add a container for viewing the receipt
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate directly to the OrderDetail page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => OrderDetails()),
                    );
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the View Order page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewOrder()),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
