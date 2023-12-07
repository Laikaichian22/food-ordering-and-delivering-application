import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile_edit.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';


class CustomerEditProfilePage extends StatefulWidget {
  const CustomerEditProfilePage({super.key});

  @override
  State<CustomerEditProfilePage> createState() => _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage> {
  var size, heightMax, widthMax;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;

    final userId = AuthService.firebase().currentUser?.id;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: custColor,
          title: const Text(
            editProfiletxt,
            style: TextStyle(
              fontSize: 20,
              color: textBlackColor,
            ),),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                custProfileRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconBlackColor
            ),
          ),
        ),
        body: EditProfileWidget(userId: userId.toString(), colorUsed: custColor)
      ),
    );
  }
}


