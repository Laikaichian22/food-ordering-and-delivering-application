import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                businessOwnerRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconWhiteColor
            ),
          ),
        ),
        body: Padding(
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
                      fontSize: 15,
                    ),
                  ),
            
                  const SizedBox(height: 30),
            
                  //by pressing at this, lead to new page, 
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.75,
                      height: MediaQuery.of(context).size.height*0.09,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
                        color: Color.fromARGB(255, 230, 230, 230)
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
            
                  Container(
                    width: MediaQuery.of(context).size.width*0.75,
                    height: MediaQuery.of(context).size.height*0.12,
                    padding: EdgeInsets.all(10),
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
                        const Text(
                          'Payment Method 1',   //this number will increase automatically
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        const SizedBox(height: 10),

                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.04,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 1, 94, 171),
                            ),
                            child: const Center(
                              child: Text(
                                "Touch'n Go eWallet",    //this will change depend to the selection
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          onTap: (){

                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
    );
  }
}