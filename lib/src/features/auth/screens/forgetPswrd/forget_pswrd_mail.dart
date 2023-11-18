import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), 
              onPressed: () { 
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, 
                  (route) => false,
                );
              },
            ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tPaddingSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('images/resetPassword.png', height: height*0.2),
        
                const SizedBox(height: 20),
                
                Text(
                  tResetUsingEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
        
                const SizedBox(height: 20),
        
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'E-mail',
                          hintText: 'Email address',
                          border: OutlineInputBorder(),
                        ),
                        validator:(value) {
                        if(value!.isEmpty){
                          return "Email address cannot be empty";
                        }
                        else if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                          return "Invalid format of email";
                        } 
                        else{
                          return null;
                        }
                      },
                      onChanged: (value){},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height:50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        try{
                          //await AuthService.firebase().sentResetLink(email: emailController.text.trim());
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                          showDialog(
                            context: context, 
                            builder: (context){
                              return AlertDialog(
                                content: Text('Password reset link sent! Check your email'),
                              );
                            }
                          );
                        }on FirebaseAuthException catch(e){
                          print(e);
                        }
                      }
                    }, 
                    child: Text(
                      tResetBtn,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
        
              ],
            )
          ),
        ),
      ),
    );
  }
}

