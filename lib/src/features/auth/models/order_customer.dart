import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCustModel{
  String? id;
  String? userid;
  DateTime? dateTime;
  String? custName;
  String? destination;
  String? remark;
  String? payMethod;   
  double? payAmount;    
  String? orderDetails; 
  String? receipt;      
  String? feedback;
  String? phone;
  String? email;
  String? menuOrder;


  OrderCustModel({
    this.id,
    this.userid,
    this.custName,
    this.dateTime,
    this.destination,
    this.remark,
    this.payAmount,
    this.payMethod,
    this.orderDetails,
    this.receipt,
    this.feedback,
    this.email,
    this.phone,
    this.menuOrder
  });

  OrderCustModel.defaults()
  : custName = '';

  factory OrderCustModel.fromFirestore(Map<String, dynamic> data, String id){
    return OrderCustModel(
      id: data['id'] ?? '', 
      userid: data['userId'] ?? '',
      custName: data['Customer custName'] ?? '', 
      dateTime: (data['Date'] as Timestamp?)?.toDate(), 
      destination: data['Destination'] ?? '', 
      remark: data['Remark'] ?? '', 
      payAmount: (data['Pay Amount'] ?? 0.0).toDouble(), 
      payMethod: data['Pay Method'] ?? '', 
      orderDetails: data['Order details'] ?? '',
      receipt: data['Receipt'] ?? '',
      feedback: data['Feedback'] ?? '',
      email: data['Email'] ?? '',
      phone: data['Phone'] ?? '',
      menuOrder: data['Menu order'] ?? ''
    );
  }

  //method that return map of values
  Map<String, dynamic> toOrderJason(){
    return{
      'id' : id,
      'userId' : userid,
      'Customer custName' : custName,
      'Date' : dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'Destination' : destination,
      'Remark' : remark,
      'Pay Amount' : payAmount,
      'Pay Method' : payMethod,
      'Order details' : orderDetails,
      'Receipt' : receipt,
      'Feedback' : feedback,
      'Email' : email,
      'Phone' : phone,
      'Menu order' : menuOrder
    };
  }

  OrderCustModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    userid = doc.data()!['userId'],
    custName = doc.data()!['Customer custName'],
    dateTime = doc.data()!['Date'],
    destination = doc.data()!['Destination'],
    remark = doc.data()!['Remark'],
    payAmount = doc.data()!['Pay Amount'],
    payMethod = doc.data()!['Pay Method'],
    orderDetails = doc.data()!['Order details'],
    receipt = doc.data()!['Receipt'],
    feedback = doc.data()!['Feedback'],
    email = doc.data()!['Email'],
    menuOrder = doc.data()!['Menu order'],
    phone = doc.data()!['Phone'];
    
}