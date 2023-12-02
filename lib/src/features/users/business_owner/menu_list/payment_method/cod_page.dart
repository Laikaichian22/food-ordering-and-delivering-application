import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CashOnDeliveryPage extends StatefulWidget {
  const CashOnDeliveryPage({super.key});

  @override
  State<CashOnDeliveryPage> createState() => _CashOnDeliveryPageState();
}

class _CashOnDeliveryPageState extends State<CashOnDeliveryPage> {
  final description1Controller = TextEditingController();


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
                    'Payment Method xx',  //remove const, numbering should increase
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
                      "Cash On Delivery(COD)",
                      style: TextStyle(fontSize: 18),
                    ),   
                  ),
        
                  const SizedBox(height: 40),

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