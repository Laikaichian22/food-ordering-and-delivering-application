import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/tng_method/edit_tng_page.dart';

class ViewTngPaymentPage extends StatefulWidget {
  const ViewTngPaymentPage({
    required this.payMethodSelected,
    super.key
  });

  final PaymentMethodModel payMethodSelected;

  @override
  State<ViewTngPaymentPage> createState() => _ViewTngPaymentPageState();
}

class _ViewTngPaymentPageState extends State<ViewTngPaymentPage> {

  PayMethodDatabaseService methodService = PayMethodDatabaseService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: '', 
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
                            widget.payMethodSelected.methodName,
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
                          "Tng Link: ",
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
                            widget.payMethodSelected.paymentLink ?? '',
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
                          "Qr code: ",
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
                          child: widget.payMethodSelected.qrcode == null 
                          ? const Icon(Icons.image_outlined, size: 30)
                          : Image(image: NetworkImage(widget.payMethodSelected.qrcode!)),
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
                            widget.payMethodSelected.desc1 ?? '',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.06,
                        width: width*0.25,
                        child: const Text(
                          "Require receipt?: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: Text(
                            widget.payMethodSelected.requiredReceipt ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  widget.payMethodSelected.requiredReceipt == 'Yes'
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height*0.1,
                          width: width*0.25,
                          child: const Text(
                            "Description for payment proof: ",
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
                              widget.payMethodSelected.desc2 ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),

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
                                        await methodService.deletePayment(widget.payMethodSelected.id!.toString(), context); 
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
                              builder: (context) => EditTngPaymentPage(
                                payMethodSelected: widget.payMethodSelected
                              )
                            );
                            Navigator.pushReplacement(context, route);
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