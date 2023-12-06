import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel{
  String menuName;
  String? menuId;
  String dishName;
  String createdDate;
  String imageOfDish;

  MenuModel({
    required this.menuName,
    this.menuId,
    required this.dishName,
    required this.createdDate,
    required this.imageOfDish,
  });

  Map<String, dynamic> toJason(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuName'] = menuName;
    data['dishName'] = dishName;
    data['createdDate'] = createdDate;
    data['imageOfDish'] = imageOfDish;
    return data;
  }

  MenuModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : menuId = doc.id,
    menuName = doc.data()!['menuName'],
    dishName = doc.data()!['dishName'],
    createdDate = doc.data()!['createdDate'],
    imageOfDish = doc.data()!['PriceListName'];
}