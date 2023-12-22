import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/provider/paymethod_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:provider/provider.dart';

class SelectOrderPayMethodPage extends StatefulWidget {
  const SelectOrderPayMethodPage({
    required this.custName,
    required this.email,
    required this.phone,
    required this.location,
    required this.remark,
    required this.selectedDishIds,
    required this.onBackPressed,
    super.key
  });

  final String custName;
  final String email;
  final String phone;
  final String location;
  final String remark;
  final List<String> selectedDishIds;
  final Function(Map<String, dynamic> data) onBackPressed;

  @override
  State<SelectOrderPayMethodPage> createState() => _SelectOrderPayMethodPageState();
}


class _SelectOrderPayMethodPageState extends State<SelectOrderPayMethodPage> {
  List<PayMethodSelection> payMethodSelectionList = [];
  String? _selectedPaymentMethodId;
  final feedBackController = TextEditingController();
  String? imageUrl;


  @override
  void initState() {
    super.initState();
    payMethodSelectionList = Provider.of<SelectedPayMethodProvider>(context, listen: false)
    .selectedPaymentMethodsId
    .map((paymentMethodId) => PayMethodSelection(id: paymentMethodId, isSelected: false))
    .toList();
  }


  @override
  Widget build(BuildContext context) {
    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;
    Widget buildCODOrReplaceTile(PaymentMethodModel details){
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 237, 237, 237)
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all()
              ),
              child: Text(
                '${details.methodName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: Text(
                    '${details.desc1}',
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                ), 
              ],
            ),
          ],
        ),
      ); 
    }

    Widget buildErrorTile(String text){
      return Container(
        width: 300,
        height: 60,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20
            ),
          )
        ),  
      );
    }

    Widget buildPayMethodRadioBtn(PayMethodSelection selection) {
      return FutureBuilder<PaymentMethodModel?>(
        future: PayMethodDatabaseService().getPayMethodDetails(selection.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return buildErrorTile('Error fetching payment method details');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return buildErrorTile('Payment method not found');
          } else {
            PaymentMethodModel payMethodDetails = snapshot.data!;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListTile(
                    title: Text(
                      payMethodDetails.methodName ?? 'No method name',
                      style: const TextStyle(fontSize: 18),
                    ),
                    leading: Radio(
                      value: selection.id,
                      groupValue: _selectedPaymentMethodId,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethodId = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ); 
          }
        },
      );
    }
    
    Widget buildPayMethodSelection(){
      if (payMethodSelectionList.isEmpty) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all()
          ),
          child: const Center(
            child: Text(
              'No payment methods available.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: payMethodSelectionList
          .map((payMethodSelection) => buildPayMethodRadioBtn(payMethodSelection))
          .toList(),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Place Order', 
          onPress:(){
            widget.onBackPressed({
              'custName': widget.custName,
              'email': widget.email,
              'phone': widget.phone,
              'location': widget.location,
              'remark': widget.remark,
              'selectedDishId': widget.selectedDishIds
            });
            Navigator.pop(context, {
              'custName': widget.custName,
              'email': widget.email,
              'phone': widget.phone,
              'location': widget.location,
              'remark': widget.remark,
              'selectedDishId': widget.selectedDishIds
            });
          }, 
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
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
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 25
                        ),
                      ),
                      const Text(
                        'Please select one of the payment method from list below',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildPayMethodSelection(),
                    ],
                  )
                ),
                const SizedBox(height: 30),     
                  _selectedPaymentMethodId == null
                  ? Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: const Center(
                        child: Text(
                          "You haven't select any payment method yet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    )
                  : FutureBuilder<PaymentMethodModel?>(
                      future: PayMethodDatabaseService().getPayMethodDetails(_selectedPaymentMethodId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return buildErrorTile('Error fetching payment method details');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return buildErrorTile('Payment method details not found');
                        } else {
                          PaymentMethodModel payMethodDetails = snapshot.data!;
                          return Column(
                            children: [
                              if(payMethodDetails.methodName == 'Touch n Go')
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 237, 237, 237)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()
                                        ),
                                        child: Text(
                                          '${payMethodDetails.methodName}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Text(
                                              '${payMethodDetails.desc1}',
                                              style: const TextStyle(
                                                fontSize: 18
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: 400,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Payment link for TnG',
                                                  style: TextStyle(
                                                    fontSize: 20
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${payMethodDetails.paymentLink}',
                                                  style: const TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 300,
                                            width: 300,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'QR Code for TnG',
                                                  style: TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                payMethodDetails.qrcode!.isNotEmpty
                                                ? Image.network(
                                                    payMethodDetails.qrcode!,
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                      )
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.image, 
                                                        size: 50, 
                                                        color: Colors.grey
                                                      ),
                                                    ),
                                                  ),  
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Proof of Payment',
                                                  style: TextStyle(
                                                    fontSize: 20
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${payMethodDetails.desc2}',
                                                  style: const TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: ElevatedButton.icon(
                                                    onPressed: (){
                                
                                                    }, 
                                                    icon: const Icon(Icons.upload_file_outlined), 
                                                    label: const Text('Add file'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ), 
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              else if(payMethodDetails.methodName == 'Online banking')
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 237, 237, 237)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()
                                        ),
                                        child: Text(
                                          '${payMethodDetails.methodName}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Text(
                                              '${payMethodDetails.desc1}',
                                              style: const TextStyle(
                                                fontSize: 18
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: 400,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Online Bank Transfer Details',
                                                  style: TextStyle(
                                                    fontSize: 20
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${payMethodDetails.bankAcc}',
                                                  style: const TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${payMethodDetails.accNumber}',
                                                  style: const TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 300,
                                            width: 300,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'QR Code for DuitNow',
                                                  style: TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                payMethodDetails.qrcode!.isNotEmpty
                                                ? Image.network(
                                                    payMethodDetails.qrcode!,
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                      )
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.image, 
                                                        size: 50, 
                                                        color: Colors.grey
                                                      ),
                                                    ),
                                                  ),  
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all()
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Proof of Payment',
                                                  style: TextStyle(
                                                    fontSize: 20
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${payMethodDetails.desc2}',
                                                  style: const TextStyle(
                                                    fontSize: 18
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: ElevatedButton.icon(
                                                    onPressed: (){
                                
                                                    }, 
                                                    icon: const Icon(Icons.upload_file_outlined), 
                                                    label: const Text('Add file'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ), 
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              else if(payMethodDetails.methodName == 'Cash on delivery')
                                buildCODOrReplaceTile(payMethodDetails)
                              else if(payMethodDetails.methodName == 'Replace meal')
                                buildCODOrReplaceTile(payMethodDetails)
                            ],
                          );
                        }
                      },
                    ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '${currentOrder!.feedBack}',
                        style: const TextStyle(
                          fontSize: 15
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: feedBackController,
                        decoration: const InputDecoration(
                          hintText: 'Feedback',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ],
                  ),
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
                      
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class PayMethodSelection{
  final String id;
  bool isSelected;

  PayMethodSelection({
    required this.id,
    required this.isSelected,
  });
}
