import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';

class MenuModel{
  String? menuId;
  String menuName;
  String createdDate;
  List<DishModel> mainDishList;
  List<DishModel> sideDishList;
  List<DishModel> specialDishList;

  MenuModel({
    this.menuId,
    required this.menuName,
    required this.createdDate,
    required this.mainDishList,
    required this.sideDishList,
    required this.specialDishList,
  });


  Map<String, dynamic> toJason(){
    return{
      'c-name': menuName,
      'createdDate' : createdDate,
      'main-dish': mainDishList.map((dish) => dish.toDishJason()).toList(),
      'side-dish': sideDishList.map((dish) => dish.toDishJason()).toList(),
      'special-dish': specialDishList.map((dish) => dish.toDishJason()).toList(),
    };
  }
  MenuModel.fromMap(Map<String, dynamic> menuMap)
  : menuId = menuMap['id'],
    menuName = menuMap['c-name'] ?? '',
    createdDate = menuMap['createdDate'] ?? '',
    mainDishList = (menuMap['main-dish'] as List<dynamic>?)
      ?.map((dish) => DishModel.fromMap(dish as Map<String, dynamic>))
      .toList() ?? [],
    sideDishList = (menuMap['side-dish'] as List<dynamic>?)
      ?.map((dish) => DishModel.fromMap(dish as Map<String, dynamic>))
      .toList() ?? [],
    specialDishList = (menuMap['special-dish'] as List<dynamic>?)
      ?.map((dish) => DishModel.fromMap(dish as Map<String, dynamic>))
      .toList() ?? [];
  

  MenuModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : menuId = doc.id,
    menuName = doc.data()!['c-name'],
    createdDate = doc.data()!['createdDate'],
    mainDishList = List<DishModel>.from(doc.data()!['main-dish'].map(
      (dish) => DishModel.fromMap(Map<String, dynamic>.from(dish))
    )),
    sideDishList = List<DishModel>.from(doc.data()!['side-dish'].map(
      (dish) => DishModel.fromMap(Map<String, dynamic>.from(dish))
    )),
    specialDishList = List<DishModel>.from(doc.data()!['special-dish'].map(
      (dish) => DishModel.fromMap(Map<String, dynamic>.from(dish))
    ));
}