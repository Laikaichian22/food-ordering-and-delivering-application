import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/cod_method/view_cod_page.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/replacemeal_method/view_replaceml.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/fpx_method/view_fpx_methodpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/tng_method/view_tng_methodpage.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final PayMethodDatabaseService payMethodService = PayMethodDatabaseService();

  Widget buildPaymentMethodTile(PaymentMethodModel paymentMethod, double width, double height, int index){
    Color diffColors = Colors.black;
    if(paymentMethod.methodName == "Touch n Go"){
      diffColors = const Color.fromARGB(255, 1, 94, 171);
    }
    if(paymentMethod.methodName == "Online banking"){
      diffColors = const Color.fromARGB(255, 2, 136, 11);
    }
    if(paymentMethod.methodName == "Replace meal"){
      diffColors = const Color.fromARGB(255, 98, 2, 146);
    }
    if(paymentMethod.methodName == "Cash on delivery"){
      diffColors = const Color.fromARGB(255, 187, 113, 30);
    }
    return InkWell(
      onTap: (){
        if(paymentMethod.methodName == "Touch n Go"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewTngPaymentPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }
        if(paymentMethod.methodName == "Online banking"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewFPXPaymentPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }
        if(paymentMethod.methodName == "Replace meal" ){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewReplaceMealPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }if(paymentMethod.methodName == "Cash on delivery"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewCODPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }
      },
      child: Container(
        width: width*0.75,
        height: height*0.12,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 117, 117, 117),
              offset: Offset(0, 6)
            )
          ]
        ),
        child: Column(
          children: [
            Text(
              'Payment Method $index',   
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
    
            const SizedBox(height: 10),
    
            Container(
              width: width*0.5,
              height: height*0.04,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: diffColors,
              ),
              child: Center(
                child: Text(
                  paymentMethod.methodName!,    
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: '', 
          onPress: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
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
                  const Text(
                    'Payment Method', 
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  const Text(
                    'You are required to add the choices of payment method for customers to make payment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
            
                  const SizedBox(height: 30),
            
                  InkWell(
                    child: Container(
                      width: width*0.75,
                      height: height*0.09,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
                        color: const Color.fromARGB(255, 230, 230, 230)
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_outlined, size: 40,),
                          Text(
                            'Add payment method',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        choosePayMethodRoute, 
                        (route) => false,
                      );
                    },
                  ),
            
                  const SizedBox(height: 30),
            
                  StreamBuilder<List<PaymentMethodModel>>(
                    stream: payMethodService.getPaymentMethods(), 
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      List<PaymentMethodModel>? paymentMethods = snapshot.data;
                      if(paymentMethods == null || paymentMethods.isEmpty){
                        return Container(
                          width: width*0.75,
                          height: height*0.09,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 255, 196, 108)),
                            color: const Color.fromARGB(255, 255, 196, 108)
                          ),
                          child: const Center(
                            child: Text(
                              'No payment methods available',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: paymentMethods.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          PaymentMethodModel paymentMethod = entry.value;
                          return Column(
                            children: [
                              buildPaymentMethodTile(paymentMethod, width, height, index),
                              const SizedBox(height: 30),
                            ],
                          );
                        }).toList(),
                      );
                    }
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


