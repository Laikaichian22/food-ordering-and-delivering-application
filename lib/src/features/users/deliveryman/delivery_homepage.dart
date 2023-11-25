import 'package:flutter/material.dart';

class DeliveryManHomePage extends StatefulWidget {
  const DeliveryManHomePage({super.key});

  @override
  State<DeliveryManHomePage> createState() => _DeliveryManHomePageState();
}

class _DeliveryManHomePageState extends State<DeliveryManHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Text(
          'Delivery Man', 
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
  
}