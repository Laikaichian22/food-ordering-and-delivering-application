import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class CustPlaceOrderPage extends StatefulWidget {
  const CustPlaceOrderPage({super.key});

  @override
  State<CustPlaceOrderPage> createState() => _CustPlaceOrderPageState();
}

class _CustPlaceOrderPageState extends State<CustPlaceOrderPage> {

  final custNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose(){
    super.dispose();
    custNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;
    
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Place Order', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              menuPageRoute,
              (route) => false,
            );
          }, 
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Personal Details: ',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5
                      )
                    ),
                    child: Form(
                      key: _formkey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Address: ',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: custNameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Email Address',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter an email address';
                                }else{
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Phone Number: ',
                                  ),
                                  TextSpan(
                                    text: '[e.g: 0123456789]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),

                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: custNameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a phone number';
                                }else{
                                  return null;
                                }
                              },
                            ),
                           
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Pickup your Order at? ',
                                  ),
                                  TextSpan(
                                    text: '[e.g: MA1/FABU]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: custNameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Location',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a valid location';
                                }else{
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Name: ',
                                  ),
                                  TextSpan(
                                    text: '[In short form, e.g:Lee/Alice/Jack]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: custNameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a name';
                                }else{
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 240, 145, 3), 
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            elevation: 10,
                            shadowColor: const Color.fromARGB(255, 92, 90, 85),
                          ),
                          onPressed: (){
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //   menuPageRoute,
                            //   (route) => false,
                            // );
                          },
                          child: const Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'Order Details: ',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, 
                        width: 0.5
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Order 1 [1st pack]',
                          style: TextStyle(
                            fontSize: 25
                          ),
                        ),
                        const Text(
                          '[If any of the selection cannot be seen in the list, it means that the dishes is SOLD OUT,\nPlease select other dishes]',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black
                          ),
                        ),
                        
                        
                        
                      ],
                    )
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 240, 145, 3), 
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: () async {
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   menuPageRoute,
                        //   (route) => false,
                        // );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}