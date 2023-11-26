import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/logout.dart';

class BusinessOwnerHomePage extends StatefulWidget {
  const BusinessOwnerHomePage({super.key});

  @override
  State<BusinessOwnerHomePage> createState() => _BusinessOwnerHomePageState();
}

class _BusinessOwnerHomePageState extends State<BusinessOwnerHomePage> {

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return Scaffold(
      drawer: DrawerFunction(userId: userID),
      appBar: AppBar(
        backgroundColor: ownerColor,
        elevation: 0.0,
      ),
      body: Column(
        
      )
    );
  }
}