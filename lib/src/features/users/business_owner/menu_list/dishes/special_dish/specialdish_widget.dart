import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class SpecialDishesWidget extends StatefulWidget{
  SpecialDishesWidget({
    required this.onDelete,
    required this.indexStored,
    required this.uniqueKey,
    required this.specialDishValue,
    required this.specialIdValue, 
    required this.imageUrl,
    super.key
  });

  String specialDishValue;
  String specialIdValue;
  String imageUrl;
  final TextEditingController specialDishName = TextEditingController();
  final TextEditingController specialIdController = TextEditingController();
  File? image;
  final Function(Key) onDelete;
  int indexStored;
  final Key uniqueKey;
  final _formKey = GlobalKey<FormState>(); 
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  State<SpecialDishesWidget> createState() => _SpecialDishesWidgetState();
}

class _SpecialDishesWidgetState extends State<SpecialDishesWidget> {

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
  void initState() {
    super.initState();
    widget.specialDishName.text = widget.specialDishValue;
    widget.specialIdController.text = widget.specialIdValue;
  }

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Form(
          key: widget._formKey,
          child: Column(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: widget.specialDishName,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Dish Name',
                        border: OutlineInputBorder()
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Non-empty value";
                        }
                        return null;
                      },
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
                      child: widget.imageUrl.isNotEmpty 
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                        )
                      : widget.image == null 
                        ? const Icon(Icons.camera_alt_outlined, size: 30)
                        : Image.file(
                            widget.image!,
                            fit: BoxFit.fill,
                          ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      widget.onDelete(widget.uniqueKey);
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      size: 40,
                    ),
                  )
                ],
              ), 
            ],
          ),
        )
      ],
    );
  }
}