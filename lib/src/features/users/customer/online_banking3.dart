import 'package:flutter/material.dart';
import 'view_order.dart';

class Onlinebaning3 extends StatefulWidget {
  @override
  State<Onlinebaning3> createState() => _Onlinebanking3State();
}

class _Onlinebanking3State extends State<Onlinebaning3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umai Food'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '[Lunch] ${_getCurrentDate()}',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'We have received your order.\nThanks for your support.\nDo take note that all Orders CANNOT BE CANCELLED after the SELECTED TIME.\nSorry for any inconvenience.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ViewOrder()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Back to Main Page',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    // Format the current date as desired
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }
}
