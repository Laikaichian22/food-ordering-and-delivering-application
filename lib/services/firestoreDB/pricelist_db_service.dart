import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';

class PriceListDatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add priceList
  Future<DocumentReference>addPriceList(PriceListModel priceListData) async{
    DocumentReference documentReference = await _db.collection('priceList').add(priceListData.toJason());
    return documentReference;
  }

  //update (WHOLE)priceList
  updatePriceList(PriceListModel priceListData) async{
    await _db.collection('priceList').doc(priceListData.priceListId).update(priceListData.toJason());
  }

  //update created priceList
  Future<void> updateCreatedPriceList(
    String docId,
    String title,
    String desc
  )async{
    await _db.collection('priceList').doc(docId).update({
      'PriceListName' : title,
      'PriceListDescription' : desc
    });
  }

  //delete priceList
  Future<void> deletePriceList(String documentId) async{
    await _db.collection('priceList').doc(documentId).delete();
  }

  //get the selected price list
  Future<PriceListModel?> getPriceListDetails(String id) async{
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db.collection('priceList').doc(id).get();
      if (documentSnapshot.exists) {
        return PriceListModel.fromDocumentSnapshot(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PriceListModel>> retrieveList() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('priceList').get();
    return snapshot.docs.map((snapshot) => PriceListModel.fromDocumentSnapshot(snapshot)).toList();
  }
}