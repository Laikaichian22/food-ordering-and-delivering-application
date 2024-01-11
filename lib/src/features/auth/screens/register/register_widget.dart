import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/services/notification/notification_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
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
  final plateNumController = TextEditingController();
  final specialCodeController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String specialCodeOwner = 'admin123';
  String token = '';
  bool _isObscure = true;
  
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
    specialCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeToken(); 
  }

  Future<void>_initializeToken()async{
    try{
      final notificationToken = await NotificationServices().getDeviceToken();
      setState(() {
        token = notificationToken;
      });
    }catch (e){
      debugPrint('Error in getting token');
    }
  }


  @override
  Widget build(BuildContext context) {
    UserDatabaseService service = UserDatabaseService();

    Future<void>uploadData()async{
      final currentUser = AuthService.firebase().currentUser!;
      final userId = currentUser.id;
      await service.addUser(
        UserModel(
          userId: userId,
          email : emailController.text.trim(),
          phone: phoneController.text.trim(),
          fullName: fullNameController.text.trim(),
          role: role,
          carPlateNum: plateNumController.text.trim(),
          profileImage: '',
          token: token
        )
      );
    }

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
                }else{
                  return null;
                }
              },
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
                }else if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                  return invalidFormatEmailtxt;
                }else{
                  return null;
                }
              },
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
                }else{
                  return null;
                }
              },
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
                }else{
                  return null;
                }
              },
            ),

            const SizedBox(height:20),
            
            role == 'Delivery man'
            ? TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: plateNumController,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.car_rental_outlined),
                  labelText: 'Plate-number',
                  hintText: 'Enter your car plate number',
                  border: OutlineInputBorder(),
                ),
                validator:(value) {
                  if(value!.isEmpty){
                    return 'Car plate number can not be empty';
                  }else{
                    return null;
                  }
                },
              )
            : Container(),

            role == 'Business owner'
            ? TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: specialCodeController,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.key_outlined),
                  labelText: 'Special code',
                  hintText: 'Enter special code',
                  border: OutlineInputBorder(),
                ),
                validator:(value) {
                  if(value!.isEmpty){
                    return 'Special code can not be empty';
                  }else{
                    return null;
                  }
                },
              )
            : Container(),
            
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
                  backgroundColor: Colors.amber,
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 92, 90, 85),
                ),
                onPressed: () async { 
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  if(_formkey.currentState!.validate()){
                    try{
                      if(role == 'Business owner'){
                        if(specialCodeController.text.trim() != specialCodeOwner){
                          showErrorDialog(
                            context, 'Invalid special code. Please get it from the developer.'
                          );
                        }else{
                          await AuthService.firebase().createUser(email: email, password: password)
                          .then((value) async => await uploadData());
                          AuthService.firebase().sendEmailVerification();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        }
                      }else{
                        await AuthService.firebase().createUser(email: email, password: password)
                        .then((value) async => await uploadData());
                        AuthService.firebase().sendEmailVerification();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      }
                  
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
