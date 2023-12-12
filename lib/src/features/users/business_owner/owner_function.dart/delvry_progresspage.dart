import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OwnerDeliveryProgressPage extends StatefulWidget {
  const OwnerDeliveryProgressPage({super.key});

  @override
  State<OwnerDeliveryProgressPage> createState() => _OwnerDeliveryProgressPageState();
}

class _OwnerDeliveryProgressPageState extends State<OwnerDeliveryProgressPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Delivery Progress', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
      ),
    );
  }
}