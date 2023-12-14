import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

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
    TextEditingController menuName = TextEditingController();
    menuName.text = menuListSelected.menuName;

    return SafeArea(
      child: Scaffold(
        appBar: AppBarNoArrow(
          title: 'Menu', 
          //onPress: (){}, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    controller: menuName,
                    readOnly: true,
                    
                    decoration: const InputDecoration(
                      label:Text(
                        'Menu Name',
                        style: TextStyle(
                          fontSize: 25
                        ),
                      ),
                      border: OutlineInputBorder()
                    ),
                  ),

                  const SizedBox(height: 20),

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
                      color: const Color.fromARGB(255, 255, 240, 196),
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
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text("${index + 1} : ${menuListSelected.mainDishList[index].dishName}"),
                                      ),
                                      const Divider()
                                    ],
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
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text("${index + 1} : ${menuListSelected.sideDishList[index].dishName}"),
                                      ),
                                      const Divider()
                                    ],
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
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text("${index + 1} : ${menuListSelected.specialDishList[index].dishName}"),
                                      ),
                                      const Divider()
                                    ],
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

                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              menuMainPageRoute, 
                              (route) => false,
                            );
                          }, 
                          child: const Text('Back')
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: (){
                            
                          }, 
                          child: const Text('Edit')
                        ),
                      ),
                    ],
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