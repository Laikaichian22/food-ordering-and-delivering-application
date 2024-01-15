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
  Future<void> updateCODPayment(String documentId, String methodName, String desc1) async {
    await _db.collection('payMethod').doc(documentId).update({
      'Description1': desc1,
      'Method name' : methodName,
    });
  }

  //update certain features of existing tng payment method
  Future<void> updateExistingTngPayment(String documentId, String methodName, String link, String qrCode, String desc1, String desc2, String receiptChoice,)async{
    await _db.collection('payMethod').doc(documentId).update({
      'Payment link': link,
      'Method name' : methodName,
      'Qr code' : qrCode,
      'Description1' : desc1,
      'Description2' : desc2,
      'Receipt' : receiptChoice
    });
  }

  //update certain features of existing fpx payment method
  Future<void> updateExistingFPXPayment(String documentId, String methodName, String bankAcc, String accNum, String qrCode, String desc1, String desc2,String receiptChoice)async{
    await _db.collection('payMethod').doc(documentId).update({
      'Bank Account': bankAcc,
      'Account Number' : accNum,
      'Method name' : methodName,
      'Qr code' : qrCode,
      'Description1' : desc1,
      'Description2' : desc2,
      'Receipt' : receiptChoice
    });
  }

  //update the OpenedStatus to open
  Future<void> updateToOpenedStatus(String docId) async{
    await _db.collection('payMethod').doc(docId).update({
      'OpenedStatus' : 'Yes'
    });
  }

  //update the OpenedStatus to close
  Future<void> updateToClosedStatus(String docId) async{
    await _db.collection('payMethod').doc(docId).update({
      'OpenedStatus' : 'No'
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
      await _db.collection('payMethod').doc(documentId).delete();
      // ignore: use_build_context_synchronously
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

  //fetch list of payment method with open status
  Future<List<PaymentMethodModel>> getOpenPayMethods() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
      .collection('payMethod')
      .where('OpenedStatus', isEqualTo: 'Yes')
      .get();

      // Map the documents to a list of PaymentMethodModel
      List<PaymentMethodModel> openPaymentMethods = snapshot.docs
      .map((doc) => PaymentMethodModel.fromDocumentSnapshot(doc))
      .toList();

      return openPaymentMethods;
    } catch (e) {
      rethrow;
    }
  }

  //fetch the list of payment method
  Future<List<PaymentMethodModel>> retrievePayMethod() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('payMethod').get();
    return snapshot.docs.map((snapshot) => PaymentMethodModel.fromDocumentSnapshot(snapshot)).toList();
  }

  //get the selected payment method
  Future<PaymentMethodModel?> getPayMethodDetails(String id) async{
    try{
      if (id.isEmpty) {
      // Handle the case where id is empty
      return null;
    }
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db.collection('payMethod').doc(id).get();
      if(documentSnapshot.exists){
        return PaymentMethodModel.fromDocumentSnapshot(documentSnapshot);
      }else{
        return null;
      }
    }catch(e){
      debugPrint("Error fetching payment method details: $e");
      rethrow;
    }
  }
}