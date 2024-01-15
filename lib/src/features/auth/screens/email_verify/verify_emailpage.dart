import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
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
                const Text(
                  emailVerifyTitletxt,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  )
                ),
                const Icon(Icons.email_outlined,size: 150,),
                const SizedBox(height: 20),
                const Text(
                  verifyEmailAddrtxt,
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 20),
                const Text(
                  line1txt, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  line2txt, 
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
                  child: const Text(resendEmailBtntxt),
                ),
                TextButton(
                  onPressed: ()async{
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, (route) => false,
                    );
                  }, 
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_outlined),
                      SizedBox(width: 5),
                      Text(backLoginBtntxt),
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