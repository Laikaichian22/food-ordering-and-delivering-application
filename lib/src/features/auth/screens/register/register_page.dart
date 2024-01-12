import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/register/register_widget.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterView();
}

class _RegisterView extends State<Register>{
    
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(tPaddingSize),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signUptxt, 
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  createProfiletxt,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                RegisterFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

