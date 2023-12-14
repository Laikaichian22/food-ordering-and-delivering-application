import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';

class MenuDatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add menu
  addMenu(MenuModel menuData) async{
    await _db.collection('menu').add(menuData.toJason());
  }

  //update menu
  updateMenu(MenuModel menuData) async{
    await _db.collection('menu').doc(menuData.menuId).update(menuData.toJason());
  }

  //delete menu
  Future<void> deleteMenu(String documentId) async{
    await _db.collection('menu').doc(documentId).delete();
  }

  Future<List<MenuModel>> retrieveMenu() async{
    QuerySnapshot<Map<String, dynamic>> snapshot =await _db.collection('menu').get();
    return snapshot.docs.map((DocumentSnapshot) => MenuModel.fromDocumentSnapshot(DocumentSnapshot)).toList();
  }
}