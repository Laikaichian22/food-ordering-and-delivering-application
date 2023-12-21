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

  //get the selected price list
  Future<PriceListModel?> getPriceListDetails(String id) async{
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db.collection('priceList').doc(id).get();

      if (documentSnapshot.exists) {
        // Convert the document snapshot to a PriceListModel instance
        return PriceListModel.fromDocumentSnapshot(documentSnapshot);
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print("Error fetching price list details: $e");
      // Handle the error appropriately (e.g., log, show an error message)
      throw e;
    }
  }

  Future<List<PriceListModel>> retrieveList() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('priceList').get();
    return snapshot.docs.map((DocumentSnapshot) => PriceListModel.fromDocumentSnapshot(DocumentSnapshot)).toList();
  }
}