import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PayMethodDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference paymentMethodCollection = FirebaseFirestore.instance.collection('payMethod');
  
  //add COD or Replace Meal Payment method
  Future<DocumentReference>addPayment(PaymentMethodModel payMethodData) async{
    DocumentReference documentReference = await _db.collection('payMethod').add(payMethodData.toPaymentJason());
    return documentReference;
  }


  //add Tng Payment method
  Future<DocumentReference>addTngPayment(PaymentMethodModel payMethodData) async{
    DocumentReference documentReference = await _db.collection('payMethod').add(payMethodData.toPaymentTngJason());
    return documentReference;
  }


  //add Online Banking Payment method
  Future<DocumentReference>addFPXPayment(PaymentMethodModel payMethodData) async{
    DocumentReference documentReference = await _db.collection('payMethod').add(payMethodData.toPaymentFPXJason());
    return documentReference;
  }


  //(WHOLE) update Tng Payment method
  updateTngPayment(PaymentMethodModel payMethodData) async{
    await _db.collection('payMethod').doc(payMethodData.id).update(payMethodData.toPaymentTngJason());
  }
  //(WHOLE) update Online Banking Payment method
  updateFPXPayment(PaymentMethodModel payMethodData) async{
    await _db.collection('payMethod').doc(payMethodData.id).update(payMethodData.toPaymentFPXJason());
  }
  //(WHOLE) update COD or Replace Meal Payment method
  updatePayment(PaymentMethodModel payMethodData) async{
    await _db.collection('payMethod').doc(payMethodData.id).update(payMethodData.toPaymentJason());
  }

  // update COD or Replace Meal Payment method's desc1 only
  Future<void> updateReplaceMealOrCODPaymentDesc1(String documentId, String desc1) async {
    await _db.collection('payMethod').doc(documentId).update({
      'desc1': desc1,
    });
  }

  //update certain features of existing tng payment method
  Future<void> updateExistingTngPayment(
    String documentId, 
    String link,
    String qrCode,
    String desc1,
    String desc2,
    String receiptChoice,
  )async{
    await _db.collection('payMethod').doc(documentId).update({
      'Payment link': link,
      'Qr code' : qrCode,
      'Description1' : desc1,
      'Description2' : desc2,
      'Receipt' : receiptChoice
    });
  }

  //update certain features of existing fpx payment method
  Future<void> updateExistingFPXPayment(
    String documentId, 
    String bankAcc,
    String accNum,
    String qrCode,
    String desc1,
    String desc2,
    String receiptChoice,
  )async{
    await _db.collection('payMethod').doc(documentId).update({
      'Bank Account': bankAcc,
      'Account Number' : accNum,
      'Qr code' : qrCode,
      'Description1' : desc1,
      'Description2' : desc2,
      'Receipt' : receiptChoice
    });
  }


  //delete Payment
  Future<void> deletePayment(String? documentId, BuildContext context) async{
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
      await _db.collection('payMethod').doc(documentId).delete();
      Navigator.of(context).pushNamedAndRemoveUntil(
        payMethodPageRoute, 
        (route) => false,
      );
    } 
  }

  //Get payment method in list type
  Stream<List<PaymentMethodModel>> getPaymentMethods(){
    return paymentMethodCollection.snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map(
          (DocumentSnapshot doc){
            return PaymentMethodModel.fromFirestore(
              doc.data() as Map<String, dynamic>, 
              doc.id
            );
          }
        ).toList();
      }
    );
  }

  //fetch the list of payment method
  Future<List<PaymentMethodModel>> retrievePayMethod() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('payMethod').get();
    return snapshot.docs.map((DocumentSnapshot) => PaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot)).toList();
  }

  //get the selected payment method
  Future<PaymentMethodModel?> getPayMethodDetails(String id) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db.collection('payMethod').doc(id).get();
      if(documentSnapshot.exists){
        return PaymentMethodModel.fromDocumentSnapshot(documentSnapshot);
      }else{
        return null;
      }
    }catch(e){
      print("Error fetching payment method details: $e");
      // Handle the error appropriately (e.g., log, show an error message)
      throw e;
    }

  }
}