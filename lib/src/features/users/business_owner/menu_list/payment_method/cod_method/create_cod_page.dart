import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CODPage extends StatefulWidget {
  const CODPage({
    super.key
  });


  @override
  State<CODPage> createState() => _CODPageState();
}

class _CODPageState extends State<CODPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final description1Controller = TextEditingController();
  PayMethodDatabaseService methodService = PayMethodDatabaseService();
  bool isLoading = false;

  Future<void> _showDialog(String title, String content) async {
    return showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
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
      },
    );
  }

  @override
  void dispose() {
    description1Controller.dispose();
    super.dispose();
  }

  Future<void> _uploadData() async {
    DocumentReference documentReference = await methodService.addPayment(
      PaymentMethodModel(
        id: '',
        methodName: 'Cash on delivery',
        desc1: description1Controller.text,
      ),
    );

    String docId = documentReference.id;

    await methodService.updatePayment(
      PaymentMethodModel(
        id: docId,
        methodName: 'Cash on delivery',
        desc1: description1Controller.text,
      ),
    );

    _showDialog('Payment Method Added', 'Payment method information has been saved successfully.');
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Cash on delivery',
          userRole: 'owner',
          onPress: () async {
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
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          choosePayMethodRoute,
                          (route) => false,
                        );
                      },
                      child: const Text('Confirm'),
                    )
                  ],
                );
              },
            );
          },
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: height * 0.06,
                    width: width * 0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all()),
                    child: const Text(
                      "Cash On Delivery(COD)",
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold
                      ),
                    )
                  ),

                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.3,
                        child: const Text(
                          'Any description:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      SizedBox(
                        width: width * 0.55,
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
