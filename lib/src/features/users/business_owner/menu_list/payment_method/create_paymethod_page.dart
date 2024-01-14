import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/cod_method/view_cod_page.dart';
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
  LinearGradient getGradient(String specialId) {
    if (specialId == "TNG") {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 0, 85, 254), Color.fromARGB(255, 0, 208, 255)],
      );
    } else if (specialId == "FPX"){
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 254, 93, 0), Color.fromARGB(255, 255, 183, 0)],
      );
    }else{
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 165, 0, 254), Color.fromARGB(255, 217, 0, 255)],
      );
    }
  }
  Widget buildPaymentMethodTile(PaymentMethodModel paymentMethod, double width, double height){
    return InkWell(
      onTap: (){
        if(paymentMethod.specId == "TNG"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewTngPaymentPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }else if(paymentMethod.specId == "FPX"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewFPXPaymentPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }else if(paymentMethod.specId == "COD"){
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ViewCODPage(payMethodSelected: paymentMethod)
          );
          Navigator.push(context, route);
        }
      },
      child: Container(
        width: width*0.75,
        height: height*0.17,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
          gradient: getGradient(paymentMethod.specId!),
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 255, 248, 148),
              ),
              child: Text(
                '${paymentMethod.methodName}', 
                style:const TextStyle(fontSize: 19)
              )
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Created time: ${paymentMethod.createdDate}', 
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16
                ),
              )
            ),
            const SizedBox(height: 5),
            paymentMethod.openedStatus == 'Yes'
            ? Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text(
                      'Status: ', 
                      style: TextStyle(color: Colors.black),
                    ),
                    Container(
                      width: width*0.5,
                      padding: const EdgeInsets.all(4),
                      color: const Color.fromARGB(255, 69, 255, 7),
                      child: const Center(
                        child: Text(
                          'Open', 
                          style: TextStyle(
                            color:Colors.black,
                            fontSize: 17
                          ),
                        )
                      ),
                    )
                  ],
                )
              )
            : Container()
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
          title: 'Payment Method', 
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
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }else if(snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                        return Container(
                          width: width*0.75,
                          height: height*0.09,
                          padding: const EdgeInsets.all(5),
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
                      List<PaymentMethodModel> paymentMethods = snapshot.data!;
                      paymentMethods.sort((a, b) {
                        return a.openedStatus!.compareTo(b.openedStatus!);
                      });
                      return Column(
                        children: paymentMethods.asMap().entries.map((entry) {
                          PaymentMethodModel paymentMethod = entry.value;
                          return Column(
                            children: [
                              buildPaymentMethodTile(paymentMethod, width, height),
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


