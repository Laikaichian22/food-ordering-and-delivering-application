import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';

class OrderCustDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('order');

  //add COD or Replace Meal Payment method
  Future<DocumentReference>addOrder(OrderCustModel payMethodData) async{
    DocumentReference documentReference = await _db.collection('order').add(payMethodData.toOrderJason());
    return documentReference;
  }

  //(WHOLE) update order
  updateOrder(OrderCustModel orderData) async{
    await _db.collection('order').doc(orderData.id).update(orderData.toOrderJason());
  }

  //update existing order 
  Future<void> updateExistingOrder(
    String documentId,
    String name,
    String destination,
    String remark,
  )async{
    await _db.collection('order').doc(documentId).update({
      'Customer name' : name,
      'Destination' : destination,
      'Remark' : remark
    });
  }

  //Get order in list
  Stream<List<OrderCustModel>> getOrder(){
    return orderCollection.snapshots().map(
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

  //get specific customer's order
  Future<OrderCustModel> getCustOrder(String documentId) async{
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('menu').doc(documentId).get();

      if (snapshot.exists) {
        return OrderCustModel.fromDocumentSnapshot(snapshot);
      }
      else{
        return OrderCustModel.defaults();
      }
    } catch (e) {
      // Handle errors, e.g., print the error
      print('Error fetching menu: $e');
      // You might want to throw an exception or return a default menu in case of an error
      throw Exception('Error fetching menu');
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
      await _db.collection('order').doc(documentId).delete();
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   payMethodPageRoute, 
      //   (route) => false,
      // );
    } 
  }


  
}