import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/tng_method/view_tng_methodpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:image_picker/image_picker.dart';

class EditTngPaymentPage extends StatefulWidget {
  const EditTngPaymentPage({
    required this.payMethodSelected,
    super.key
  });

  final PaymentMethodModel payMethodSelected;

  @override
  State<EditTngPaymentPage> createState() => _EditTngPaymentPageState();
}

enum Options{yes, no}

class _EditTngPaymentPageState extends State<EditTngPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final description1Controller = TextEditingController();
  final description2Controller = TextEditingController();
  final linkController = TextEditingController();
  PayMethodDatabaseService methodService = PayMethodDatabaseService();
  Options groupVal = Options.no;
  
  bool btnYes = false;
  String? receiptChoice;
  bool isLoading = false;

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

    await methodService.updateExistingTngPayment(
      widget.payMethodSelected.id!,
      linkController.text,
      downloadUrl,
      description1Controller.text,
      description2Controller.text,
      receiptChoice!
    );

    _showDialog('Payment Method Updated', '${widget.payMethodSelected.methodName} payment method has been updated successfully');
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
    linkController.text = widget.payMethodSelected.paymentLink!;
    description1Controller.text = widget.payMethodSelected.desc1!;
    description2Controller.text = widget.payMethodSelected.desc2!;
    imageUrl = widget.payMethodSelected.qrcode;
    receiptChoice = widget.payMethodSelected.requiredReceipt;
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
    linkController.dispose();
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
          onPress: ()async{
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text(
                    'Confirm to leave this page?\nPlease save your work before you leave',
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
                          builder: (context) => ViewTngPaymentPage(
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
                          'Payment Link:',
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
                          controller: linkController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'TnG Link',
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
                        height: 200,
                        width: width*0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 130,
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
                                  width: 170,
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
                        height: height*0.17,
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
                        height: height*0.07,
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