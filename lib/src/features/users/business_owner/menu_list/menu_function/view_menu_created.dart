import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_function/edit_menu.dart';

class DisplayMenuCreated extends StatelessWidget {
  const DisplayMenuCreated({
    required this.menuListSelected,
    super.key
  });

  final MenuModel menuListSelected;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: DirectAppBarNoArrow(
          title: menuListSelected.menuName, 
          userRole: 'owner',
          textSize: 0,
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Created Date: ${menuListSelected.createdDate}'),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    height: height*0.4,
                    width: width,
                    child: Card(
                      shadowColor: const Color.fromARGB(255, 116, 192, 255),
                      elevation: 9,
                      color: const Color.fromARGB(255, 255, 245, 215),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Main Dish',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: menuListSelected.mainDishList.length,
                              itemBuilder: (_, index) {
                                var dish = menuListSelected.mainDishList[index];
                                var widgets = <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "${dish.dishSpcId} : ${dish.dishName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ];
                                if (dish.dishPhoto != '') {
                                  widgets.addAll([
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Image(
                                        image: NetworkImage(dish.dishPhoto),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                  ]);
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: widgets,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: height*0.4,
                    width: width,
                    child: Card(
                      shadowColor: const Color.fromARGB(255, 116, 192, 255),
                      elevation: 9,
                      color: const Color.fromARGB(255, 255, 240, 196),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Side Dish',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: menuListSelected.sideDishList.length,
                              itemBuilder: (_, index) {
                                var dish = menuListSelected.sideDishList[index];
                                var widgets = <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "${dish.dishSpcId} : ${dish.dishName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ];
                                if (dish.dishPhoto != '') {
                                  widgets.addAll([
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Image(
                                        image: NetworkImage(dish.dishPhoto),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                  ]);
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: widgets,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: height*0.4,
                    width: width,
                    child: Card(
                      shadowColor: const Color.fromARGB(255, 116, 192, 255),
                      elevation: 9,
                      color: const Color.fromARGB(255, 255, 240, 196),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Special Dish',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: menuListSelected.specialDishList.length,
                              itemBuilder: (_, index) {
                                var dish = menuListSelected.specialDishList[index];
                                var widgets = <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "${dish.dishSpcId} : ${dish.dishName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ];
                                if (dish.dishPhoto != '') {
                                  widgets.addAll([
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Image(
                                        image: NetworkImage(dish.dishPhoto),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                  ]);
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: widgets,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 6,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: (){
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => OwnerEditMenuPage(menuListSelected: menuListSelected)
                        );
                        Navigator.push(context, route);
                      }, 
                      child: const Text(
                        'Update', 
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 29
                        )
                      )
                    ),
                  ),
                ],
              )
            ),
          ),
        ), 
      ),
    );
  }
}