import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  String id;
  String dateTime;
  String name;
  String destination;
  String remark;
  String payMethod;
  double payAmount;
  String orderDetails;

  OrderModel({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.destination,
    required this.remark,
    required this.payAmount,
    required this.payMethod,
    required this.orderDetails,

  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id){
    return OrderModel(
      id: data['id'] ?? '', 
      name: data['Customer name'] ?? '', 
      dateTime: data['Date'] ?? '', 
      destination: data['Destination'] ?? '', 
      remark: data['Remark'] ?? '', 
      payAmount: data['Pay Amount'] ?? '', 
      payMethod: data['Pay Method'] ?? '', 
      orderDetails: data['Order details'] ?? '',
    );
  }

  //method that return map of values
  Map<String, dynamic> toOrderJason(){
    return{
      'id' : id,
      'Customer name' : name,
      'Date' : dateTime,
      'Destination' : destination,
      'Remark' : remark,
      'Pay Amount' : payAmount,
      'Pay Method' : payMethod,
      'Order details' : orderDetails,
    };
  }

  OrderModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    name = doc.data()!['Customer name'],
    dateTime = doc.data()!['Date'],
    destination = doc.data()!['Destination'],
    remark = doc.data()!['Remark'],
    payAmount = doc.data()!['Pay Amount'],
    payMethod = doc.data()!['Pay Method'],
    orderDetails = doc.data()!['Order details'];

}