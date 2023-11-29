import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class TouchNGoPage extends StatefulWidget {
  const TouchNGoPage({super.key});

  @override
  State<TouchNGoPage> createState() => _TouchNGoPageState();
}

enum Options{yes, no}

class _TouchNGoPageState extends State<TouchNGoPage> {
  final linkController = TextEditingController();
  final description1Controller = TextEditingController();
  final description2Controller = TextEditingController();

  Options groupVal = Options.no;


  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                choosePayMethodRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconWhiteColor
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Payment Method 1',  //remove const, numbering should increase
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  Container(
                    height: height*0.06,
                    width: width*0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all()),
                    child: const Text(  //method will change based on the selection
                      "Touch' n Go eWallet",
                      style: TextStyle(fontSize: 18),
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
                  //this will get the qr code image in file type
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
                        height: 150,
                        width: width*0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('here is the file name'),   //only show the name of the uploaded file, 
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: (){   
                                  
                                }, 
                                icon: const Icon(Icons.upload_outlined), 
                                label: const Text('Add file'),    //change name to edit if file exist
                              )
                            ),
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
                              title: const Text('Yes'),          //if yes, then will appear another desc tile
                              leading: Radio(
                                value: Options.yes, 
                                groupValue: groupVal, 
                                onChanged: (Options? value){
                                  setState(() {
                                    groupVal = value!;
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
                                  });
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //here add description 2

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
                      onPressed: (){

                      }, 
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),),
                    ),
                  )
                ],  
              ),
            ),
          ),
        ),
      ),
    );
  }
}