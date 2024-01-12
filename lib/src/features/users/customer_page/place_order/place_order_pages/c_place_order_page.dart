import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/dish_select_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/d_select_payment_page.dart';

class CustPlaceOrderPage extends StatefulWidget {
  const CustPlaceOrderPage({
    required this.currentOrderOpened,
    super.key
  });

  final OrderOwnerModel currentOrderOpened;

  @override
  State<CustPlaceOrderPage> createState() => _CustPlaceOrderPageState();
}

class _CustPlaceOrderPageState extends State<CustPlaceOrderPage> {
  final GlobalKey<_AdditionalWidgetState> additionalWidgetKey = GlobalKey<_AdditionalWidgetState>();
  final custNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final remarkController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final UserDatabaseService userService = UserDatabaseService();
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  final userId = AuthService.firebase().currentUser?.id;

  @override
  void initState(){
    super.initState();
    initializeUserData();
  }
  
  Future<void> initializeUserData() async {
    if (userId != null) {
      try {
        UserModel? userData = await userService.getUserDataById(userId!);
        if (userData != null) {
          // Set the controller values with the user data
          custNameController.text = userData.orderCustName ?? '';
          emailController.text = userData.orderEmail ?? '';
          phoneController.text = userData.orderPhone ?? '';
          locationController.text = userData.orderLocation ?? '';
          remarkController.text = userData.orderRemark ?? '';
        }
      } catch (e) {
        // Handle the exception, e.g., show an error message
        debugPrint('Error initializing user data: $e');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {

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
          userRole: 'customer',
          onPress: (){
            showDialog(
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
              child: Center(
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
                                        text: '[e.g: MA1/FABU/K10]',
                                        style: TextStyle(
                                          fontSize: 14
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Autocomplete<String>(
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    final List<String> options = [
                                    'MA1', 'MA2', 'MA3', 'MA4', 'MA5',
                                    'L01', 'L02', 'L03', 'L04', 'L05',
                                    'L11', 'L12', 'L13', 'L14', 'L15',
                                    'S01', 'S02', 'S03', 'S04', 'S05',
                                    'S30', 'S31', 'S32', 'S33', 'S38',
                                    'XC1', 'XC2', 'WA1', 'WA2', 'WA3',
                                    'U2', 'U3', 'U4', 'U5', 'U6',
                                    'H01', 'H02', 'H03', 'H04', 'H05',
                                    'G01', 'G02', 'G03', 'G04', 'G05',
                                    'PSZ', 'FABU', 'K01', 'K07', 'K02', 
                                    ];
                                    
                                    return options
                                    .where((String option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                                    .toList();
                                  },
                                  onSelected: (String selection) {
                                    locationController.text = selection;
                                  },
                                  fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      autocorrect: false,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      decoration: const InputDecoration(
                                        hintText: 'Location',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (String value) {
                                        locationController.text = value.toUpperCase();
                                      },
                                      onFieldSubmitted: (String value) {
                                        onFieldSubmitted();
                                      },
                                    );
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
                              onPressed: ()async{
                                await userService.updateCustOrderInfor(
                                  userId!, 
                                  custNameController.text.trim(), 
                                  emailController.text.trim(), 
                                  phoneController.text.trim(), 
                                  locationController.text.trim(), 
                                  remarkController.text.trim()
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Information stored successfully', 
                                      style: TextStyle(color: Colors.black)
                                    ),
                                    backgroundColor: Colors.amber,
                                  )
                                );
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
                              future: MenuDatabaseService().getMenu(widget.currentOrderOpened.menuChosenId!),
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
                                    menuName: widget.currentOrderOpened.orderName!,
                                    payAmount: totalAmount,
                                    menuDate: widget.currentOrderOpened.openDate!,
                                    orderOpenedId: widget.currentOrderOpened.id!,
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
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
  late Future<void> priceListStateFuture;
  final PriceListDatabaseService priceListService = PriceListDatabaseService();
  PriceListModel? getOpenedPriceList;

  Future<void> loadPriceListState()async{
    getOpenedPriceList = await priceListService.getOpenPriceList();
  }
  
  @override
  void initState() {
    super.initState();
    priceListStateFuture = loadPriceListState();
  }

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
    return FutureBuilder<void>(
      future:priceListStateFuture,
      builder: (context, snapshot) {
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
                  getOpenedPriceList != null 
                  ? buildPriceList(getOpenedPriceList!.priceListId!)
                  : buildErrorTile("No Price List available"),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}