import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/paymethod_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/close_open_order.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

import '../../../auth/models/dish.dart';
import '../../../auth/models/menu.dart';
import '../../../auth/models/order_owner.dart';
import '../../../auth/models/price_list.dart';

class ViewOrderPage extends StatefulWidget {
  const ViewOrderPage({
    required this.orderSelected,
    super.key
  });

  final OrderOwnerModel orderSelected;

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  final OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();
  final PriceListDatabaseService priceListService = PriceListDatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool isEditPressed = false;
  bool anyChanges = false;
  final TextEditingController orderNameController = TextEditingController();
  bool isOrderOpened = false;
  late Future<void> ownerOpenOrderFuture;

  Future<void> loadOwnerOrderState()async{
    try{
      OrderOwnerModel? ownerOrder = await orderService.getOwnerOrder(widget.orderSelected.id!);
      if(ownerOrder!.openedStatus == 'Yes'){
        isOrderOpened = true;
      }else{
        isOrderOpened = false;
      }
    }catch(e){
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    orderNameController.text = widget.orderSelected.orderName!;
    ownerOpenOrderFuture = loadOwnerOrderState();
  }

  @override
  void dispose(){
    orderNameController.dispose();
    super.dispose();
  }

  void _updateAnyChanges() {
    setState(() {
      anyChanges = true;
    });
  }

  Widget displayTextField(TextEditingController inputController, String title, String hint, String errorMessage){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 270,
          child: TextFormField(
            readOnly: isEditPressed ? false : true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: inputController,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12
              ),
              labelText: title,
              labelStyle: const TextStyle(
                fontSize: 15
              ),
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            validator: (value) {
              if(value==null||value.isEmpty){
                return errorMessage;
              }
              return null;
            },
            onChanged: (value) {
              _updateAnyChanges();
            },
          ),
        ),
        InkWell(
          onTap: ()async{
            setState(() {
              isEditPressed = true;
            });
            if(anyChanges){
              if(_formKey.currentState!.validate()){
                await orderService.updateOrderName(widget.orderSelected.id!, orderNameController.text);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Information updated successfully', 
                      style: TextStyle(color: Colors.black)
                    ),
                    backgroundColor: Colors.amber,
                  )
                );
                setState(() {
                  anyChanges = false;
                  isEditPressed = false;
                });
              }
            }
          },
          child: anyChanges == true 
          ? const Icon(Icons.check)
          : const Icon(Icons.edit_outlined)
        )
      ],
    );
  }

  Widget buildMenuDetails(String menuId) {
    return FutureBuilder<MenuModel?>(
      future: MenuDatabaseService().getMenu(menuId), 
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          // Error state or no data
          return buildErrorTile('Error in the Menu chosen');
        }else{
          MenuModel menu = snapshot.data!;
          return Container(
            height: 500,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu Details:',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Menu Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: menu.menuName,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
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
                            text: menu.createdDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    const Text(
                      'Main Dishes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    buildDishList(menu.mainDishList),
                    const SizedBox(height: 20),
                    const Text(
                      'Side Dishes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    buildDishList(menu.sideDishList),
                    const SizedBox(height: 20),
                    const Text(
                      'Special Dishes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    buildDishList(menu.specialDishList),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            
          );
        }
      }
    );
  }
  
  Widget buildDishList(List<DishModel> dishList) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dishList.map((dish) => Container(
          width: 300,
          color: const Color.fromARGB(255, 255, 228, 148),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${dish.dishSpcId}- ${dish.dishName}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              if (dish.dishPhoto.isNotEmpty) // Check if the dish has an image
                Image.network(
                  dish.dishPhoto,
                  width: 200, 
                  height: 200, 
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 15),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget buildPriceList(String id){
    return FutureBuilder<PriceListModel?>(
      future: PriceListDatabaseService().getPriceListDetails(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error state
          return buildErrorTile("Error loading price list details");
        } else if (!snapshot.hasData || snapshot.data == null) {
          // No data state
          return buildErrorTile("No data available for the selected price list");
        } else {
          // Data loaded successfully
          PriceListModel priceList = snapshot.data!;
          // Display the contents of the price list
          return Container(
            width: 300,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price List Details:',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
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
                      fontSize: 18,
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
                      fontSize: 18,
                      color: Colors.black, 
                    ),
                    children: [
                      const TextSpan(
                        text: 'Details: ',
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

  Widget buildPayMethod() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment methods: ',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<PaymentMethodModel>>(
            future: PayMethodDatabaseService().getOpenPayMethods(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return buildErrorTile('Error fetching payment method details');
              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return buildErrorTile('No open payment methods found');
              } else {
                List<PaymentMethodModel> openPaymentMethods = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: openPaymentMethods.length,
                  itemBuilder: (context, index) {
                    PaymentMethodModel payMethodDetails = openPaymentMethods[index];
                    return Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: ListTile(
                        title: Text(
                          payMethodDetails.methodName ?? 'No method name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(height: 20),
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
        borderRadius: BorderRadius.circular(20),
        color: menuErrorColor
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: errorTextColor
          ),
        )
      ),  
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: '', 
          userRole: 'owner',
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              orderAddPageRoute, 
              (route) => false,
            );
          },
          barColor: ownerColor
        ),
        body: FutureBuilder<void>(
          future: ownerOpenOrderFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isOrderOpened
                            ? InkWell(
                                onTap: (){
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => CloseOpenOrderPage(
                                      orderSelected: widget.orderSelected
                                    )
                                  );
                                  Navigator.push(context, route);
                                },
                                child: Container(
                                  width: 130,
                                  height: 50,
                                  color: orderOpenedColor,
                                  child: const Center(
                                    child: Text(
                                      'Order is opening',
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    )
                                  )
                                ),
                              )
                            : Container(), 
                            InkWell(
                              onTap: (){
                                MaterialPageRoute route = MaterialPageRoute(
                                  builder: (context) => CloseOpenOrderPage(
                                    orderSelected: widget.orderSelected
                                  )
                                );
                                Navigator.push(context, route);
                              },
                              child: Container(
                                width: 130,
                                height: 50,
                                color: isOrderOpened ? const Color.fromARGB(255, 242, 255, 0) : const Color.fromARGB(255, 60, 255, 0),
                                child: Center(
                                  child: Text(
                                    isOrderOpened ? 'Press to CLOSE order' : 'Press to OPEN order',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16
                                    ),
                                  )
                                )
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),

                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Order Name',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 5),
                              displayTextField(orderNameController, 'Order Name', 'Update order name', 'Please enter order name'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        FutureBuilder<PriceListModel?>(
                          future: priceListService.getOpenPriceList(), 
                          builder:(context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return buildPriceList('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data == null){
                              return buildPriceList('No data');
                            } else {
                              PriceListModel data = snapshot.data!;
                              return data.openStatus == 'Yes'
                              ? buildPriceList(data.priceListId!)
                              : buildPriceList("You haven't chosen any price list");
                            }
                          },
                        ),
                        const SizedBox(height: 40),
          
                        buildMenuDetails(widget.orderSelected.menuChosenId!),
                        const SizedBox(height: 40),
          
                        buildPayMethod(),
                        const SizedBox(height: 100),
          
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deleteButtonColor,
                              elevation: 10,
                              shadowColor: const Color.fromARGB(255, 92, 90, 85),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: const Text(
                                      'You are deleting this order',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    content: const Text(
                                      'Confirm to delete this order?',
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
                                            fontSize: 20,
                                            color: cancelTextColor
                                          ),
                                        )
                                      ),
                                      TextButton(
                                        onPressed: ()async {
                                          await orderService.deleteOrder(widget.orderSelected.id, context);
                                        }, 
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: deleteTextColor
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
                                color: yellowColorText
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      )
    );
  }
}
