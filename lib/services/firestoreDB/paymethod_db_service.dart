import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';

class PayMethodDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference paymentMethodCollection = FirebaseFirestore.instance.collection('payMethod');
  //add tng method
  addTng(PaymentMethodModel payMethodData) async{
    await _db.collection('payMethod').add(payMethodData.toTngJason());
  }

  //update tng method
  updateTng(PaymentMethodModel payMethodData) async{
    await _db.collection('payMethod').doc(payMethodData.id).update(payMethodData.toTngJason());
  }

  //delete tng
  Future<void> deleteTng(String documentId) async{
    await _db.collection('payMethod').doc(documentId).delete();
  }

  //Get payment method
  Stream<List<PaymentMethodModel>> getPaymentMethods(){
    return paymentMethodCollection.snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map(
          (DocumentSnapshot doc){
            return PaymentMethodModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id
            );
          }
        ).toList();
      }
    );
  }
  //fetch the list of payment method
  Future<List<PaymentMethodModel>> retrieveMenu() async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('payMethod').get();
    return snapshot.docs.map((DocumentSnapshot) => PaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot)).toList();
  }
}