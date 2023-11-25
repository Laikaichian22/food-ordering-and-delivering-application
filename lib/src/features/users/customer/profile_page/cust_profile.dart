import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  final userId = AuthService.firebase().currentUser?.id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          // New parameter:
          scrolledUnderElevation: 0,
          title: const Text(
            profileTitletxt,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                customerRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: GeneralProfilePage(userId: userId.toString()),
      ),
    );
  }
}