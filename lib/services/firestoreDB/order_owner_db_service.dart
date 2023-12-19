import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';

class OrderOwnerDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('open order');
  //add order
  addOrder(OrderOwnerModel orderData) async{
    await _db.collection('open order').add(orderData.toOrderOwnerJason());
  }

  //update order
  updateOrder(OrderOwnerModel orderData) async{
    await _db.collection('open order').doc(orderData.id).update(orderData.toOrderOwnerJason());
  }

  //delete order
  Future<void> deleteorder(String documentId) async{
    await _db.collection('open order').doc(documentId).delete();
  }

  Stream<List<OrderOwnerModel>> getOrderMethods(){
    return orderCollection.snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map(
          (DocumentSnapshot doc){
            return OrderOwnerModel.fromFirestore(
              doc.data() as Map<String, dynamic>, 
              doc.id
            );
          }
        ).toList();
      }
    );
  }

  //get specific order
  // Future<OrderOwnerModel> getOrder(String documentId) async{
  //   try{
  //     DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('open order').doc(documentId).get();
  //     if(snapshot.exists){
  //       return OrderOwnerModel.fromDocumentSnapshot(snapshot);
  //     }else{
  //       return OrderOwnerModel.defaults();
  //     }
  //   }catch(e){
  //     print('Error fetching order');
  //     throw Exception('Error fetching menu');
  //   }
  // }
}