import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OpenOrderPage extends StatefulWidget {
  const OpenOrderPage({super.key});

  @override
  State<OpenOrderPage> createState() => _OpenOrderPageState();
}

class _OpenOrderPageState extends State<OpenOrderPage> {
  
  @override
  Widget build(BuildContext context) {
    PayMethodDatabaseService methodService = PayMethodDatabaseService();
    MenuDatabaseService menuService = MenuDatabaseService();
    final feedBackDesc = TextEditingController();
    final thankDesc = TextEditingController();


    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Order', 
          onPress: ()async {
            return await showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  content: const Text(
                    'Confirm to leave this page?\nPlease save your work before you leave.', 
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          orderAddPageRoute, 
                          (route) => false,
                        );
                      }, 
                      child: const Text('Confirm')
                    )
                  ],
                );
              }
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
                  const Text(
                    'For order opening, you need to select the options below to complete the order opening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Please select a menu from list below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Payment method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Please choose any of the payment method from list below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        const Text(
                          'Description to be written on feedback label.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: SizedBox(
                            width: width*0.8,
                            child: TextFormField(
                              controller: feedBackDesc,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Write down your description",
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        const Text(
                          'Description to be written whenever an order has been placed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: SizedBox(
                            width: width*0.8,
                            child: TextFormField(
                              controller: feedBackDesc,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Write down your description",
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: (){

                      }, 
                      child: const Text(
                        'Open order', 
                        style: TextStyle(
                          fontSize: 20, 
                          color: Colors.black
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}