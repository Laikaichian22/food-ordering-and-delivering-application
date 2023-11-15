import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterView();
}

class _RegisterView extends State<Register>{
  //late = wait for later input
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController fullNameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool showProgress = false;
  
  var options = [
    'Business owner',
    'Customer',
    'Delivery man',
  ];
  var _currentItemSelected = 'Business owner';
  var role = 'Business owner';
    
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset('images/homeImage.jpg', height: size.height*0.2),
                Text(
                  "SIGN up!", 
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Create your profile.',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: fullNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            labelText: 'Full-Name',
                            hintText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return "Full Name cannot be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          onChanged: (value){},
                        ),
                        
                        const SizedBox(height:20),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: 'E-mail',
                            hintText: 'Email address',
                            border: OutlineInputBorder(),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return "Email address cannot be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          onChanged: (value){},
                        ),

                        const SizedBox(height:20),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: phoneController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android_outlined),
                            labelText: 'Phone-number',
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return "Phone number cannot be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          onChanged: (value){},
                        ),

                        const SizedBox(height:20),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: 'Password',
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return "Password cannot be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          onChanged: (value){},
                        ),

                        const SizedBox(height:20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Role : ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 210, 209, 209), 
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: Colors.blue[200],
                                isDense: true,
                                isExpanded: false,
                                iconEnabledColor: Colors.black,
                                focusColor: Colors.black,
                                items: options.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValueSelected) {
                                  setState(() {
                                    _currentItemSelected = newValueSelected!;
                                    role = newValueSelected;
                                  });
                                },
                                value: _currentItemSelected,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height:30),

                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //change the color of button
                              backgroundColor: Colors.amber,
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
                            onPressed: () async { 
                              final email = emailController.text;
                              final password = passwordController.text;
                              final fullName = fullNameController.text;
                              final phoneNum = phoneController.text;
                              
                              if(_formkey.currentState?.validate() == null) {
                                await showErrorDialog(
                                    context, 
                                  'Please make sure everything is filled',
                                );
                              }else{
                                await AuthService.firebase().createUser(email: email, password: password)
                                .then((value) => postDetailsToFirestore(fullName, phoneNum, email, role));
                              }
                              try{
                                //initial sign up/register
                                setState(() {
                                  showProgress = true;
                                });
                                AuthService.firebase().sendEmailVerification();
                                
                                //pushNamed->will not replace the page to new page, just appear on it
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushNamed(verifyEmailRoute);
                              
                              }on WeakPasswordAuthException{
                                // ignore: use_build_context_synchronously
                                await showErrorDialog(
                                    context, 
                                    'Weak password'
                                  );
                              }on EmailAlreadyInUseAuthException{
                                // ignore: use_build_context_synchronously
                                await showErrorDialog(
                                    context, 
                                    'Email is already in use'
                                  );
                              }on InvalidEmailAuthException{
                                // ignore: use_build_context_synchronously
                                await showErrorDialog(
                                    context, 
                                    'Invalid email entered'
                                  );
                              }on GenericAuthException{
                                // ignore: use_build_context_synchronously
                                await showErrorDialog(
                                    context, 
                                  'Failed to register',
                                );
                              }
                            }, 
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void postDetailsToFirestore(String fullName, String phone, String email, String role) async{
  final currentUser = AuthService.firebase().currentUser!;
  final userId = currentUser.id;
  FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .set({'fullName':fullName, 'phone':phone, 'email':email, 'role': role, 'id': userId});
}

