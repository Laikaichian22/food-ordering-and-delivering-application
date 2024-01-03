import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile_edit.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class DeliveryEditProfilePage extends StatefulWidget {
  const DeliveryEditProfilePage({super.key});

  @override
  State<DeliveryEditProfilePage> createState() => _DeliveryEditProfilePageState();
}

class _DeliveryEditProfilePageState extends State<DeliveryEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    final userId = AuthService.firebase().currentUser?.id;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: deliveryColor,
          title: const Text(
            editProfiletxt,
            style: TextStyle(
              fontSize: 20,
              color: textBlackColor,
            ),),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                deliveryProfileRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconBlackColor
            ),
          ),
        ),
        body: EditProfileWidget(userId: userId.toString(), colorUsed: deliveryColor)
      ),
    );
  }
}