import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OrderOwnerDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('open order');
  //add order
  Future<DocumentReference>addOrder(OrderOwnerModel orderData) async{
    DocumentReference documentReference = await _db.collection('open order').add(orderData.toOrderOwnerJason());
    return documentReference;
  }

  //update order
  updateOrder(OrderOwnerModel orderData) async{
    await _db.collection('open order').doc(orderData.id).update(orderData.toOrderOwnerJason());
  }

  //delete order
  Future<void> deleteOrder(String? documentId, BuildContext context) async{
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
      await _db.collection('open order').doc(documentId).delete();
      Navigator.of(context).pushNamedAndRemoveUntil(
        orderAddPageRoute, 
        (route) => false,
      );
    } 
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

}