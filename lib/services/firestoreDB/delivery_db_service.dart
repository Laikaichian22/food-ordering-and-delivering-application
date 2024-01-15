
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/delivery.dart';

class DeliveryDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentReference>addOrderDeliveryInfo(DeliveryModel deliveryData)async{
    DocumentReference docReference = await _db.collection('delivery').add(deliveryData.toDeliveryJason());
    return docReference;
  }

  //update whole delivery data
  updateDelivery(DeliveryModel deliveryData)async{
    await _db.collection('delivery').doc(deliveryData.docId).update(deliveryData.toDeliveryJason());
  }

  //update the deliveryman cash on hand amount
  Future<void> updateCashOnHandById(String userId, String orderId, double cashOnHand)async{
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await _db
    .collection('delivery')
    .where('deliveryUserId', isEqualTo: userId)
    .where('orderOpenedId', isEqualTo: orderId)
    .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> order in ordersSnapshot.docs) {
      await _db
      .collection('delivery')
      .doc(order.id)
      .update({'cashOnHand': cashOnHand});
    }
  }

  //update the deliveryman cash on hand amount
  Future<void> updateFinalCashOnHandById(String userId, String orderId, double cashOnHand)async{
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await _db
    .collection('delivery')
    .where('deliveryUserId', isEqualTo: userId)
    .where('orderOpenedId', isEqualTo: orderId)
    .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> order in ordersSnapshot.docs) {
      await _db
      .collection('delivery')
      .doc(order.id)
      .update({'finalCashOnHand': cashOnHand});
    }
  }

  //get information of all delivery man
  Stream<List<DeliveryModel>> getDeliveryManInList(){
    return _db.collection('delivery').snapshots().map((QuerySnapshot snapshot){
      return snapshot.docs.map(
        (DocumentSnapshot doc){
          return DeliveryModel.fromFireStore(
            doc.data() as Map<String, dynamic>, doc.id
          );
        }
      ).toList();
    });
  }

  //update delivery status of this delivery man to start
  Future<void> updateDeliveryStatusToStart(String deliveryUserId, String orderOpenedId, DateTime startTime) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('delivery')
      .where('deliveryUserId', isEqualTo: deliveryUserId)
      .where('orderOpenedId', isEqualTo: orderOpenedId)
      .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        if (document['deliveryUserId'] == deliveryUserId && document['orderOpenedId'] == orderOpenedId) {
          await _db.collection('delivery').doc(document.id).update({
            'DeliveryStatus': 'Start',
            'startTime' : startTime
          });
        }
      }
    } catch (e) {
      throw Exception('Error updating delivery status of delivery man');
    }
  }

  //update delivery status of this delivery man to end
  Future<void> updateDeliveryStatusToEnd(String deliveryUserId, String orderOpenedId, DateTime endTime) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('delivery')
      .where('deliveryUserId', isEqualTo: deliveryUserId)
      .where('orderOpenedId', isEqualTo: orderOpenedId)
      .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        if (document['deliveryUserId'] == deliveryUserId && document['orderOpenedId'] == orderOpenedId) {
          await _db.collection('delivery').doc(document.id).update({
            'DeliveryStatus': 'End',
            'endTime' : endTime
          });
        }
      }
    } catch (e) {
      throw Exception('Error updating delivery status of delivery man');
    }
  }

  Future<String?> getDeliveryStatus(String deliveryUserId, String orderOpenedId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('delivery')
      .where('deliveryUserId', isEqualTo: deliveryUserId)
      .where('orderOpenedId', isEqualTo: orderOpenedId)
      .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        if (document['deliveryUserId'] == deliveryUserId && document['orderOpenedId'] == orderOpenedId) {
          return document['DeliveryStatus'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching DeliveryStatus');
    }
  }

  Future<DeliveryModel?> getDeliveryManInfo(String deliveryUserId, String orderOpenedId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('delivery')
      .where('deliveryUserId', isEqualTo: deliveryUserId)
      .where('orderOpenedId', isEqualTo: orderOpenedId)
      .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        if (document['deliveryUserId'] == deliveryUserId &&document['orderOpenedId'] == orderOpenedId) {
          return DeliveryModel.fromFireStore(document.data()!, document.id);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching information of delivery man');
    }
  }
}