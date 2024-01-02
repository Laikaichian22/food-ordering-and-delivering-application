import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/login/login_widget.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), 
            onPressed: () { 
              Navigator.of(context).pushNamedAndRemoveUntil(
                welcomeRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('images/homeImage.jpg', height: size.height*0.25),
                const Text(
                  loginTitletxt, 
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  loginSubTitletxt,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const LoginFormWidget(),
              ],
            ),
          ),
        )
      ),
    );
  }
}
