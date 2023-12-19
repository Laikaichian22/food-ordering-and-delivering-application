import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/cod_replacemeal_method/edit_cod_replace_page.dart';

class ViewReplaceMealOrCODPage extends StatefulWidget {
  const ViewReplaceMealOrCODPage({
    required this.paymethodSelected,
    super.key
  });

  final PaymentMethodModel paymethodSelected;

  @override
  State<ViewReplaceMealOrCODPage> createState() => _ViewReplaceMealOrCODPageState();
}

class _ViewReplaceMealOrCODPageState extends State<ViewReplaceMealOrCODPage> {

  PayMethodDatabaseService methodService = PayMethodDatabaseService();

  @override
  Widget build(BuildContext context) {
    var choice='';
    widget.paymethodSelected.methodName == 'Cash on delivery' 
    ? choice = 'COD'
    : choice = 'Replace meal';

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarNoArrow(
          title: widget.paymethodSelected.methodName, 
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.05,
                        width: width*0.25,
                        child: const Text(
                          "Method name: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: Text(
                            widget.paymethodSelected.methodName,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.05,
                        width: width*0.25,
                        child: const Text(
                          "Description: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: Text(
                            widget.paymethodSelected.desc1 ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 62, 62),
                            elevation: 10,
                            shadowColor: const Color.fromARGB(255, 92, 90, 85),
                          ),
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text(
                                    'You are deleting this payment method',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  content: const Text(
                                    'Confirm to delete this payment method?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      }, 
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      )
                                    ),
                                    TextButton(
                                      onPressed: ()async {
                                        await methodService.deletePayment(widget.paymethodSelected.id!.toString(), context); 
                                      }, 
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      )
                                    ),
                                  ],
                                );
                              }
                            );
                          }, 
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            elevation: 10,
                            shadowColor: const Color.fromARGB(255, 92, 90, 85),
                          ),
                          onPressed: (){
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditReplaceMealOrCODPage(
                                paymethodSelected: widget.paymethodSelected,
                                choice: choice,
                              )
                            );
                            Navigator.push(context, route);
                          }, 
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
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