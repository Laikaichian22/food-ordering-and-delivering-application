import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/close_order.dart';

import '../../../auth/models/dish.dart';
import '../../../auth/models/menu.dart';
import '../../../auth/models/order_owner.dart';

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
  
  Widget buildMenuDetails(MenuModel? menu) {
    if (menu == null) {
      return buildErrorTile('Error in the Menu chosen');
    }

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
              Text(
                'Menu Name: ${menu.menuName}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Created Date: ${menu.createdDate}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),

              const Text(
                'Main Dishes:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              buildDishList(menu.mainDishList),
              const SizedBox(height: 20),
              const Text(
                'Side Dishes:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              buildDishList(menu.sideDishList),
              const SizedBox(height: 20),
              const Text(
                'Special Dishes:',
                style: TextStyle(
                  fontSize: 18,
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
  bool isDropdownVisible = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarNoArrow(
          title: widget.orderSelected.orderName!, 
          barColor: ownerColor
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
                      const Text(
                        'Time left: 10:01:05',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => CloseOrderPage(
                              orderSelected: widget.orderSelected
                            )
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          width: 170,
                          height: 50,
                          color: orderOpenedColor,
                          child: const Center(
                            child: Text(
                              'Order is opening',
                              style: TextStyle(
                                fontSize: 18
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => CloseOrderPage(
                              orderSelected: widget.orderSelected
                            )
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          width: 170,
                          height: 50,
                          color: const Color.fromARGB(255, 242, 255, 0),
                          child: const Center(
                            child: Text(
                              'Press to CLOSE order',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                                  
                  buildErrorTile("You haven't choose the Price List"),
                  const SizedBox(height: 40),

                  //will show the menu in limited sized container
                  //buildErrorTile('Error in the Menu chosen'),
                  buildMenuDetails(widget.orderSelected.menuChosen),
                  const SizedBox(height: 40),


                  //will show the menu in limited sized container
                  buildErrorTile('Error in the payment methods chosen'),
                  const SizedBox(height: 100),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: (){
                        // MaterialPageRoute route = MaterialPageRoute(
                        //   builder: (context) => EditFPXPaymentPage(
                        //     payMethodSelected: widget.payMethodSelected
                        //   )
                        // );
                        // Navigator.pushReplacement(context, route);
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
              ),
            ),
          ),
        ),
      )
    );
  }
}
