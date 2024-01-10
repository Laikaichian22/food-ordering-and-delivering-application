import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key
  });
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
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
          title: const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          ),
          backgroundColor: drawerColor,
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.7,
            padding: const EdgeInsets.all(tPaddingSize),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            icon: Icon(
                              _isObscure1
                              ? Icons.visibility_off
                              : Icons.visibility
                            ),
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
                          }else{
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
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
                            icon: Icon(
                              _isObscure2
                              ? Icons.visibility_off
                              : Icons.visibility
                            ),
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
                          }else{
                            return null;
                          }
                        },
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 50),

                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      elevation: 10,
                      shadowColor: shadowClr,
                    ),
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        try{
                          final cred = EmailAuthProvider.credential(email: user.email!, password: oldPasswordController.text.trim());
                          await user.reauthenticateWithCredential(cred)
                          .then((value) async{
                            await user.updatePassword(newPasswordController.text.trim())
                            .then((value){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password updated', style: TextStyle(color: Colors.black),),
                                  backgroundColor: Colors.amber,
                                )
                              );
                            }).catchError((error){
                              showErrorDialog(context, 'Error updating password');
                            });

                          }).catchError((error){
                            showErrorDialog(context, 'Incorrect old password');
                          });
                        }on FirebaseAuthException catch (e) {
                          if (e.code == 'wrong-password') {
                            // ignore: use_build_context_synchronously
                            showErrorDialog(context, 'Wrong old password');
                          } else {
                            // ignore: use_build_context_synchronously
                            showErrorDialog(context, 'Failed to reauthenticate');
                          }
                        }
                      }
                    }, 
                    child: const Text(
                      'Save', 
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 25
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