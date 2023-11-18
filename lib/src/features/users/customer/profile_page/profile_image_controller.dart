import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier{
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final userId = AuthService.firebase().currentUser?.id;
  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;


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

    var storageRef = FirebaseStorage.instance.ref().child('profileImage/');
    var uploadTask = storageRef.putFile(File(image!.path).absolute);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    userCollection.doc(userId).update({
      'image': downloadUrl.toString()
    });
  }
}

