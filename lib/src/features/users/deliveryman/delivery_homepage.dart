import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';


class DeliveryManHomePage extends StatelessWidget {
  const DeliveryManHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UmaiFood'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // TODO: Implement the menu functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: TextButton(
                  child: Text(
                    'Start Delivery',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement the start delivery functionality
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.yellow,
              child: Center(
                child: TextButton(
                  child: Text(
                    'Delivery List',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement the delivery list functionality
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
