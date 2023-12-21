import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';

import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../auth/models/menu.dart';

class DisplayMenuPage extends StatefulWidget {
  const DisplayMenuPage({super.key});

  @override
  State<DisplayMenuPage> createState() => _DisplayMenuPageState();
}

class _DisplayMenuPageState extends State<DisplayMenuPage> {
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
    } else {
      return 'N/A';
    }
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height= MediaQuery.of(context).size.height;

    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;
    
    Widget buildDishCategory(String categoryTitle, List<DishModel> dishes) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                categoryTitle,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 5),
      
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                DishModel dish = dishes[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('${dish.dishSpcId}- ${dish.dishName}'),
                      const SizedBox(height: 5),
                      dish.dishPhoto.isNotEmpty
                      ? Image.network(
                          dish.dishPhoto,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey
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
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      );
    }
    
    Widget buildMenu(MenuModel menu){
      return Container(
        height: height*0.7,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
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
                ],
              ),
              const SizedBox(height: 10),
              buildDishCategory('Main dishes', menu.mainDishList),
              const SizedBox(height: 30),
              buildDishCategory('Side dishes', menu.sideDishList),
              const SizedBox(height: 30),
              buildDishCategory('Special dishes', menu.specialDishList),
                  
            ],
          ),
        ),
      );
    }
    

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: currentOrder == null ? '': currentOrder.orderName!,
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              custMenuPriceListRoute, 
              (route) => false,
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
                  'No open order found.',
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
                    Row(
                      children: [
                        const Text(
                          'Start time: ',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                        Text(
                          _formatDateTime(currentOrder.startTime),
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Closing time: ',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                        Text(
                          _formatDateTime(currentOrder.endTime),
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    FutureBuilder<MenuModel>(
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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            placeOrderPageRoute,
                            (route) => false,
                          );
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
