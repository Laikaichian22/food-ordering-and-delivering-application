import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';

class MenuModel{
  String? menuId;
  String menuName;
  String createdDate;
  DishModel dish;

  MenuModel({
    this.menuId,
    required this.menuName,
    required this.createdDate,
    required this.dish,
  });

  Map<String, dynamic> toJason(){
    return{
      'menuName': menuName,
      'createdDate' : createdDate,
      'dish': dish.toDishJason(),
    };
  }

  MenuModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : menuId = doc.id,
    menuName = doc.data()!['menuName'],
    createdDate = doc.data()!['createdDate'],
    dish = DishModel.fromMap(doc.data()!['dish']);
}