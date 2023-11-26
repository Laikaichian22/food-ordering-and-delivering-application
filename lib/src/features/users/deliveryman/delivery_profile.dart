import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class DeliveryManProfilePage extends StatefulWidget {
  const DeliveryManProfilePage({super.key});

  @override
  State<DeliveryManProfilePage> createState() => _DeliveryManProfilePageState();
}

class _DeliveryManProfilePageState extends State<DeliveryManProfilePage> {
  final userId = AuthService.firebase().currentUser?.id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: deliveryColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: transparentClr,
          bottomOpacity: 0.0,
          elevation: 0.0,
          // New parameter:
          scrolledUnderElevation: 0,
          title: const Text(
            profileTitletxt,
            style: TextStyle(
              fontSize: 20,
              color: textBlackColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textBlackColor),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                deliveryManRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: GeneralProfilePage(userId: userId.toString(), colorUsed: deliveryColor),
      ),
    );
  }
}