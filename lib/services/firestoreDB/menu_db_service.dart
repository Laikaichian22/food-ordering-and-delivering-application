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

  //get specific menu
  Future<MenuModel?> getMenu(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('menu').doc(documentId).get();

      if (snapshot.exists) {
        return MenuModel.fromDocumentSnapshot(snapshot);
      }
      else{
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching menu');
    }
  }

  //fetch the list of menu
  Future<List<MenuModel>> retrieveMenu() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('menu').get();
    return snapshot.docs.map((snapshot) => MenuModel.fromDocumentSnapshot(snapshot)).toList();
  }
}