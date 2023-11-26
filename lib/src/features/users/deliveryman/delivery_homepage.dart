import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';

class DeliveryManHomePage extends StatefulWidget {
  const DeliveryManHomePage({super.key});

  @override
  State<DeliveryManHomePage> createState() => _DeliveryManHomePageState();
}

class _DeliveryManHomePageState extends State<DeliveryManHomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return Scaffold(
      drawer: DrawerFunction(userId: userId),
      appBar: AppBar(
        backgroundColor: deliveryColor,
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