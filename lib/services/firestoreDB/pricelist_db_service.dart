import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';

class PriceListDatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add menu
  addPriceList(PriceListModel menuData) async{
    await _db.collection('priceList').add(menuData.toJason());
  }

  //update menu
  updatePriceList(PriceListModel menuData) async{
    await _db.collection('priceList').doc(menuData.priceListId).update(menuData.toJason());
  }

  //delete menu
  Future<void> deletePriceList(String documentId) async{
    await _db.collection('priceList').doc(documentId).delete();
  }

  Future<List<PriceListModel>> retrieveList() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('priceList').get();
    return snapshot.docs.map((DocumentSnapshot) => PriceListModel.fromDocumentSnapshot(DocumentSnapshot)).toList();
  }
}