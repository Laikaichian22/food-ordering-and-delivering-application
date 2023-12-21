import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/provider/paymethod_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/replacemeal_method/edit_cod_replace_page.dart';
import 'package:provider/provider.dart';

class ViewReplaceMealPage extends StatefulWidget {
  const ViewReplaceMealPage({
    required this.payMethodSelected,
    super.key
  });

  final PaymentMethodModel payMethodSelected;

  @override
  State<ViewReplaceMealPage> createState() => _ViewReplaceMealPageState();
}

class _ViewReplaceMealPageState extends State<ViewReplaceMealPage> {
  bool isPayMethodOpened = false;
  PayMethodDatabaseService methodService = PayMethodDatabaseService();

  @override
  Widget build(BuildContext context) {
    var choice='Replace meal';
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final paymentMethodListProvider = Provider.of<SelectedPayMethodProvider>(context, listen: false);
    bool isButtonOpen = paymentMethodListProvider.isReplaceMlButtonOpen;

    // Set the button state
    isPayMethodOpened = isButtonOpen;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarNoArrow(
          title: widget.payMethodSelected.methodName!, 
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isPayMethodOpened
                      ? Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          color: orderOpenedColor,
                          child: const Text(
                            'In Open State',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        )
                      : Container(),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPayMethodOpened
                            ? Colors.red
                            : Colors.amber,
                            elevation: 5,
                            shadowColor: const Color.fromARGB(255, 92, 90, 85),
                          ),
                          onPressed: (){
                            if(isPayMethodOpened){
                              paymentMethodListProvider.removeSelectedPaymentMethod(widget.payMethodSelected.id!);
                            }else{
                              paymentMethodListProvider.addSelectedPaymentMethod(widget.payMethodSelected.id!);
                            }

                            paymentMethodListProvider.setReplaceMlButtonState(!isPayMethodOpened);
                            setState(() {
                              isPayMethodOpened = !isPayMethodOpened;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isPayMethodOpened
                                    ? 'Payment method is opened'
                                    : 'Payment method is closed'
                                  ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }, 
                          child: Text(
                            isPayMethodOpened ? 'Close' : 'Open',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
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
                            widget.payMethodSelected.methodName!,
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
                              builder: (context) => EditReplaceMealOrCODPage(
                                payMethodSelected: widget.payMethodSelected,
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