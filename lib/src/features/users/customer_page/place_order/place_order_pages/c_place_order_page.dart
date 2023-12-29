import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/provider/selectedpricelist_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/dish_select_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/d_select_payment_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class CustPlaceOrderPage extends StatefulWidget {
  const CustPlaceOrderPage({super.key});

  @override
  State<CustPlaceOrderPage> createState() => _CustPlaceOrderPageState();
}

class _CustPlaceOrderPageState extends State<CustPlaceOrderPage> {
  final GlobalKey<_AdditionalWidgetState> additionalWidgetKey = GlobalKey<_AdditionalWidgetState>();
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
    List<String>selectedDishIdList = [];
    List<String>selectedDishTypeList = [];

    void handleBackPressed(Map<String, dynamic> data) {
      custNameController.text = data['custName'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      locationController.text = data['location'] ?? '';
      remarkController.text = data['remark'] ?? '';
      List<String> updatedSelectedDishIds = List<String>.from(data['selectedDishIds'] ?? []);
      setState(() {
        selectedDishIdList = updatedSelectedDishIds;
      });
    }

    Widget buildMenu(MenuModel menu) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DishSelectionWidget(
            category: 'Main dishes', 
            dishes: menu.mainDishList, 
            selectedDishIdList: selectedDishIdList,
            selectedDishTypeList: selectedDishTypeList,
          ),

          const SizedBox(height: 10),

          DishSelectionWidget(
            category: 'Side dishes', 
            dishes: menu.sideDishList, 
            selectedDishIdList: selectedDishIdList,
            selectedDishTypeList: selectedDishTypeList,
          ),

          const SizedBox(height: 10),

          DishSelectionWidget(
            category: 'Special dishes', 
            dishes: menu.specialDishList, 
            selectedDishIdList: selectedDishIdList,
            selectedDishTypeList: selectedDishTypeList,
          ),
        ],
      );
    }

    double calculateTotalAmount(){
      double amount = 0.0;
      int mainDishCount = 0;
      int sideDishCount = 0; 
      int specialDishCount = 0;
      for (String dishType in selectedDishTypeList) {
        if (dishType == 'Main') {
          mainDishCount++;
        } else if (dishType == 'Side') {
          sideDishCount++;
        } else if (dishType == 'Special') {
          specialDishCount++;
        }
      }
      
      if(sideDishCount==2 && mainDishCount==0 && specialDishCount==0){
        amount = 5.00;
      }else if(sideDishCount==3 && mainDishCount==0 && specialDishCount==0){
        amount = 5.50;
      }else if(sideDishCount==1 && mainDishCount==1 && specialDishCount==0){
        amount = 6.00;
      }else if(sideDishCount==1 && mainDishCount==2 && specialDishCount==0){
        amount = 8.00;
      }else if(sideDishCount==2 && mainDishCount==1 && specialDishCount==0){
        amount = 6.50;
      }else if(sideDishCount==2 && mainDishCount==2 && specialDishCount==0){
        amount = 9.50;
      }else if(sideDishCount==3 && mainDishCount==1 && specialDishCount==0){
        amount = 7.50;
      }else if(sideDishCount==0 && mainDishCount==1 && specialDishCount==0){
        amount = 5.00;
      }else if(sideDishCount==0 && mainDishCount==2 && specialDishCount==0){
        amount = 5.00;
      }else if(sideDishCount==0 && mainDishCount==3 && specialDishCount==0){
        amount = 9.50;
      }else if(sideDishCount==0 && mainDishCount==0 && specialDishCount==1){
        amount = 9.00;
      }
      return amount;
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
        body: Stack(
          children: [
            SingleChildScrollView(
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
                                    hintText: 'Phone Number',
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
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      additionalWidgetKey.currentState?.toggleVisibility();
                                    },
                                    child: const Text(
                                      'Price list',
                                      style: TextStyle(
                                        fontSize: 15
                                      ),
                                    )
                                  ),
                                )
                              ]
                            ),
                            const SizedBox(height: 15),
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
                              if (selectedDishIdList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select at least one dish.'),
                                  ),
                                );
                                return;
                              }

                              double totalAmount = calculateTotalAmount();

                              if (totalAmount == 0.0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select the correct combination of dishes.'),
                                  ),
                                );
                                return;
                              }
                              
                              Map<String, dynamic>? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustSelectPayMethodPage(
                                    custName: custNameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    location: locationController.text,
                                    remark: remarkController.text,
                                    selectedDishIds: selectedDishIdList,
                                    menuName: currentOrder.orderName!,
                                    payAmount: totalAmount,
                                    menuDate: currentOrder.openDate!,
                                    orderOpenedId: currentOrder.id!,
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
            PriceListPosition(
              key:additionalWidgetKey
            )
          ],
        ),
      ),
    );
  }
}

class PriceListPosition extends StatefulWidget {
  const PriceListPosition({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdditionalWidgetState createState() => _AdditionalWidgetState();
}

class _AdditionalWidgetState extends State<PriceListPosition> {
  bool isVisible = false;
  Widget buildErrorTile(String text){
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 223, 223, 223)
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

  Widget buildPriceList(String id){
    return FutureBuilder<PriceListModel?>(
      future: PriceListDatabaseService().getPriceListDetails(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return buildErrorTile("Error loading price list details");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return buildErrorTile("No data available for the selected price list");
        } else {
          PriceListModel priceList = snapshot.data!;
          return Container(
            width: 400,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 255, 249, 221)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price List Details:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'List Name: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.listName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Created Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.createdDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black, 
                    ),
                    children: [
                      const TextSpan(
                        text: 'Details: \n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.priceDesc,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }


  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPriceListProvider = Provider.of<SelectedPriceListProvider>(context);
    
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      right: isVisible ? 0 : -290,
      top: 100,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 290,
          height: 500,
          color: const Color.fromARGB(255, 72, 173, 255),
          child: Column(
            children: [
              Row(
                children: [
                   IconButton(
                    iconSize: 50,
                    icon: const Icon(
                      Icons.arrow_right_outlined,
                      color: Colors.black,
                    ),
                    onPressed: toggleVisibility
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Price List',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

              selectedPriceListProvider.selectedPriceListId != null
              ? buildPriceList(selectedPriceListProvider.selectedPriceListId!)
              : buildErrorTile("No Price List available"),
            ]
          ),
        ),
      ),
      
    );
  }
}