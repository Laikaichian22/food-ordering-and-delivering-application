import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile_edit.dart';

import 'package:flutter_application_1/src/routing/routes_const.dart';

class CustomerEditProfilePage extends StatefulWidget {
  const CustomerEditProfilePage({super.key});

  @override
  State<CustomerEditProfilePage> createState() => _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userId = AuthService.firebase().currentUser?.id;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: editProfiletxt, 
          userRole: 'customer',
          onPress: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              custProfileRoute, 
              (route) => false,
            );
          }, 
          barColor: custColor
        ),
        body: EditProfileWidget(userId: userId.toString(), colorUsed: custColor)
      ),
    );
  }
}
