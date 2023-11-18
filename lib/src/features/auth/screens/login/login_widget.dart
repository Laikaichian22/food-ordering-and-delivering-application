import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_option.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formkey,
        child: Container(
          //spacing
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: 'E-mail',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
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
                onChanged: (value) {},
              ),

              const SizedBox(height:30),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                obscureText: _isObscure,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }
                  ),
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return "Password cannot be empty";
                  }
                  else{
                    return null;
                  }
                },
                onChanged: (value) {},
              ),

              const SizedBox(height:20),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async{
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  }, 
                  child: const Text(tForgetPasswordTitle)
                ),
              ),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: Colors.purple,
                      //construct shadow color
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 92, 90, 85),
                    ).copyWith(
                      //change color onpressed
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {  
                          if (states.contains(MaterialState.pressed))
                            return Colors.blue;
                          return null; // Defer to the widget's default.
                      }),
                    ),
                  onPressed: ()async {
                    if(_formkey.currentState!.validate()){
                      try{   
                        await AuthService.firebase().logIn(
                            email: emailController.text, 
                            password: passwordController.text,
                          );

                        final user = AuthService.firebase().currentUser!;
                        final userId = user.id;

                        if(user?.isEmailVerified??false){
                          
                          await FirebaseFirestore.instance.collection('users')
                          .doc(userId)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) async {
                            
                            if(documentSnapshot.exists){
                              
                              if(documentSnapshot.get('role') == "Business owner"){
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    businessOwnerRoute, 
                                    (route) => false,
                                );
                              }
                              else if(documentSnapshot.get('role') == "Customer"){
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    customerRoute, 
                                    (route) => false,
                                );
                              }else if(documentSnapshot.get('role') == "Delivery man"){
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    deliveryManOwnerRoute, 
                                    (route) => false,
                                );
                              }
                              else{
                                await showErrorDialog(
                                  context, 
                                  'Invalid account',
                                );
                              }
                            }else{
                              await showErrorDialog(
                                context, 
                                'Document does not exist',
                              );
                            }
                          });
                        }else{
                          await showErrorDialog(
                            context, 
                            'Fail to login.\nPlease verify your email first.',
                          );
                          //user's email is not verified
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, 
                            (route) => false,
                          );
                        }
                      }on UserNotFoundAuthException {
                        // ignore: use_build_context_synchronously
                        await showErrorDialog(
                          context, 
                          'User not found. Please ensure you enter correct email and password',
                        );
                      }on GenericAuthException{
                        // ignore: use_build_context_synchronously
                        await showErrorDialog(
                          context, 
                          'Authentication error.',
                        );
                      }
                    } 
                  },                     
                  child: Text('Login', style: TextStyle(fontSize: 20),)
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    //on pressed, will lead to register page
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute, 
                      (route) => false,
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states){
                        if(states.contains(MaterialState.hovered))
                          return const Color.fromARGB(255, 249, 201, 29);
                        return const Color.fromARGB(255, 79, 79, 79);
                      }
                    ),
                  ),
                  child: const Text('Not registered yet? Register here!',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

