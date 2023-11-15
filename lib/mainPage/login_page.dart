import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('images/homeImage.jpg', height: size.height*0.25),
                Text(
                  "WELCOME BACK,", 
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Login to experience more advanced food ordering style.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),

                Form(
                  child: Container(
                    //spacing
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                              return "email cannot be empty";
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
                              return "password cannot be empty";
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
                            onPressed: (){}, 
                            child: Text('Forgot Password?')
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
                              if(_formkey.currentState?.validate() == null){
                                await showErrorDialog(
                                  context, 
                                  'Please enter the required information!',
                                );
                              }else{
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
              ],
            ),
          ),
        )
      ),
    );
  }
}
