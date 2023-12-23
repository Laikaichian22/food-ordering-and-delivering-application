import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/3place_order/dish_select_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/select4_payment_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class CustPlaceOrderPage extends StatefulWidget {
  const CustPlaceOrderPage({super.key});

  @override
  State<CustPlaceOrderPage> createState() => _CustPlaceOrderPageState();
}

class _CustPlaceOrderPageState extends State<CustPlaceOrderPage> {

  var custNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();
  var remarkController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height= MediaQuery.of(context).size.height;
    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;
    List<String>selectedDishId = [];
    void handleBackPressed(Map<String, dynamic> data) {
      custNameController.text = data['custName'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      locationController.text = data['location'] ?? '';
      remarkController.text = data['remark'] ?? '';
      List<String> updatedSelectedDishIds = List<String>.from(data['selectedDishIds'] ?? []);
      setState(() {
        selectedDishId = updatedSelectedDishIds;
      });
    }

    Widget buildMenu(MenuModel menu) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DishSelectionWidget(
            category: 'Main dishes', 
            dishes: menu.mainDishList, 
            selectedDishIds: selectedDishId,
          ),

          const SizedBox(height: 10),

          DishSelectionWidget(
            category: 'Side dishes', 
            dishes: menu.sideDishList, 
            selectedDishIds: selectedDishId
          ),

          const SizedBox(height: 10),

          DishSelectionWidget(
            category: 'Special dishes', 
            dishes: menu.specialDishList, 
            selectedDishIds: selectedDishId
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Place Order', 
          onPress: ()async{
            return await showDialog(
              context: context, 
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text(
                    'Confirm to leave this page?\n\nLeaving this page will cause you lose the that data you entered.',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          menuPageRoute,
                          (route) => false,
                        );
                      }, 
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    )
                  ],
                );
              }
            );            
          }, 
          barColor: custColor
        ),
        body: SingleChildScrollView(
          child: currentOrder == null
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: height*0.8,
                width: width,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                child: const Center(
                  child: Text(
                    'No open order found.\nCannot place any order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40
                    ),
                    ),
                ),
              ),
            )
          : Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Personal Details: ',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5
                      )
                    ),
                    child: Form(
                      key: _formkey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Address: ',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: emailController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Email Address',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter an email address';
                                }else{
                                  return null;
                                }
                              },
                            ),

                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Phone Number: ',
                                  ),
                                  TextSpan(
                                    text: '[e.g: 0123456789]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: phoneController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a phone number';
                                }else{
                                  return null;
                                }
                              },
                            ),
                           
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Pickup your Order at? ',
                                  ),
                                  TextSpan(
                                    text: '[e.g: MA1/FABU]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: locationController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Location',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a valid location';
                                }else{
                                  return null;
                                }
                              },
                            ),

                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Name: ',
                                  ),
                                  TextSpan(
                                    text: '[In short form, e.g:Lee/Alice/Jack]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: custNameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter a name';
                                }else{
                                  return null;
                                }
                              },
                            ),

                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Remark: ',
                                  ),
                                  TextSpan(
                                    text: '[e.g: add rice/class until 1pm]',
                                    style: TextStyle(
                                      fontSize: 14
                                    )
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: remarkController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'Remark',
                                border: OutlineInputBorder()
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 240, 145, 3), 
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            elevation: 10,
                            shadowColor: const Color.fromARGB(255, 92, 90, 85),
                          ),
                          onPressed: (){
                            //remember the users information, store into new folder
                            //and the new created file has the same id as the user
                          },
                          child: const Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),
                  const Text(
                    'Order Details: ',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
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
                          'Order 1 [1st pack]',
                          style: TextStyle(
                            fontSize: 25
                          ),
                        ),
                        const Text(
                          '[If any of the selection cannot be seen in the list, it means that the dishes is SOLD OUT, please select other dishes]',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black
                          ),
                        ),
                        const Text(
                          '\n!! Please select the correct combination of dishes based on the combination displayed on the price list.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<MenuModel?>(
                          future: MenuDatabaseService().getMenu(currentOrder.menuChosenId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data == null) {
                              return const Text('No menu found.');
                            } else {
                              MenuModel menu = snapshot.data!;
                              return buildMenu(menu);
                            }
                          },
                        ),                    
                      ],
                    )
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
                        if (_formkey.currentState?.validate() ?? false){
                          if (selectedDishId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one dish.'),
                              ),
                            );
                            return;
                          }
                          
                          Map<String, dynamic>? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectOrderPayMethodPage(
                                custName: custNameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                location: locationController.text,
                                remark: remarkController.text,
                                selectedDishIds: selectedDishId,
                                menuName: currentOrder.orderName!,
                                menuDate: currentOrder.openDate!,
                                onBackPressed: handleBackPressed,
                              ),
                            ),
                          );

                           if (result != null) {
                            setState(() {
                              
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}