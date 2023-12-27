import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';

class OrderCustDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //when customer place or edit order
  final CollectionReference placeOrderCollection = FirebaseFirestore.instance.collection('cust order');

  //add COD or Replace Meal Payment method
  Future<DocumentReference>addOrder(OrderCustModel orderData) async{
    DocumentReference documentReference = await _db.collection('cust order').add(orderData.toOrderJason());
    return documentReference;
  }

  //(WHOLE) update order
  updateOrder(OrderCustModel orderData) async{
    await _db.collection('cust order').doc(orderData.id).update(orderData.toOrderJason());
  }

  //update existing order 
  Future<void> updateExistingOrder(
    String documentId,
    String name,
    String destination,
    String remark,
    String email,
    String phone
  )async{
    await _db.collection('cust order').doc(documentId).update({
      'custName' : name,
      'Destination' : destination,
      'Remark' : remark,
      'Email' : email,
      'Phone' : phone
    });
  }

  //Get order in list
  Stream<List<OrderCustModel>> getOrder(){
    return placeOrderCollection.snapshots().map(
      (QuerySnapshot snapshot){
        return snapshot.docs.map(
          (DocumentSnapshot doc){
            return OrderCustModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id
            );
          }
        ).toList();
      }
    );
  }

  //get order in list by user id
  Stream<List<OrderCustModel>> getOrderById(String userId){
    return placeOrderCollection
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((QuerySnapshot snapshot){
        return snapshot.docs.map(
        (DocumentSnapshot doc){
            return OrderCustModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id
            );
          }
        ).toList();
      }
    );
  }

  //get specific customer's order
  Future<OrderCustModel?> getCustOrder(String documentId) async{
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('menu').doc(documentId).get();

      if (snapshot.exists) {
        return OrderCustModel.fromDocumentSnapshot(snapshot);
      }
      else{
        return null;
      }
    } catch (e) {
      // You might want to throw an exception or return a default menu in case of an error
      throw Exception('Error fetching menu');
    }
  }

  Future<OrderCustModel?> getCustOrderById(String id) async{
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
      .collection('cust order')
      .where('id', isEqualTo: id)
      .get();
      if (querySnapshot.docs.isNotEmpty) {
        return OrderCustModel.fromFirestore(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      } else {
        return null;
      }
    }catch (e) {
      throw Exception('Error fetching customer order');
    }
  }

  //delete Order placed by customer
  Future<void> deleteCustOrder(String? documentId, BuildContext context) async{
    if (documentId == null || documentId.isEmpty) {
      // Show an alert or return an appropriate response
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Document ID'),
            content: const Text('The document ID is null or empty. Cannot delete.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                  fontSize: 20
                )
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Call the deletePayment function with a valid documentId
      await _db.collection('cust order').doc(documentId).delete();
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   payMethodPageRoute, 
      //   (route) => false,
      // );
    } 
  }

  //when customer place or edit order
  final CollectionReference cancelOrderCollection = FirebaseFirestore.instance.collection('cust order');

  Future<void> cancelOrder(OrderCustModel orderData) async {
    // Add the order to the 'cust cancel order' collection
    await _db.collection('cust cancel order').add(orderData.toOrderJason());

    // Delete the order from the 'cust order' collection
    await _db.collection('cust order').doc(orderData.id).delete();
  }
}