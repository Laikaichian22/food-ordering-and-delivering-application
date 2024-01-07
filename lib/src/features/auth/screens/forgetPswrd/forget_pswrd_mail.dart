
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                  Image.asset('images/resetPassword.png', height: height * 0.2),
                  const SizedBox(height: 20),
                  const Text(
                    resetUsingEmailtxt,
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
                            labelText: labelEmailtxt,
                            hintText: emailAddrtxt,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return emailCanntEmptytxt;
                            } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return invalidFormatEmailtxt;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            QuerySnapshot querySnapshot = await UserDatabaseService().getUserByEmail(emailController.text.trim());
                            if (querySnapshot.docs.isNotEmpty) {
                              // Email exists, send password reset email
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim())
                                .then((value) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: Text(
                                          linkSenttxt,
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                });
                            } else {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text(
                                      'Email does not exist.\nPlease use the registered email.',
                                      style: TextStyle(
                                        fontSize: 20
                                      ),
                                    ),
                                  );
                                }
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            print('error code: ${e.code}');
                          }
                        }
                      },
                      child: const Text(
                        resetBtntxt,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
