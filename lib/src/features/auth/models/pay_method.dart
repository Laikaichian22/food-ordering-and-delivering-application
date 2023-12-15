import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel{
  String? id;
  String methodName;
  String? paymentLink;
  String? qrcode;
  String? desc1;
  String? desc2;

  PaymentMethodModel({
    this.id,
    required this.methodName,
    this.paymentLink,
    this.qrcode,
    this.desc1,
  });

  factory PaymentMethodModel.fromFirestore(Map<String, dynamic> data, String id){
    return PaymentMethodModel(
      methodName: data['Method name'] ?? '', 
    );
  }

  // Convert PaymentMethod object to data for Firestore
  Map<String, dynamic> toTngJason(){
    return{
      'Method name': methodName,
      'Payment link' : paymentLink,
      'Qr code' : qrcode,
      'Description1' : desc1,
      'Description2': desc2
    };
  }

  PaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  : id = doc.id,
    methodName = doc.data()!['Method name'],
    paymentLink = doc.data()!['Payment link'],
    qrcode = doc.data()!['Qr code'],
    desc1 = doc.data()!['Description1'],
    desc2 = doc.data()!['Description2'];
  

}