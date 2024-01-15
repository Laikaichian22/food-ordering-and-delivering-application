import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OnlineBankingPage extends StatefulWidget {
  const OnlineBankingPage({super.key});

  @override
  State<OnlineBankingPage> createState() => _OnlineBankingPageState();
}

enum Options{yes, no}

class _OnlineBankingPageState extends State<OnlineBankingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  File? image;
  final TextEditingController bankAccController = TextEditingController();
  final TextEditingController accNumberController = TextEditingController();
  final TextEditingController description1Controller = TextEditingController();
  final TextEditingController description2Controller = TextEditingController();
  final TextEditingController methodNameController = TextEditingController();
  PayMethodDatabaseService methodService = PayMethodDatabaseService();
  bool btnYes = false;
  final _formkey = GlobalKey<FormState>();
  Options groupVal = Options.no;
  String? receiptChoice;
  bool isLoading = false;
  bool anyChanges = false;

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
       image = File(pickedFile.path);
      }
    });
  }
  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null){
        image = File(pickedFile.path);
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

  Future<String> uploadImage(File? imageFile)async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String randomChars = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
      var storageRef = FirebaseStorage.instance.ref().child('paymethod_images/$fileName$randomChars'); 
      var uploadTask = storageRef.putFile(imageFile!);
      var snapshot = await uploadTask;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
  }

  Future<void> _showDialog(String title, String content) async{
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 21)),
          content: Text(content, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  payMethodPageRoute, 
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  color: okTextColor
                )
              ),
            ),
          ],
        );
      }
    );
  }

  Future<void> _uploadData()async{
    if(_formkey.currentState!.validate()){
      String? downloadUrl;
      if(image!=null){
        downloadUrl = await uploadImage(image);
      }else{
        downloadUrl = '';
      }
      DateTime now = DateTime.now();
      DocumentReference documentReference = await methodService.addFPXPayment(
        PaymentMethodModel(
          id: '',
          methodName: methodNameController.text,
          desc1: description1Controller.text,
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
          desc2: description2Controller.text,
          specId: 'FPX',
          qrcode: downloadUrl,
          bankAcc: bankAccController.text,
          accNumber: accNumberController.text,
          requiredReceipt: receiptChoice,
        )
      );

      String docId = documentReference.id;

      await methodService.updateFPXPayment(
        PaymentMethodModel(
          id: docId,
          methodName: methodNameController.text,
          desc1: description1Controller.text,
          desc2: description2Controller.text,
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
          specId: 'FPX',
          qrcode: downloadUrl,
          bankAcc: bankAccController.text,
          accNumber: accNumberController.text,
          requiredReceipt: receiptChoice,
        )
      );

      _showDialog('Payment Method Added', '${methodNameController.text} has been saved successfully.');
    }
  }

  void _handleSaveButtonPress() async {
    setState(() {
      isLoading = true;
    });

    await _uploadData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    methodNameController.text = 'Online banking';
    bankAccController.addListener(() {
      if(bankAccController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    accNumberController.addListener(() {
      if(accNumberController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    description1Controller.addListener(() {
      if(description1Controller.text.isNotEmpty){
        anyChanges = true;
      }
    });
    description2Controller.addListener(() {
      if(description2Controller.text.isNotEmpty){
        anyChanges = true;
      }
    });
  }

  @override
  void dispose(){
    description1Controller.dispose();
    description2Controller.dispose();
    bankAccController.dispose();
    accNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Online Banking', 
          onPress: (){
            if(anyChanges){
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text(
                      'Confirm to leave this page?',
                      style: TextStyle(
                        fontSize: 21
                      ),
                    ),
                    content: const Text(
                      'Please save your work before you leave.', 
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                            color: cancelTextColor
                          ),
                        )
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }, 
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                            color: confirmTextColor
                          ),
                        )
                      )
                    ],
                  );
                }
              );
            }else{
              Navigator.of(context).pop();
            }
          }, 
          barColor: ownerColor, 
          userRole: 'owner'
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: height*0.07,
                              width: width*0.3,
                              child: const Text(
                                'Method Name:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                )
                              ),
                            ),
                            
                            SizedBox(
                              width: width*0.55,
                              child: TextFormField(
                                controller: methodNameController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Method name',
                                  labelText: 'Method name'
                                ),
                                validator: (value) {
                                  if(value==null||value.isEmpty){
                                    return 'Please enter name of method';
                                  }else{
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            SizedBox(
                              height: height*0.07,
                              width: width*0.3,
                              child: const Text(
                                'Bank Account:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                )
                              ),
                            ),
              
                            SizedBox(
                              width: width*0.55,
                              child: TextFormField(
                                controller: bankAccController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Bank Account',
                                  labelText: 'Bank Account'
                                ),
                                validator: (value){
                                  if(value==null||value.isEmpty){
                                    return 'Please enter a bank account';
                                  }else{
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                              height: height*0.07,
                              width: width*0.3,
                              child: const Text(
                                'Account No. :',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                )
                              ),
                            ),
              
                            SizedBox(
                              width: width*0.55,
                              child: TextFormField(
                                controller: accNumberController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Account number',
                                  labelText: 'Account number'
                                ),
                                validator: (value){
                                  if(value==null||value.isEmpty){
                                    return 'Please enter account number';
                                  }else{
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.07,
                        width: width*0.3,
                        child: const Text(
                          'QR Code:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
        
                      SizedBox(
                        height: 210,
                        width: width*0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: width*0.55,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 99, 99, 99)
                                )
                              ),
                              child: image == null 
                              ? const Icon(Icons.image_outlined, size: 30)
                              : Image.file(
                                  image!,
                                  fit: BoxFit.fill,
                                ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      elevation: 5,
                                      shadowColor: shadowClr,
                                    ),
                                    onPressed: (){   
                                      showOptions();
                                    }, 
                                    icon: image == null 
                                    ? const Icon(Icons.upload_outlined, color: Colors.black,)
                                    : const Icon(Icons.edit_outlined, color: Colors.black,)
                                    , 
                                    label: image == null 
                                    ? const Text('Upload', style: TextStyle(color: Colors.black))
                                    : const Text('Edit', style: TextStyle(color: Colors.black)),
                                  )
                                ),
                                const SizedBox(width: 5),
                                image != null
                                ? Visibility(
                                    visible: true, 
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : Container(),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.07,
                        width: width*0.3,
                        child: const Text(
                          'Any description:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: description1Controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add your description',
                            labelText: 'Description'
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.07,
                        width: width*0.3,
                        child: const Text(
                          'Require receipt?',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
        
                      Container(
                        height: height*0.18,
                        width: width*0.55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Yes'),         
                              leading: Radio(
                                value: Options.yes, 
                                groupValue: groupVal, 
                                onChanged: (Options? value){
                                  setState(() {
                                    groupVal = value!;
                                    btnYes = true;
                                    receiptChoice = 'Yes';
                                  });
                                }
                              ),
                            ),

                            const Divider(
                              thickness: 1,
                            ),

                            ListTile(
                              title: const Text('No'),
                              leading: Radio(
                                value: Options.no, 
                                groupValue: groupVal, 
                                onChanged: (Options? value){
                                  setState(() {
                                    groupVal = value!;
                                    btnYes = false;
                                    receiptChoice = 'No';
                                  });
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  btnYes 
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width*0.3,
                        child: const Text(
                          'Description for payment proof:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: description2Controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add your description',
                            labelText: 'Description'
                          ),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(height: 59),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        elevation: 10,
                        shadowColor: shadowClr,
                      ),
                      onPressed: isLoading ? null : _handleSaveButtonPress,
                      child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                    ),
                  ),
                ],  
              ),
            ),
          ),
        ),
      )
    );
  }
}