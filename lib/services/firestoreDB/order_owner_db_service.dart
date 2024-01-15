import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OrderOwnerDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('owner open_order');
  //add order
  Future<DocumentReference>addOrder(OrderOwnerModel orderData) async{
    DocumentReference documentReference = await _db.collection('owner open_order').add(orderData.toOrderOwnerJason());
    return documentReference;
  }

  //update order
  updateOrder(OrderOwnerModel orderData) async{
    await _db.collection('owner open_order').doc(orderData.id).update(orderData.toOrderOwnerJason());
  }

  //update the ending time
  Future<void> updateOrderEndTime(String orderId, DateTime newEndTime)async{
    await _db.collection('owner open_order').doc(orderId).update({
      'Time end' : newEndTime
    });
  }

  //update order openedStatus to open status
  Future<void> updateOrdertoOpenStatus(String docId)async{
    await _db.collection('owner open_order').doc(docId).update({
      'OpenedStatus' : 'Yes'
    });
  }

  //update order openedStatus to close status
  Future<void> updateOrdertoCloseStatus(String docId)async{
    await _db.collection('owner open_order').doc(docId).update({
      'OpenedStatus' : 'No'
    });
  }

  //update order openedStatus to open status
  Future<void> updatetoOpenDeliveryStatus(String docId)async{
    await _db.collection('owner open_order').doc(docId).update({
      'OpenedDeliveryStatus' : 'Yes'
    });
  }

  //update order openedStatus to close status
  Future<void> updatetoCloseDeliveryStatus(String docId)async{
    await _db.collection('owner open_order').doc(docId).update({
      'OpenedDeliveryStatus' : 'No'
    });
  }

  Future<void> updateOrderName(String orderId, String name)async{
    await _db.collection('owner open_order').doc(orderId).update({
      'Order Name' : name
    });
  }

  //get specific owner's order
  Future<OrderOwnerModel?> getOwnerOrder(String id) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('owner open_order').doc(id).get();
      if(snapshot.exists){
        return OrderOwnerModel.fromDocumentSnapshot(snapshot);
      }else{
        return null;
      }
    }catch(e){
      throw Exception('Error fetching order');
    }
  }

  //fetch list of order with open status for place order by customer
  Future<List<OrderOwnerModel>> getOpenOrderList() async{
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('owner open_order')
      .where('OpenedStatus', isEqualTo: 'Yes').get();

      List<OrderOwnerModel> openedOrderForDelivery = snapshot.docs
      .map((doc) => OrderOwnerModel.fromDocumentSnapshot(doc)).toList();
      return openedOrderForDelivery;    
    }catch(e){
      rethrow;
    }
  } 

  //fetch list of order with open status for delivery
  Future<List<OrderOwnerModel>> getOpenDeliveryOrderList() async{
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('owner open_order')
      .where('OpenedDeliveryStatus', isEqualTo: 'Yes').get();

      List<OrderOwnerModel> openedOrderForDelivery = snapshot.docs
      .map((doc) => OrderOwnerModel.fromDocumentSnapshot(doc)).toList();
      return openedOrderForDelivery;    
    }catch(e){
      rethrow;
    }
  }

  //fetch the only one order that has openedStatus = Yes
  Future<OrderOwnerModel?> getTheOpenedOrder()async{
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('owner open_order')
      .where('OpenedStatus', isEqualTo: 'Yes').get();
      if(snapshot.docs.isNotEmpty){
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        return OrderOwnerModel.fromFirestore(document.data()!, document.id);
      }
      return null;
    }catch(e){
      rethrow;
    }
  }
  
  //fetch the only one order that has openedDeliveryStatus = Yes
  Future<OrderOwnerModel?> getOrderOpenedForDelivery()async{
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('owner open_order').where('OpenedDeliveryStatus', isEqualTo: 'Yes').get();
      if(snapshot.docs.isNotEmpty){
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        return OrderOwnerModel.fromFirestore(document.data()!, document.id);
      }
      return null;
    }catch(e){
      rethrow;
    }
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
      await _db.collection('owner open_order').doc(documentId).delete();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(
        orderAddPageRoute, 
        (route) => false,
      );
    } 
  }

  Stream<List<OrderOwnerModel>> getOrderLists(){
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