import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class MainDishesWidget extends StatefulWidget{
  MainDishesWidget({
    required this.onDelete,
    required this.index,
    super.key
  });
  
  final TextEditingController mainDishName = TextEditingController();
  final TextEditingController specialIdController = TextEditingController();
  File? image;
  final VoidCallback onDelete;
  int index;
  

  @override
  State<MainDishesWidget> createState() => _MainDishesWidgetState();
}

class _MainDishesWidgetState extends State<MainDishesWidget> {

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
       widget.image = File(pickedFile.path);
      }
    });
  }
  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null){
        widget.image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
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
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_outlined,size: 30),
                  title: const Text('Camera', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: (){
                    getImageFromGallery();
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
  

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: widget.specialIdController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Id',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: widget.mainDishName,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Dish Name',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    showOptions();
                  },
                  child: Container(
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    child: widget.image == null 
                    ? const Icon(Icons.camera_alt_outlined, size: 30)
                    : Image.file(
                        widget.image!,
                        fit: BoxFit.fill,
                      ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    widget.onDelete();
                  },
                  child: const Icon(
                    Icons.delete_outline_outlined,
                    size: 40,
                  ),
                )
              ],
            ), 
          ],
        )
      ],
    );
  }
}