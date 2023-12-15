import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/main_dish/maindish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/side_dish/sidedish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/special_dish/specialdish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/display_menu_created.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class MenuAddDishPage extends StatefulWidget {
  const MenuAddDishPage({super.key});

  @override
  State<MenuAddDishPage> createState() => _MenuAddDishPageState();
}

class _MenuAddDishPageState extends State<MenuAddDishPage> {

  final menuNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool saveBtnOn = false;
  MenuDatabaseService serviceMenu = MenuDatabaseService();

  //create list of main dish text field
  List<MainDishesWidget> mainDishList = [];
  List<SideDishesWidget> sideDishList = [];
  List<SpecialDishesWidget> specialDishList = [];

  //create list of dishes
  List<DishModel> mainDishInList = [];
  List<DishModel> sideDishInList = [];
  List<DishModel> specialDishInList = [];

  //create list of string that store name of dishes
  List<String> dishNameList = [];
  List<String> photoList = [];


  Future<String> uploadImage(File? imageFile)async{
    if(imageFile != null){
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String randomChars = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
      var storageRef = FirebaseStorage.instance.ref().child('dishImages/$fileName$randomChars'); 
      var uploadTask = storageRef.putFile(imageFile);
      var snapshot = await uploadTask;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return '';

  }
 
  Future<List<DishModel>> toMainDishList() async {
    for(int i=0 ; i<mainDishList.length ; i++) {
      var widget = mainDishList[i];
      String downloadUrl = await uploadImage(widget.image);

      String dishName = widget.mainDishName.text;
      dishNameList.add(dishName);
      photoList.add(downloadUrl);
      mainDishInList.add(DishModel(
        dishId: i, 
        dishName: dishName,
        dishPhoto: downloadUrl
        )
      );

    }
    return mainDishInList.toList();
  }

  Future<List<DishModel>> toSideDishList()async {
    for(int i=0 ; i<sideDishList.length ; i++){
      var widget = sideDishList[i];
      String downloadUrl = await uploadImage(widget.image);

      String dishName = widget.sideDishName.text;
      dishNameList.add(dishName);
      photoList.add(downloadUrl);
      sideDishInList.add(DishModel(
        dishId: i, 
        dishName: dishName,
        dishPhoto: downloadUrl
        )
      );
    }
    return sideDishInList.toList();
  }

  Future<List<DishModel>> toSpecialDishList() async {
    for(int i=0 ; i<specialDishList.length ; i++){
      var widget = specialDishList[i];
      String downloadUrl = await uploadImage(widget.image);

      String dishName = widget.specialDishName.text;
      dishNameList.add(dishName);
      photoList.add(downloadUrl);
      specialDishInList.add(DishModel(
        dishId: i, 
        dishName: dishName,
        dishPhoto: downloadUrl
        )
      );
    }
    return specialDishInList.toList();
  }
  

  @override
  void initState(){
    super.initState();
    menuNameController.addListener(() {
      setState(() {
        saveBtnOn = menuNameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose(){
    menuNameController.dispose();
    super.dispose();
  }

  void removeMainDish(int index) {
    print('delete -> ${index}');
    setState(() {
      if (mainDishList.isNotEmpty && index >= 0 && index < mainDishList.length) {
        mainDishList.removeAt(index);
      }
    });
    print('length -> ${mainDishList.length}');
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //create the list of textfield
    Widget dynamicMainDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: mainDishList.length,
        //show the each of MainDishWidget inside the list of mainDishList[] 
        itemBuilder: (_, index) => mainDishList[index],  
      ),
    );

    Widget dynamicSideDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: sideDishList.length,
        itemBuilder: (_, index) => sideDishList[index],  
      ),
    );

    Widget dynamicSpecialDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: specialDishList.length,
        itemBuilder: (_, index) => specialDishList[index], 
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Menu List', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              menuMainPageRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: width*0.5,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(           
                        autovalidateMode: AutovalidateMode.onUserInteraction,  
                        controller: menuNameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "Menu's name",
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        validator: (value) {
                          if(value==null||value.isEmpty){
                            return "Please enter name of menu";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height:30),

                  Container(
                    width: width,
                    height: height*1.8, //*1.8
                    padding: const EdgeInsets.all(10),
                    decoration:BoxDecoration(
                      border:Border.all(),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        //Main dish
                        const Text(
                          'Main dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              dishNameList = [];
                              photoList = [];
                              mainDishList = [];
                            }
                            setState(() {
                              saveBtnOn = true;
                            });
                            //add MainDishesWidget into list, each widget has its index
                            int newIndex = mainDishList.length;
                            mainDishList.add(
                              MainDishesWidget(
                                onDelete: () {
                                  removeMainDish(newIndex);
                                },
                                index: newIndex,
                              )
                            );
                            print('added new length -> ${mainDishList.length}');
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicMainDish,

                        //side dish
                        const SizedBox(height: 30),
                        const Text(
                          'Side dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              //if contain at least one dish, the list of dish will be remained
                              dishNameList = [];
                              photoList = [];
                              sideDishList = [];
                            }
                            setState(() {
                              
                            });
                            //and then add new list under it
                            sideDishList.add(
                              SideDishesWidget()
                            );
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicSideDish,

                        const SizedBox(height: 30),
                        const Text(
                          'Special dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              //if contain at least one dish, the list of dish will be remained
                              dishNameList = [];
                              photoList = [];
                              specialDishList = [];
                            }
                            setState(() {
                              
                            });
                            //and then add new list under it
                            specialDishList.add(
                              SpecialDishesWidget()
                            );
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicSpecialDish,
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 55,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: saveBtnOn 
                      ? () async {
                          if(_formKey.currentState!.validate()){
                            DateTime now = DateTime.now();

                            MenuModel menuList = MenuModel(
                              menuName: menuNameController.text.trim(), 
                              createdDate: DateFormat('MMMM dd, yyyy').format(now), 
                              mainDishList: await toMainDishList(),
                              sideDishList: await toSideDishList(),
                              specialDishList: await toSpecialDishList(),
                            );
                            
                            await serviceMenu.addMenu(menuList);

                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context)=> DisplayMenuCreated(
                                menuListSelected: menuList,
                              )
                            );

                            //without going back
                            Navigator.pushReplacement(context, route);

                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menu created successfully', style: TextStyle(color: Colors.black),),
                              backgroundColor: Colors.amber,
                            )
                          );
                          }
                        }
                      : null,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Save',
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 20 
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}


