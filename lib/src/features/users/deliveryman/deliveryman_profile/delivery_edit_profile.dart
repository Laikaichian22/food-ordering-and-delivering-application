import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
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
    final userId = AuthService.firebase().currentUser?.id;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: editProfiletxt, 
          userRole: 'deliveryMan',
          onPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                deliveryProfileRoute, 
                (route) => false,
              );
            }, 
          barColor: deliveryColor
        ),
        body: EditProfileWidget(userId: userId.toString(), colorUsed: deliveryColor)
      ),
    );
  }
}