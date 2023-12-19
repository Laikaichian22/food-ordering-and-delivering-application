import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuImageController with ChangeNotifier{
  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  Future pickGalleryImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    notifyListeners();
    // if(pickedFile != null){
    //   _image = XFile(pickedFile.path);
    //   uploadMenuImage(context);
    //   notifyListeners();
    // }
  }

  Future pickCameraImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    // if(pickedFile != null){
    //   _image = XFile(pickedFile.path);
    //   uploadMenuImage(context);
    //   notifyListeners();
    // }
  }
 pickMenuImage(context){
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please select your option:'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  onTap: (){
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_outlined,size: 30),
                  title: const Text('Camera', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: (){
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image_outlined, size: 30),
                  title: const Text('Gallery', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
        );
      }
    );
  } 

  void uploadMenuImage(BuildContext context)async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    var storageRef = FirebaseStorage.instance.ref().child('dishImages/$fileName.jpg');
    var uploadTask = storageRef.putFile(File(image!.path).absolute);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    // userCollection.doc(userId).update({
    //   'image': downloadUrl.toString()
    // });
  }
}