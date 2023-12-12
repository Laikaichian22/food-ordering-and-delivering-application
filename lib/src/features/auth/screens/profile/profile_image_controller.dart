import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier{

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final userId = AuthService.firebase().currentUser?.id;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  @override
  void dispose(){
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future pickGalleryImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedFile != null){
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(pickedFile != null){
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }


  void pickImage(context){
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please select your option:'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  onTap: (){
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.camera_outlined,size: 30),
                  title: Text('Camera', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: (){
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.image_outlined, size: 30),
                  title: Text('Gallery', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
        );
      }
    );
  } 

  void uploadImage(BuildContext context)async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    var storageRef = FirebaseStorage.instance.ref().child('profileImage/$fileName.jpg');
    var uploadTask = storageRef.putFile(File(image!.path).absolute);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    userCollection.doc(userId).update({
      'image': downloadUrl.toString()
    });
  }

  Future<void> showFullNameDialogAlert(BuildContext context, String fName){
    fullNameController.text = fName;
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text(updateFNametxt),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formkey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
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
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text(cancelBtntxt, style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: (){
                if(_formkey.currentState!.validate()){
                  userCollection.doc(userId).update({
                    'fullName': fullNameController.text.toString(),
                  }).then((value) {
                    fullNameController.clear();
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(fNameUpdatedtxt, style: TextStyle(color: Colors.black),),
                        backgroundColor: Colors.amber,
                      )
                    );
                  });
                  Navigator.pop(context);
                }
              }, 
              child: const Text(saveBtntxt, style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      }
    );
  }

  Future<void> showEmailDialogAlert(BuildContext context, String email){
    emailController.text = email;
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text(updateEmailtxt),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formkey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
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
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text(cancelBtntxt, style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: (){
                if(_formkey.currentState!.validate()){
                  userCollection.doc(userId).update({
                  'email': emailController.text.toString(),
                  }).then((value) {
                    emailController.clear();
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(emailUpdatedtxt, style: TextStyle(color: Colors.black),),
                        backgroundColor: Colors.amber,
                      )
                    );
                  });
                  Navigator.pop(context);
                }
              }, 
              child: const Text(saveBtntxt, style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      }
    );
  }

  Future<void> showPhoneDialogAlert(BuildContext context, String phone){
    phoneController.text = phone;
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text(updatephonetxt),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
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
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text(cancelBtntxt, style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: (){
                userCollection.doc(userId).update({
                  'phone': phoneController.text.toString(),
                }).then((value) {
                  phoneController.clear();
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(phoneUpdatedtxt, style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.amber,
                    )
                  );
                });
                Navigator.pop(context);
              }, 
              child: const Text(saveBtntxt, style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      }
    );
  }


}

