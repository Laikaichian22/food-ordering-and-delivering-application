import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class OpenOrderPage extends StatefulWidget {
  const OpenOrderPage({super.key});

  @override
  State<OpenOrderPage> createState() => _OpenOrderPageState();
}

class _OpenOrderPageState extends State<OpenOrderPage> {
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  //late Timer timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MenuDatabaseService menuService = MenuDatabaseService();
  PayMethodDatabaseService payMethodService = PayMethodDatabaseService();
  OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();
  Future<List<MenuModel>>? menuList;
  List<MenuModel>? retrievedMenuList;
  MenuModel? menuSelected;

  Future<List<PaymentMethodModel>>? payMethodList;
  List<PaymentMethodModel>? retrievedPayMethodList;

  final feedBackDesc = TextEditingController();
  final thankDesc = TextEditingController();
  final orderName = TextEditingController();

  String getCurrentDate(){
    DateTime currentDate = DateTime.now();
    String formattedDate = "${currentDate.year}-${_formatNumber(currentDate.month)}-${_formatNumber(currentDate.day)}";
    return formattedDate;
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
                  orderAddPageRoute, 
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

  Future<void> _selectDateAndTime(BuildContext context, {required bool isStartTime}) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: isStartTime ? selectedStartTime : selectedEndTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStartTime ? selectedStartTime : selectedEndTime,
        ),
      );

      if (pickedTime != null) {
        // Combine the selected date and time
        setState(() {
          if (isStartTime) {
            selectedStartTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          } else {
            selectedEndTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          }
        });
      }
    }
  }
  String _formatDateTime(DateTime dateTime) {
    // Format the DateTime with seconds having leading zeros
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
  String _formatNumber(int number) {
  return number.toString().padLeft(2, '0');
}

  @override
  void initState(){
    super.initState();
    _initRetrieval();
  }

  @override
  void dispose(){
    super.dispose();
    feedBackDesc.dispose();
    thankDesc.dispose();
    orderName.dispose();
  }

  Future<void> _initRetrieval() async{
    menuList = menuService.retrieveMenu();
    retrievedMenuList = await menuService.retrieveMenu();
    
    payMethodList = payMethodService.retrievePayMethod();
    retrievedPayMethodList = await payMethodService.retrievePayMethod();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Order', 
          onPress: ()async {
            return await showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  content: const Text(
                    'Confirm to leave this page?\nPlease save your work before you leave.', 
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          orderAddPageRoute, 
                          (route) => false,
                        );
                      }, 
                      child: const Text('Confirm')
                    )
                  ],
                );
              }
            );
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'For order opening, you need to select the options below to complete the order opening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,  
                    controller: orderName,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                    decoration: InputDecoration(
                      label: const Text('Order'),
                      hintText: "Order's name",
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Text(
                        getCurrentDate(),
                        style: const TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Start time: ',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Text(
                        _formatDateTime(selectedStartTime),
                        style: const TextStyle(
                          fontSize: 21
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => _selectDateAndTime(context, isStartTime: true),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          size: 35,
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'End time: ',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Text(
                        _formatDateTime(selectedEndTime),
                        style: const TextStyle(
                          fontSize: 21
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => _selectDateAndTime(context, isStartTime: false),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          size: 35,
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Please select a menu from list below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                          future: menuList, 
                          builder: (BuildContext context, AsyncSnapshot<List<MenuModel>> snapshot){
                            if(snapshot.hasData && snapshot.data!.isNotEmpty){
                              return Column(
                                  children: [
                                    for (int index = 0; index < retrievedMenuList!.length; index++)
                                      RadioListTile<MenuModel>(
                                        tileColor: Colors.amber,
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(
                                          retrievedMenuList![index].menuName,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(retrievedMenuList![index].createdDate),
                                        groupValue: menuSelected,
                                        value: retrievedMenuList![index],
                                        onChanged: (value) {
                                          setState(() {
                                            menuSelected = value as MenuModel;
                                          });
                                        },
                                      ),
                                  ],
                                );
                            }else if(snapshot.connectionState == ConnectionState.done && retrievedMenuList!.isEmpty){
                              return const Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(fontSize: 30),
                                )
                              );
                            }else{
                              return const Center(child: CircularProgressIndicator());
                            }
                          }
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Payment method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Please choose any of the payment method from list below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          child: FutureBuilder(
                            future: payMethodList, 
                            builder: (BuildContext context, AsyncSnapshot<List<PaymentMethodModel>> snapshot){
                              if(snapshot.hasData && snapshot.data!.isNotEmpty){
                                return Column(
                                  children: [
                                    for(int index=0 ; index<retrievedPayMethodList!.length ;index++)
                                      CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        tileColor: Colors.amber,
                                        value: retrievedPayMethodList![index].isSelected ?? false,
                                        title: Text(
                                          retrievedPayMethodList![index].methodName,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            retrievedPayMethodList![index].isSelected = value!;
                                          });
                                        }
                                      ),
                                  ],
                                );
                              }else if(snapshot.connectionState == ConnectionState.done && retrievedPayMethodList!.isEmpty){
                                return const Center(
                                  child: Text(
                                    'No data available',
                                    style: TextStyle(fontSize: 30),
                                  )
                                );
                              }else{
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        const Text(
                          'Description to be written on feedback label.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: SizedBox(
                            width: width*0.8,
                            child: TextFormField(
                              controller: feedBackDesc,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Write down your description",
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    height: height*0.3,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        const Text(
                          'Description to be written whenever an order has been placed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17
                          )
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: SizedBox(
                            width: width*0.8,
                            child: TextFormField(
                              controller: thankDesc,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Write down your description",
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: () async {
                        OrderOwnerModel orderCreated = OrderOwnerModel(
                          orderName: orderName.text,
                          feedBack: feedBackDesc.text,
                          desc: thankDesc.text,
                          menuChosen: menuSelected as MenuModel,
                          startTime: selectedStartTime,
                          endTime: selectedEndTime,
                          openDate: getCurrentDate(),
                        );

                        await orderService.addOrder(orderCreated);  

                        _showDialog('Order', 'Order created successfully');    

                      }, 
                      child: const Text(
                        'Open order', 
                        style: TextStyle(
                          fontSize: 20, 
                          color: Colors.black
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}