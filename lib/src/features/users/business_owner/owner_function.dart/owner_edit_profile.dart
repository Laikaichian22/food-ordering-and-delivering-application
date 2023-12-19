import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile_edit.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OwnerEditProfilePage extends StatefulWidget {
  const OwnerEditProfilePage({super.key});

  @override
  State<OwnerEditProfilePage> createState() => _OwnerEditProfilePageState();
}

class _OwnerEditProfilePageState extends State<OwnerEditProfilePage> {

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.firebase().currentUser?.id;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: editProfiletxt, 
          onPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                ownrProfileRoute, 
                (route) => false,
              );
            }, 
          barColor: ownerColor
        ),
        body: EditProfileWidget(userId: userId.toString(), colorUsed: ownerColor)
      ),
    );
  }
}