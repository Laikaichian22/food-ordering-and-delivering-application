import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CODPage extends StatefulWidget {
  const CODPage({
    super.key
  });


  @override
  State<CODPage> createState() => _CODPageState();
}

class _CODPageState extends State<CODPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController description1Controller = TextEditingController();
  final TextEditingController methodNameController = TextEditingController();
  PayMethodDatabaseService methodService = PayMethodDatabaseService();
  bool isLoading = false;
  bool anyChanges = false;
  final _formkey = GlobalKey<FormState>();

  Future<void> _showDialog(String title, String content) async {
    return showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
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
      },
    );
  }

  @override
  void dispose() {
    description1Controller.dispose();
    methodNameController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    methodNameController.text = 'Cash on delivery';
    description1Controller.addListener(() {
      if(description1Controller.text.isNotEmpty){
        anyChanges = true;
      }
    });
  }

  Future<void> _uploadData() async {
    if(_formkey.currentState!.validate()){
      DateTime now = DateTime.now();
      DocumentReference documentReference = await methodService.addPayment(
        PaymentMethodModel(
          id: '',
          methodName: methodNameController.text,
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
          specId: 'COD',
          desc1: description1Controller.text,
        ),
      );

      String docId = documentReference.id;

      await methodService.updatePayment(
        PaymentMethodModel(
          id: docId,
          methodName: methodNameController.text,
          specId: 'COD',
          desc1: description1Controller.text,
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
        ),
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
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Cash on delivery',
          userRole: 'owner',
          onPress: (){
            if(anyChanges){
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            choosePayMethodRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                            color: confirmTextColor
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            }else{
              Navigator.of(context).pushNamedAndRemoveUntil(
                choosePayMethodRoute,
                (route) => false,
              );
            }
          },
          barColor: ownerColor,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.3,
                              child: const Text(
                                'Method Name:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            SizedBox(
                              width: width * 0.55,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: methodNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Method name',
                                ),
                                validator: (value){
                                  if(value==null||value.isEmpty){
                                    return 'Please enter name of method';
                                  }else{
                                    return null;
                                  }
                                }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.3,
                              child: const Text(
                                'Any description:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            SizedBox(
                              width: width * 0.55,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: description1Controller,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Add your description',
                                ),
                                validator: (value){
                                  if(value==null||value.isEmpty){
                                    return 'Description can not be empty';
                                  }else{
                                    return null;
                                  }
                                }
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
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
      ),
    );
  }
}
