import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  //constructor, initialize variables with values
  // OrderModel.fromJason(Map<String, dynamic> json){
  //   id = json['id'];
  //   name = json['name'];
  //   dateTime = json['dateTime'];
  //   destination = json['destination'];
  //   remark = json['remark'];
  //   payAmount = json['payAmount'];
  //   payMethod = json['payMethod'];
  //   orderDetails = json['orderDetails'];
  //   totalPacks = json['totalPacks'];
  // }

  //method that retrun map of values
  Map<String, dynamic> toJason(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['dateTime'] = dateTime;
    data['destination'] = destination;
    data['remark'] = remark;
    data['payAmount'] = payAmount;
    data['payMethod'] = payMethod;
    data['orderDetails'] = orderDetails;
    return data;
  }

  //pass argument of type DocumentSnapshot contain data read from document
  // OrderModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc){
  //   id = doc.id;
  //   name = doc.data()!['name'];
  //   dateTime = doc.data()!['dateTime'];
  //   destination = doc.data()!['destination'];
  //   remark = doc.data()!['remark'];
  //   payAmount = doc.data()!['payAmount'];
  //   payMethod = doc.data()!['payMethod'];
  //   orderDetails = doc.data()!['orderDetails'];
  //   totalPacks = doc.data()!['totalPacks'];
  // }

  // factory OrderModel.fromJason(Map<String, dynamic> json){
  //   final id = json['id'] as String;
  //   final name = json['name'] as String;
  //   final destination = json['destination'] as String;
  //   final remark = json['remark'] as String;
  //   final orderDetails = json['orderDetails'] as String;
  //   final payMethod = json['payMethod'] as String;
  //   final payAmount = json['payAmount'] as Double;
  //   final totalPacks = json['totalPacks'] as Double;
  //   final dateTime = json['dateTime'] as String;
  //   final dt = DateTime.parse(dateTime).toLocal();
  //   return OrderModel(
  //     id: id,
  //     name: name,
  //     destination: destination,
  //     remark: remark,
  //     orderDetails: orderDetails,
  //     payMethod: payMethod,
  //     payAmount: payAmount,
  //     totalPacks: totalPacks,
  //     dateTime: DateFormat('dd:MM:YYYY').format(dt),
  //   );
  // }
  // //to show the change in the value during user interaction
  // OrderModel copyWith({
  //   String? id,
  //   String? dateTime,
  //   String? name,
  //   String? destination,
  //   String? remark,
  //   String? payMethod,
  //   Double? payAmount,
  //   String? orderDetails,
  //   Double? totalPacks,
  // }){
  //   return OrderModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     destination: destination ?? this.destination,
  //     remark: remark ?? this.remark,
  //     orderDetails: orderDetails ?? this.orderDetails,
  //     payMethod: payMethod ?? this.payMethod,
  //     payAmount: payAmount ?? this.payAmount,
  //     totalPacks: totalPacks ?? this.totalPacks,
  //     dateTime: dateTime ?? this.dateTime,
  //   );
  // }
}