import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel{
  String? id;
  String methodName;
  String? paymentLink;
  String? accNumber;
  String? bankAcc;
  String? qrcode;
  String? desc1;
  String? desc2;
  String? requiredReceipt;
  bool? isSelected;

  PaymentMethodModel({
    this.id,
    required this.methodName,
    this.paymentLink,
    this.accNumber,
    this.bankAcc,
    this.qrcode,
    this.desc1,
    this.desc2,
    this.requiredReceipt,
    this.isSelected = false,
  });

  factory PaymentMethodModel.fromFirestore(Map<String, dynamic> data, String id){
    return PaymentMethodModel(
      methodName: data['Method name'] ?? '', 
      paymentLink: data['Payment link'] ?? '',
      qrcode: data['Qr code'] ?? '',
      desc1: data['Description1'] ?? '',
      desc2: data['Description2'] ?? '',
      bankAcc: data['Bank Account'] ?? '',
      accNumber: data['Account Number'] ?? '',
      requiredReceipt: data['Receipt'] ?? '',
      id: data['id'] ?? '',
    );
  }

  // Convert PaymentMethod object to data for Firestore
  Map<String, dynamic> toPaymentTngJason(){
    return{
      'id' : id,
      'Method name': methodName,
      'Payment link' : paymentLink,
      'Qr code' : qrcode,
      'Description1' : desc1,
      'Description2': desc2,
      'Receipt': requiredReceipt,
    };
  }
  Map<String, dynamic> toPaymentFPXJason(){
    return{
      'id' : id,
      'Method name': methodName,
      'Qr code' : qrcode,
      'Description1' : desc1,
      'Description2': desc2,
      'Bank Account' : bankAcc,
      'Account Number' : accNumber,
      'Receipt': requiredReceipt,
    };
  }
  Map<String, dynamic> toPaymentJason(){
    return{
      'id' : id,
      'Method name': methodName,
      'Description1' : desc1,
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