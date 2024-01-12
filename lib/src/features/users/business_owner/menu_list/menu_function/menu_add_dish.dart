import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/main_dish/maindish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/side_dish/sidedish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/dishes/special_dish/specialdish_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_function/view_menu_created.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class MenuAddDishPage extends StatefulWidget {
  const MenuAddDishPage({super.key});

  @override
  State<MenuAddDishPage> createState() => _MenuAddDishPageState();
}

class _MenuAddDishPageState extends State<MenuAddDishPage> {
  Map<Key, MainDishesWidget> mainDishWidgetMap = {};
  Map<Key, SideDishesWidget> sideDishWidgetMap = {};
  Map<Key, SpecialDishesWidget> specialDishWidgetMap = {};
  final menuNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); 
  bool saveBtnOn = false;
  bool isLoading = false;
  bool isMainDishValid = true;
  bool isSideDishValid = true;
  bool isSpecialDishValid = true;
  MenuDatabaseService serviceMenu = MenuDatabaseService();
  List<String> dishNameList = [];
  List<String> photoList = [];
  List<DishModel> mainDishInList = [];
  List<DishModel> sideDishInList = [];
  List<DishModel> specialDishInList = [];

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

  Future<List<DishModel>> storeMainDishList() async {
    List<DishModel> mainDishes = [];
    for (var widget in mainDishWidgetMap.values) {
      String downloadUrl = await uploadImage(widget.image);
      String dishName = widget.mainDishNameController.text;
      String specialId = widget.specialIdController.text;

      dishNameList.add(dishName);
      photoList.add(downloadUrl);

      mainDishes.add(
        DishModel(
          dishId: mainDishes.length,
          dishSpcId: specialId,
          dishName: dishName,
          dishPhoto: downloadUrl,
          dishType: 'Main',
        ),
      );
    }
    mainDishInList = mainDishes.toList();
    return mainDishInList;
  }

  Future<List<DishModel>> storeSideDishList() async {
    List<DishModel> sideDishes = [];
    for(var widget in sideDishWidgetMap.values){
      String downloadUrl = await uploadImage(widget.image);
      String dishName = widget.sideDishName.text;
      String specialId = widget.specialIdController.text;
      dishNameList.add(dishName);
      photoList.add(downloadUrl);
      sideDishes.add(
        DishModel(
          dishId: sideDishes.length, 
          dishSpcId: specialId,
          dishName: dishName,
          dishPhoto: downloadUrl,
          dishType: 'Side'
        )
      );
    }
    sideDishInList = sideDishes.toList();
    return sideDishInList;
  }

  Future<List<DishModel>> storeSpecialDishList() async {
    List<DishModel> specialDishes = [];
    for(var widget in specialDishWidgetMap.values){
      String downloadUrl = await uploadImage(widget.image);
      String dishName = widget.specialDishName.text;
      String specialId = widget.specialIdController.text;
      dishNameList.add(dishName);
      photoList.add(downloadUrl);
      specialDishes.add(
        DishModel(
          dishId: specialDishes.length, 
          dishSpcId: specialId,
          dishName: dishName,
          dishPhoto: downloadUrl,
          dishType: 'Special'
        )
      );
    }
    specialDishInList = specialDishes.toList();
    return specialDishInList;
  }

  void _addMainDishWidget() {
    Key key = UniqueKey();
    setState(() {
      mainDishWidgetMap[key] = MainDishesWidget(
        onDelete: (key) {
          _removeMainDishWidget(key);
        },
        indexStored: mainDishWidgetMap.length,
        uniqueKey: key,
        mainDishValue: '',
        specialIdValue: '',
        imageUrl: '',
      );
    });
  }
  void _removeMainDishWidget(Key key) {
    setState(() {
      mainDishWidgetMap.remove(key);
    });
  }

  void _addSideDishWidget() {
    Key key = UniqueKey();
    setState(() {
      sideDishWidgetMap[key] = SideDishesWidget(
        onDelete: (key) {
          _removeSideDishWidget(key);
        },
        indexStored: sideDishWidgetMap.length,
        uniqueKey: key,
        sideDishValue: '',
        specialIdValue: '',
        imageUrl: '',
      );
    });
  }
  void _removeSideDishWidget(Key key) {
    setState(() {
      sideDishWidgetMap.remove(key);
    });
  }

  void _addSpecialDishWidget() {
    Key key = UniqueKey();
    setState(() {
      specialDishWidgetMap[key] = SpecialDishesWidget(
        onDelete: (key) {
          _removeSpecialDishWidget(key);
        },
        indexStored: specialDishWidgetMap.length,
        uniqueKey: key,
        specialDishValue: '',
        specialIdValue: '',
        imageUrl: '',
      );
    });
  }
  void _removeSpecialDishWidget(Key key) {
    setState(() {
      specialDishWidgetMap.remove(key);
    });
  }


  Future<void> _uploadData() async{
    mainDishWidgetMap.forEach((key, widget) {
      if (!widget.validate()) {
        isMainDishValid = false;
      }
    });
    sideDishWidgetMap.forEach((key, widget) {
      if (!widget.validate()) {
        isSideDishValid = false;
      }
    });
    specialDishWidgetMap.forEach((key, widget) {
      if (!widget.validate()) {
        isSpecialDishValid = false;
      }
    });

    if(_formKey.currentState!.validate()){
      DateTime now = DateTime.now();
        
      DocumentReference documentReference = await serviceMenu.addMenu(
        MenuModel(
          menuId: '',
          menuName: menuNameController.text.trim(), 
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
          mainDishList: await storeMainDishList(),
          sideDishList: await storeSideDishList(),
          specialDishList: await storeSpecialDishList(),
        )
      );
      
      String docId = documentReference.id;
      MenuModel menuList = MenuModel(
        menuId: docId,
        menuName: menuNameController.text.trim(), 
        createdDate: DateFormat('MMMM dd, yyyy').format(now), 
        mainDishList: await storeMainDishList(),
        sideDishList: await storeSideDishList(),
        specialDishList: await storeSpecialDishList(),
      );

      await serviceMenu.updateMenu(menuList);

      MaterialPageRoute route = MaterialPageRoute(
        builder: (context)=> DisplayMenuCreated(
          menuListSelected: menuList,
        )
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, route);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu created successfully', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.amber,
        )
      );
    }
  }

  void _handleSaveButtonPress()async{
    setState(() {
      isLoading = true;
    });
    await _uploadData(); 

    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Menu List',
          userRole: 'owner',
          onPress: () {
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
                  height: height*1.7,
                  padding: const EdgeInsets.all(5),
                  decoration:BoxDecoration(
                    border:Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Main dishes', 
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 330,
                        color: const Color.fromARGB(255, 255, 196, 175),
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: mainDishWidgetMap.length,
                          itemBuilder: (context, index) {
                            var widget = mainDishWidgetMap.values.toList()[index];
                            return widget;
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                          elevation: 6,
                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                        ),
                        onPressed: () {
                          setState(() {
                            saveBtnOn = true;
                          });
                          _addMainDishWidget();
                        },
                        child: const Text('Add Main Dish', style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Side dishes', 
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 330,
                        color: const Color.fromARGB(255, 255, 196, 175),
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: sideDishWidgetMap.length,
                          itemBuilder: (context, index) {
                            var widget = sideDishWidgetMap.values.toList()[index];
                            return widget;
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                          elevation: 6,
                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                        ),
                        onPressed: () {
                          setState(() {
                            saveBtnOn = true;
                          });
                          _addSideDishWidget();
                        },
                        child: const Text('Add Side Dish', style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Special dishes', 
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 330,
                        color: const Color.fromARGB(255, 255, 196, 175),
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: specialDishWidgetMap.length,
                          itemBuilder: (context, index) {
                            var widget = specialDishWidgetMap.values.toList()[index];
                            return widget;
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                          elevation: 6,
                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                        ),
                        onPressed: () {
                          setState(() {
                            saveBtnOn = true;
                          });
                          _addSpecialDishWidget();
                        },
                        child: const Text('Add special Dish', style: TextStyle(color: Colors.black)),
                      ),
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
                    ? isLoading 
                      ? null 
                      : _handleSaveButtonPress
                    : null,
                    child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black
                        ),
                      ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}