import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:image_picker/image_picker.dart';

class CustSelectPayMethodPage extends StatefulWidget {
  const CustSelectPayMethodPage({
    required this.custName,
    required this.email,
    required this.phone,
    required this.location,
    required this.remark,
    required this.menuName,
    required this.menuDate,
    required this.selectedDishIds,
    required this.onBackPressed,
    required this.orderOpenedId,
    required this.payAmount,
    super.key
  });

  final String custName;
  final String email;
  final String phone;
  final String location;
  final String remark;
  final String menuName;
  final double payAmount;
  final String menuDate;
  final String orderOpenedId;
  final List<String> selectedDishIds;
  final Function(Map<String, dynamic> data) onBackPressed;

  @override
  State<CustSelectPayMethodPage> createState() => _CustSelectPayMethodPageState();
}


class _CustSelectPayMethodPageState extends State<CustSelectPayMethodPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  final feedBackController = TextEditingController();
  File? image;
  String? selectedImageFileName;
  String? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;
  String? imageUrl;
  bool isLoading = false;

  List<PayMethodSelection> payMethodSelectionList = [];
  Map<String, PaymentMethodModel?> payMethodDetailsMap = {};
  final OrderCustDatabaseService orderService = OrderCustDatabaseService();
  final PayMethodDatabaseService payMethodService = PayMethodDatabaseService();

  Future<void> fetchPayMethodDetails(String paymentMethodId) async {
    try {
      PaymentMethodModel? payMethodDetails = await PayMethodDatabaseService().getPayMethodDetails(paymentMethodId);
      setState(() {
        payMethodDetailsMap[paymentMethodId] = payMethodDetails;
      });
    } catch (e) {
      debugPrint("Error fetching payment method details: $e");
    }
  }
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
       image = File(pickedFile.path);
       selectedImageFileName = pickedFile.name;
      }
    });
  }
  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null){
        image = File(pickedFile.path);
        selectedImageFileName = pickedFile.name;
      }
    });
  }
  Future<String> uploadImage(File? imageFile)async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String randomChars = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
      var storageRef = FirebaseStorage.instance.ref().child('receipt/$fileName$randomChars'); 
      var uploadTask = storageRef.putFile(imageFile!);
      var snapshot = await uploadTask;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
  }
  Future showOptions() async {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please select your option:'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  onTap: (){
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_outlined,size: 30),
                  title: const Text('Camera', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: (){
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image_outlined, size: 30),
                  title: const Text('Gallery', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
        );
      }
    );
  }
  Future<void> _showDialog(String title, String content) async{
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  customerRoute, 
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20
                )
              ),
            ),
          ],
        );
      }
    );
  }
  
  Future<void> _uploadData() async{
    DateTime currentDateTime = DateTime.now();
    String formattedSeconds = currentDateTime.second.toString().padLeft(2, '0');
    DateTime formattedDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      currentDateTime.hour,
      currentDateTime.minute,
      int.parse(formattedSeconds), 
      currentDateTime.millisecond,
      currentDateTime.microsecond,
    );
    String menuOrder = '${widget.menuName}, ${widget.menuDate}';
  
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    String paymentStatus = _selectedPaymentMethodName == 'Replace meal' || _selectedPaymentMethodName == 'Cash on delivery'
    ? 'No'
    : 'Yes';
    String downloadUrl = _selectedPaymentMethodName == 'Replace meal' || _selectedPaymentMethodName == 'Cash on delivery'
    ? ''
    : await uploadImage(image);
    DocumentReference documentReference = await orderService.addOrder(
      OrderCustModel(
        id : '',
        userid: userID,
        dateTime: formattedDateTime,
        custName: widget.custName,
        destination: widget.location,
        remark: widget.remark,
        phone: widget.phone,
        email: widget.email,
        payAmount: widget.payAmount,
        payMethod: _selectedPaymentMethodName,
        feedback: feedBackController.text,
        receipt: downloadUrl,
        menuOrderName: menuOrder,
        menuOrderID: widget.orderOpenedId,
        delivered: 'No',
        isCollected: 'No',
        paid: paymentStatus,
        orderDetails: widget.selectedDishIds.join(', ')
      )
    );
    String docId = documentReference.id;
    await orderService.updateOrder(
      OrderCustModel(
        id : docId,
        userid: userID,
        dateTime: formattedDateTime,
        custName: widget.custName,
        destination: widget.location,
        remark: widget.remark,
        phone: widget.phone,
        email: widget.email,
        payAmount: widget.payAmount,
        payMethod: _selectedPaymentMethodName,
        feedback: feedBackController.text,
        receipt: downloadUrl,
        menuOrderName: menuOrder,
        menuOrderID: widget.orderOpenedId,
        delivered: 'No',
        isCollected: 'No',
        paid: paymentStatus,
        orderDetails: widget.selectedDishIds.join(', ')
      )
    );
    _showDialog('Order placed', 'Your order has been placed successfully.');
  }

  void _handleSaveButtonPress() async {
    setState(() {
      isLoading = true;
    });
    if(_selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method.'),
        ),
      );
    }else if((image == null) && (_selectedPaymentMethodName == 'Touch n Go' || _selectedPaymentMethodName == 'Online banking')){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your receipt'),
        ),
      );
    }else{
      await _uploadData(); 
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchOpenedPayMethods()async{
    try{
      List<PaymentMethodModel> openPaymentMethods = await payMethodService.getOpenPayMethods();
      for (var paymentMethod in openPaymentMethods) {
        await fetchPayMethodDetails(paymentMethod.id!); 
      }
      setState(() {
        payMethodSelectionList = openPaymentMethods
        .map((paymentMethod) => PayMethodSelection(id: paymentMethod.id!, isSelected: false))
        .toList();
      });
    }catch(e){
      debugPrint('Error');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchOpenedPayMethods();
  }

  @override
  Widget build(BuildContext context) {

    Widget buildTNGOrFPXTile(PaymentMethodModel details){
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
                const SizedBox(height: 10),
                Container(
                  width: 400,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: details.methodName == 'Touch n Go'
                  ? Column(
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
                          '${details.paymentLink}',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    )
                  : Column(
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
                          '${details.bankAcc}',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${details.accNumber}',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 320,
                  width: 320,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      details.methodName == 'Touch n Go'
                      ? const Text(
                          'QR Code for TnG',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        )
                      : const Text(
                          'QR Code for DuitNow',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      const SizedBox(height: 10),
                      details.qrcode!.isNotEmpty
                      ? Image.network(
                          details.qrcode!,
                          width: 200,
                          height: 250,
                          fit: BoxFit.fill,
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
                details.requiredReceipt == 'Yes'
                ? Container(
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
                          '${details.desc2}',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 250,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 99, 99, 99)
                              )
                            ),
                            child: image == null 
                            ? const Icon(Icons.image_outlined, size: 30)
                            : Center(
                              child: Text(
                                selectedImageFileName!,
                                style: const TextStyle(
                                  fontSize: 15
                                ),
                                )
                              )
                          ),
                        ),
                        
                        const SizedBox(height: 5),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              onPressed: (){
                                showOptions();
                              }, 
                              icon: const Icon(Icons.upload_file_outlined), 
                              label: const Text(
                                'Add file',
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container()
              ],
            ),
          ],
        ),
      );
    }

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
      PaymentMethodModel? payMethodDetails = payMethodDetailsMap[selection.id];
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: ListTile(
              title: Text(
                payMethodDetails?.methodName ?? 'No method name',
                style: const TextStyle(fontSize: 18),
              ),
              leading: Radio(
                value: selection.id,
                groupValue: _selectedPaymentMethodId,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethodId = value.toString();
                    _selectedPaymentMethodName = payMethodDetails?.methodName;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
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
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Place Order', 
          userRole: 'customer',
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
            child: Form(
              key: _formKey,
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
                          'Please select one of the payment method from list below.',
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
                  const SizedBox(height: 10),    

                  Row(
                    children: [
                      const Text(
                        'Amount to be paid:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: Text(
                          'RM${widget.payAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10), 

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
                          return buildErrorTile('Selected Payment method details not found');
                        } else {
                          PaymentMethodModel payMethodDetails = snapshot.data!;
                          return Column(
                            children: [
                              if(payMethodDetails.methodName == 'Touch n Go')
                                buildTNGOrFPXTile(payMethodDetails)
                              else if(payMethodDetails.methodName == 'Online banking')
                                buildTNGOrFPXTile(payMethodDetails)
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
                        const Text(
                          'Feel free to drop any feedback for us.',
                          style: TextStyle(
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
                      onPressed: isLoading ? null : _handleSaveButtonPress,
                      child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Submit',
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

class PayMethodSelection{
  final String id;
  bool isSelected;

  PayMethodSelection({
    required this.id,
    required this.isSelected,
  });
}