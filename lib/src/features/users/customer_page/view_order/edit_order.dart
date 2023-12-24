import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CustEditSelectedOrderPage extends StatefulWidget {
  const CustEditSelectedOrderPage({
    required this.orderSelected,
    super.key
  });

  final OrderCustModel orderSelected;

  @override
  State<CustEditSelectedOrderPage> createState() => _CustEditSelectedOrderPageState();
}

class _CustEditSelectedOrderPageState extends State<CustEditSelectedOrderPage> {
  final custNameController = TextEditingController();
  final destinationController = TextEditingController();
  final remarkController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool anyChanges = false;
  bool isLoading = false;
  OrderCustDatabaseService service = OrderCustDatabaseService();
  
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
                  viewCustOrderListPageRoute, 
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

  Future<void> _uploadData()async{
    if(_formKey.currentState!.validate()){
      await service.updateExistingOrder(
        widget.orderSelected.id!, 
        custNameController.text.trim(), 
        destinationController.text.trim(), 
        remarkController.text.trim(), 
        emailController.text.trim(), 
        phoneController.text.trim()
      );
      _showDialog('Update order', 'Your order has been updated successfully');
    }
  }

  void _handleSaveButtonPress() async {
    setState(() {
      isLoading = true;
    });

    await _uploadData(); 
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    custNameController.text = widget.orderSelected.custName!;
    destinationController.text = widget.orderSelected.destination!;
    remarkController.text = widget.orderSelected.remark!;
    phoneController.text = widget.orderSelected.phone!;
    emailController.text = widget.orderSelected.email!;

    custNameController.addListener(() {
      if(custNameController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    destinationController.addListener(() {
      if(destinationController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    remarkController.addListener(() {
      if(remarkController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    phoneController.addListener(() {
      if(phoneController.text.isNotEmpty){
        anyChanges = true;
      }
    });
    emailController.addListener(() {
      if(emailController.text.isNotEmpty){
        anyChanges = true;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    custNameController.dispose();
    destinationController.dispose();
    remarkController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //var height= MediaQuery.of(context).size.height;

    Widget editableTextTile(
      String title, 
      TextEditingController theController,
      String hint,
      String errorText
      ){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 0, 122, 222)
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: width,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: theController,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              validator: (value) {
                if(value==null||value.isEmpty){
                  return errorText;
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10)
        ],
      );
    }

    Widget nonEditableTile(String title, String details){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Text(
              details,
              style: const TextStyle(
              fontSize: 17
            ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(thickness: 3),
        ]
      );
    }

    Widget buildReceiptTile(String title, String subtitle, String receiptUrl){
      return Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15
            ),
          ),
          const SizedBox(height: 5),
          Image.network(
            receiptUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        ]
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Edit order', 
          onPress: (){
            if (anyChanges == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      'Confirm to leave this page?\n\nPlease save your work before you leave',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            viewCustOrderListPageRoute,
                            (route) => false,
                          );
                        },
                        child: const Text('Confirm'),
                      )
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                viewCustOrderListPageRoute,
                (route) => false,
              );
            }
          }, 
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu: ${widget.orderSelected.menuOrderName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Order placed at ${DateFormat('yyyy-MM-dd hh:mm:ss').format(widget.orderSelected.dateTime!)}',
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            editableTextTile('Email Address', emailController, 'Email', 'Please enter an email address'),
                            editableTextTile('Phone Number', phoneController, 'Phone Number', 'Please enter a phone number'),
                            editableTextTile('Pickup your Oder at?', destinationController, 'Location', 'Please enter a valid location'),
                            editableTextTile('Name', custNameController, 'Name', 'Please enter a name'),
                            const Text(
                              'Remark',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 122, 222)
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: width,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: remarkController,
                                decoration: InputDecoration(
                                  hintText: 'Remark',
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            nonEditableTile('Order 1', '${widget.orderSelected.orderDetails}'),
                            nonEditableTile('Amount paid', '${widget.orderSelected.payAmount}'),
                            nonEditableTile('Payment Method', '${widget.orderSelected.payMethod}'),
                            widget.orderSelected.receipt == '' 
                            ? Container()
                            : buildReceiptTile('Receipt', 'You have made your payment. This is your receipt.', '${widget.orderSelected.receipt}'),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isLoading || !anyChanges) ? null : _handleSaveButtonPress,
                    child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}