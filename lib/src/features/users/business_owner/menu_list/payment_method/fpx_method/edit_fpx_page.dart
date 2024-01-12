import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/fpx_method/view_fpx_methodpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:image_picker/image_picker.dart';

class EditFPXPaymentPage extends StatefulWidget {
  const EditFPXPaymentPage({
    required this.payMethodSelected,
    super.key
  });

  final PaymentMethodModel payMethodSelected;

  @override
  State<EditFPXPaymentPage> createState() => _EditFPXPaymentPageState();
}

enum Options{yes, no}

class _EditFPXPaymentPageState extends State<EditFPXPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bankAccController = TextEditingController();
  final accNumberController = TextEditingController();
  final description1Controller = TextEditingController();
  final description2Controller = TextEditingController();
  PayMethodDatabaseService methodService = PayMethodDatabaseService();
  Options groupVal = Options.no;
  
  bool btnYes = false;
  String? receiptChoice;
  bool isLoading = false;
  bool anyChanges = false;
  final picker = ImagePicker();
  File? image;        //to get the FILE of the image
  String? imageUrl;   //to get the url of the stored image
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
       image = File(pickedFile.path);
       imageUrl = null;
      }
    });
  }
  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null){
        image = File(pickedFile.path);
        imageUrl = null;
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

  Future<void> _showDialog(String title, String content) async{
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
                  fontSize: 20
                )
              ),
            ),
          ],
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
  Future<void> _uploadData() async{

    String downloadUrl = 
    imageUrl == null 
    ? await uploadImage(image)
    : imageUrl!;

    await methodService.updateExistingFPXPayment(
      widget.payMethodSelected.id!,
      bankAccController.text,
      accNumberController.text,
      downloadUrl,
      description1Controller.text,
      description2Controller.text,
      receiptChoice!
    );

    _showDialog('Payment Method Updated', 'This payment method has been updated successfully');
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
    bankAccController.text = widget.payMethodSelected.bankAcc!;
    accNumberController.text = widget.payMethodSelected.accNumber!;
    description1Controller.text = widget.payMethodSelected.desc1!;
    description2Controller.text = widget.payMethodSelected.desc2!;
    imageUrl = widget.payMethodSelected.qrcode;
    receiptChoice = widget.payMethodSelected.requiredReceipt;
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
    widget.payMethodSelected.requiredReceipt == 'Yes' 
    ? setState(() {
        groupVal = Options.yes;
        btnYes = true;
      })
    : setState(() {
        groupVal = Options.no;
        btnYes = false;
      });
  }

  @override
  void dispose(){
    bankAccController.dispose();
    accNumberController.dispose();
    description1Controller.dispose();
    description2Controller.dispose();
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
          title: widget.payMethodSelected.methodName!, 
          userRole: 'owner',
          onPress: ()async{
            if(anyChanges == true){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      'Confirm to leave this page?\n\nPlease save your work before you leave',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => ViewFPXPaymentPage(
                              payMethodSelected: widget.payMethodSelected
                            )
                          );
                          Navigator.pushReplacement(context, route);
                        },
                        child: const Text('Confirm'),
                      )
                    ],
                  );
                },
              );
            }else{
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => ViewFPXPaymentPage(
                  payMethodSelected: widget.payMethodSelected
                )
              );
              Navigator.pushReplacement(context, route);
            }
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: height*0.06,
                    width: width*0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(  
                      widget.payMethodSelected.methodName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),   
                  ),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      SizedBox(
                        height: height*0.07,
                        width: width*0.3,
                        child: const Text(
                          'Bank Account:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
                      const SizedBox(width: 10),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: bankAccController,
                          style: const TextStyle(
                            color: editableTextColor
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Bank Account',
                          ),
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
                      const SizedBox(width: 10),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: accNumberController,
                          style: const TextStyle(
                            color: editableTextColor
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Account number',
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
                          'QR Code:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
                      const SizedBox(width: 10),
        
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
                              child: (image != null)
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.fill,
                                )
                              : (imageUrl != null)
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.fill,
                                  )
                                : const Icon(Icons.image_outlined, size: 30),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton.icon(
                                    onPressed: (){   
                                      showOptions();
                                    }, 
                                    icon: (imageUrl == null && image == null) 
                                    ? const Icon(Icons.upload_outlined)
                                    : const Icon(Icons.edit_outlined)
                                    , 
                                    label: (imageUrl == null && image == null)
                                    ? const Text('Upload') 
                                    : const Text('Edit'),    //change name to edit if file exist
                                  )
                                ),
                                const SizedBox(width: 4),
                                (image != null || imageUrl != null)
                                ? Visibility(
                                    visible: true, 
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          image = null;
                                          imageUrl = null;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : Container(),
                                const SizedBox(width: 2),
                                (imageUrl == null && image==null)
                                ? Visibility(
                                    visible: true, 
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          imageUrl = widget.payMethodSelected.qrcode;
                                          image = null;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.restore_page_outlined,
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
                      const SizedBox(width: 10),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: description1Controller,
                          maxLines: null,
                          style: const TextStyle(
                            color: editableTextColor
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add your description',
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
                      ),
        
                      const SizedBox(width: 10),
        
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
                                    description2Controller.text = '';
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                          )
                        ),
                      ),
        
                      const SizedBox(width: 10),
        
                      SizedBox(
                        width: width*0.55,
                        child: TextField(
                          controller: description2Controller,
                          maxLines: null,
                          style: const TextStyle(
                            color: editableTextColor
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add your description',
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
                  )
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}