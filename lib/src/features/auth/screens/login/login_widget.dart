import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_option.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key
  });
  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
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
                labelText: labelEmailtxt,
                hintText: hintEmailtxt,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return emailCanntEmptytxt;
                }
                else if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                  return invalidFormatEmailtxt;
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
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: labelPasswordtxt,
                hintText: hintPasswordtxt,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure
                    ? Icons.visibility_off
                    : Icons.visibility
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }
                ),
              ),
              validator: (value) {
                if(value!.isEmpty){return passwordCanntEmptytxt;}
                else{return null;}
              },
            ),

            const SizedBox(height:20),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async{
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                }, 
                child: const Text(forgetPasswordTitletxt)
              ),
            ),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 92, 90, 85),
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
                      if(user.isEmailVerified){
                        await FirebaseFirestore.instance.collection('user')
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
                                deliveryManRoute, 
                                (route) => false,
                              );
                            }
                            else{
                              await showErrorDialog(
                                context, 
                                invalidAcctxt,
                              );
                            }
                          }else{
                            await showErrorDialog(
                              context, 
                              docNotExisttxt,
                            );
                          }
                        });
                      }else{
                        // ignore: use_build_context_synchronously
                        await showErrorDialog(
                          context, 
                          loginFailtxt,
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, 
                          (route) => false,
                        );
                      }
                    }on UserNotFoundAuthException {
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(context, userNotFoundtxt);
                    }on InvalidEmailAuthException {
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(context, 'Invalid email entered');
                    }on NetworkRequestException{
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(context, 'Please ensure network is connected.');
                    }on TryAgainException{
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(context, 'Something goes wrong. Please try again.');
                    }
                    on GenericAuthException{
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(context, authErrortxt);
                    }
                  } 
                },                     
                child: const Text(loginBtntxt, style: TextStyle(fontSize: 20),)
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
                child: const Text(
                  notYetRegistertxt,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}