import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset('images/homeImage.jpg', height: size.height*0.2),
                Text(
                  "SIGN up!", 
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Create your profile.',
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

