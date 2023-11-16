import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  'EMAIL VERIFICATION',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  )
                ),

                Icon(Icons.email_outlined,size: 150,),
    
                const SizedBox(height: 20),
    
                Text(
                  'Please verify your email address',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  )
                ),

                const SizedBox(height: 20),

                Text(
                  "We've sent you an email verfication. Please open it to verify your account.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "\nIf you do not receive the email verification, do press the button below the resend it", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: ()async{
                    AuthService.firebase().sendEmailVerification();
                  }, 
                  child: Text('Resend email verification'),
                ),
                TextButton(
                  onPressed: ()async{
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, (route) => false,
                    );
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_outlined),
                      const SizedBox(width: 5),
                      Text('Back to login page'),
                    ],
                  ),
                ),
              ],
            )
          )
        )
      ),
    );
  }
}

