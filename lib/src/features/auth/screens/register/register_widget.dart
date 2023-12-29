import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/error_dialog.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
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
  void dispose(){
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
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
              controller: fullNameController,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                labelText: labelFNametxt,
                hintText: hintFNametxt,
                border: OutlineInputBorder(),
              ),
              validator:(value) {
                if(value!.isEmpty){
                  return fNameCanntEmptytxt;
                }else if(!RegExp(r'^[a-z A-Z]').hasMatch(value)){
                  return onlyAlphabetvaluetxt;
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
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: labelEmailtxt,
                hintText: hintEmailtxt,
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

            const SizedBox(height:20),

            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_android_outlined),
                labelText: labelPhonetxt,
                hintText: hintPhonetxt,
                border: OutlineInputBorder(),
              ),
              validator:(value) {
                if(value!.isEmpty){
                  return phoneCanntEmptytxt;
                }else if(!RegExp(r"^(\+?6?01)[02-46-9]-*[0-9]{7}$|^(\+?6?01)[1]-*[0-9]{8}$").hasMatch(value)){
                  return invalidFormatPhonetxt;
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
              obscureText: _isObscure,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: labelPasswordtxt,
                hintText: hintPasswordtxt,
                border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () async{
                      setState(() {
                        _isObscure = !_isObscure;
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

            const SizedBox(height:20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  roleTitletxt,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 210, 209, 209), 
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
                          style: const TextStyle(
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
                      if (states.contains(MaterialState.pressed)){
                        return Colors.blue;
                      }
                      return null; // Defer to the widget's default.
                    }),
                ),
                onPressed: () async { 

                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final fullName = fullNameController.text.trim();
                  final phoneNum = phoneController.text.trim();
                  
                  if(_formkey.currentState!.validate()){
                    try{
                      //initial sign up/register
                      setState(() {
                        showProgress = true;
                      });
                      await AuthService.firebase().createUser(email: email, password: password)
                      .then((value) => postDetailsToFirestore(fullName, phoneNum, email, role));
                      AuthService.firebase().sendEmailVerification();
                      
                      //pushNamed->will not replace the page to new page, just appear on it
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                  
                    }on WeakPasswordAuthException{
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(
                        context, 
                        weakPasswordtxt
                      );
                    }on EmailAlreadyInUseAuthException{
                      // ignore: use_build_context_synchronously
                      await showErrorDialog(
                        context, 
                        emailInUsetxt
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
                  registerBtntxt,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
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
    .set({'fullName':fullName, 'phone':phone, 'email':email, 'role': role, 'id': userId, 'image':''});
}