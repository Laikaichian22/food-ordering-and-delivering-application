import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
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
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser!;
    final userId = user.id;
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
                        validator:(value) {
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
                      onChanged: (value){},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                      //   FutureBuilder(
                      //     future: FirebaseFirestore.instance.collection('users').doc().get(),
                      //     builder: (BuildContext context, snapshot) {
                      //       if(snapshot.connectionState == ConnectionState.done){
                      //         if(snapshot.hasData){
                      //           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      //           if()
                      //         }
                      //       }else{
                      //         return const CircularProgressIndicator();
                      //       }
                      //   },
                      // );
                        // await FirebaseFirestore.instance.collection('users')
                        //   .doc(userId)
                        //   .get()
                        //   .then((DocumentSnapshot documentSnapshot) async {

                        //   });
                        try{
                          await AuthService.firebase().sentResetLink(email: emailController.text.trim());
                          //await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                          showDialog(
                            context: context, 
                            builder: (context){
                              return AlertDialog(
                                content: Text(linkSenttxt),
                              );
                            }
                          );
                        }on FirebaseAuthException catch(e){
                          print(e);
                        }
                      }
                    }, 
                    child: Text(
                      resetBtntxt,
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

