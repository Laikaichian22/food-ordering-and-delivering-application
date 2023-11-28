import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userID),
        appBar: AppBar(
          backgroundColor: deliveryColor, // Assuming you have a color for delivery
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CardWidget(
                title: 'Delivery Requests',
                iconBtn: Icons.delivery_dining_outlined,
                subTitle: 'View and manage delivery requests',
                cardColor: Colors.green, // Customize the color
                onTap: () {
                  // Add functionality for delivery requests
                },
              ),
              CardWidget(
                title: 'Delivery History',
                iconBtn: Icons.history,
                subTitle: 'View completed deliveries',
                cardColor: Colors.blue, // Customize the color
                onTap: () {
                  // Add functionality for delivery history
                },
              ),
              CardWidget(
                title: 'Delivery Status',
                iconBtn: Icons.directions_car,
                subTitle: 'Track the status of ongoing deliveries',
                cardColor: Colors.orange, // Customize the color
                onTap: () {
                  // Add functionality for delivery status
                },
              ),
              // Add more cards for additional features related to delivery
            ],
          ),
        ),
      ),
    );
  }
}

// The CardWidget class remains the same as in the original code
