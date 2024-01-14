import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel{
  String? id;
  String? methodName;
  String? paymentLink;
  String? accNumber;
  String? bankAcc;
  String? createdDate;
  String? qrcode;
  String? desc1;
  String? desc2;
  String? specId;
  String? requiredReceipt;
  bool? isSelected;
  String? openedStatus;

  PaymentMethodModel({
    this.id,
    this.methodName,
    this.paymentLink,
    this.createdDate,
    this.accNumber,
    this.bankAcc,
    this.qrcode,
    this.desc1,
    this.specId,
    this.desc2,
    this.requiredReceipt,
    this.openedStatus,
    this.isSelected = false,
  });

  factory PaymentMethodModel.fromFirestore(Map<String, dynamic> data, String id){
    return PaymentMethodModel(
      methodName: data['Method name'] ?? '', 
      paymentLink: data['Payment link'] ?? '',
      createdDate: data['createdDate'] ?? '',
      qrcode: data['Qr code'] ?? '',
      desc1: data['Description1'] ?? '',
      desc2: data['Description2'] ?? '',
      bankAcc: data['Bank Account'] ?? '',
      accNumber: data['Account Number'] ?? '',
      specId: data['Special Id'] ?? '',
      requiredReceipt: data['Receipt'] ?? '',
      id: data['id'] ?? '',
      openedStatus: data['OpenedStatus'] ?? ''
    );
  }

  // Convert PaymentMethod object to data for Firestore
  Map<String, dynamic> toPaymentTngJason(){
    return{
      'id' : id ?? '',
      'Method name': methodName ?? '',
      'Payment link' : paymentLink ?? '',
      'createdDate' : createdDate ?? '',
      'Qr code' : qrcode ?? '',
      'Description1' : desc1 ?? '',
      'Special Id' : specId ?? '',
      'Description2': desc2 ?? '',
      'Receipt': requiredReceipt ?? '',
      'OpenedStatus' : openedStatus ?? ''
    };
  }
  Map<String, dynamic> toPaymentFPXJason(){
    return{
      'id' : id ?? '',
      'Method name': methodName ?? '',
      'Qr code' : qrcode ?? '',
      'Description1' : desc1 ?? '',
      'createdDate' : createdDate ?? '',
      'Description2': desc2 ?? '',
      'Special Id' : specId ?? '',
      'Bank Account' : bankAcc ?? '',
      'Account Number' : accNumber ?? '',
      'Receipt': requiredReceipt ?? '',
      'OpenedStatus' : openedStatus ?? ''
    };
  }
  Map<String, dynamic> toPaymentJason(){
    return{
      'id' : id ?? '',
      'Method name': methodName ?? '',
      'Special Id' : specId ?? '',
      'createdDate' : createdDate ?? '',
      'Description1' : desc1 ?? '',
      'OpenedStatus' : openedStatus ?? ''
    };
  }

  PaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  : id = doc.id,
    methodName = doc.data()!['Method name'],
    paymentLink = doc.data()!['Payment link'],
    specId = doc.data()!['Special Id'],
    qrcode = doc.data()!['Qr code'],
    createdDate = doc.data()!['createdDate'],
    desc1 = doc.data()!['Description1'],
    desc2 = doc.data()!['Description2'],
    bankAcc = doc.data()!['Bank Account'],
    openedStatus = doc.data()!['OpenedStatus'],
    accNumber = doc.data()!['Account Number'],
    requiredReceipt = doc.data()!['Receipt'];
  
}