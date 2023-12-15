import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';

class DishDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add dish
  addDish(DishModel dishData, String? parentId) async {
    await _db.collection('menu').doc(parentId).collection('dish').add(dishData.toDishJason());
  }

  //update dish
  updateDish(DishModel dishData, String parentId) async{
    await _db.collection('menu').doc(parentId).collection('dish').doc(dishData.dishId.toString()).update(dishData.toDishJason());
  }

  //delete dish, 
  Future<void> deleteDish(String docId, String parentId) async{
    await _db.collection('menu').doc(parentId).collection('dish').doc(docId).delete();
  }


}