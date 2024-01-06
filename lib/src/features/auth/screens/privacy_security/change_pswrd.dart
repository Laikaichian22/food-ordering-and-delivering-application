import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    required this.userId,
    super.key
  });
  final String userId;
  
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool showProgress = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), 
            onPressed: () { 
              Navigator.of(context).pushNamedAndRemoveUntil(
                privacySecurityRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.7,
            padding: const EdgeInsets.all(tPaddingSize),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  changePswrdTitletxt,
                  style: TextStyle(
                    fontSize: 30, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
    
                const SizedBox(height: 50),

                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        oldPswrdtxt,
                        style: TextStyle(fontSize: 25, color: Colors.black)
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: oldPasswordController,
                        obscureText: _isObscure1,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: hintOldPswrdtxt,
                          border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure1
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () async{
                                setState(() {
                                  _isObscure1 = !_isObscure1;
                                });
                              }
                            ),
                        ),
                        validator:(value) {
                          if(value!.isEmpty){
                            return passwordCanntEmptytxt;
                          }
                          else{
                            return null;
                          }
                        },
                        onChanged: (value){},
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        newPswrdtxt,
                        style: TextStyle(fontSize: 25, color: Colors.black)
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: newPasswordController,
                        obscureText: _isObscure2,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: hintNewPswrdtxt,
                          border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () async{
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              }
                            ),
                        ),
                        validator:(value) {
                          if(value!.isEmpty){
                            return passwordCanntEmptytxt;
                          }
                          else{
                            return null;
                          }
                        },
                        onChanged: (value){},
                      ),
                    ],
                  )
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      elevation: 10,
                      shadowColor: shadowClr,
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {  
                          if (states.contains(MaterialState.pressed)){
                            return Colors.blue;
                          }
                          return null;
                        }),
                    ),
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        try{
                          
                          // await user.updatePassword(newPasswordController.toString().trim())
                          //   .then((value){
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text('password updated', style: TextStyle(color: Colors.black),),
                          //         backgroundColor: Colors.amber,
                          //       )
                          //     );
                          //   }).catchError((error){
                          //     print('here11111111111');
                          //     print(error);
                          //   });
                          final cred = EmailAuthProvider.credential(email: user.email!, password: oldPasswordController.toString().trim());
                          await user.reauthenticateWithCredential(cred)
                          .then((value) async{
                            await user.updatePassword(newPasswordController.toString().trim())
                            .then((value){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('password updated', style: TextStyle(color: Colors.black),),
                                  backgroundColor: Colors.amber,
                                )
                              );
                            }).catchError((error){
                              print('here11111111111');
                              print(error);
                            });
                          }).catchError((error){
                            showErrorDialog(
                            context, 
                            error.toString(),
                          );
                          });
                        }on WeakPasswordAuthException{
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(
                            context, 
                            weakPasswordtxt
                          );
                        }on UserNotFoundAuthException{
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(
                            context, 
                            userNotFoundtxt
                          );
                        }on GenericAuthException{
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(
                            context, 
                            failRegistertxt,
                          );
                        }
                      }
                    }, 
                    child: const Text(
                      'Save', 
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 20
                      ),
                    ),
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}