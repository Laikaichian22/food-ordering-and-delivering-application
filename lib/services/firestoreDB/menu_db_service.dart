import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';

class MenuDatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add menu
  Future<DocumentReference>addMenu(MenuModel menuData) async{
    DocumentReference documentReference = await _db.collection('menu').add(menuData.toJason());
    return documentReference;
  }

  //update menu
  updateMenu(MenuModel menuData) async{
    await _db.collection('menu').doc(menuData.menuId).update(menuData.toJason());
  }

  //update existing menu
  Future<void> updateExistingMenu(MenuModel updatedMenu) async {
    try {
      await _db.collection('menu').doc(updatedMenu.menuId).update(updatedMenu.toJason());
    } catch (e) {
      throw Exception('Error updating menu: $e');
    }
  }

  //delete menu
  Future<void> deleteMenu(String documentId) async{
    await _db.collection('menu').doc(documentId).delete();
  }

  //update the open status
  Future<void> updateToOpenedStatus(String docId)async{
    await _db.collection('menu').doc(docId).update({
      'OpenStatus' : 'Yes'
    });
  }

  //update the close status
  Future<void> updateToClosedStatus(String docId)async{
    await _db.collection('menu').doc(docId).update({
      'OpenStatus' : 'No'
    });
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

  //fetch the list of menu
  Stream<List<MenuModel>> retrieveMenuStream() {
    return _db.collection('menu').snapshots().map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((doc) => MenuModel.fromDocumentSnapshot(doc)).toList();
    });
  }
}