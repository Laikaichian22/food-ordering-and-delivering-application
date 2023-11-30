import 'dart:ffi';
import 'package:intl/intl.dart';

class OrderModel{
  String? id;
  String? dateTime;
  String? name;
  String? destination;
  String? remark;
  String? payMethod;
  Double? payAmount;
  String? orderDetails;
  Double? totalPacks;

  OrderModel({
    this.id,
    this.name,
    this.dateTime,
    this.destination,
    this.remark,
    this.payAmount,
    this.payMethod,
    this.orderDetails,
    this.totalPacks,
  });

  factory OrderModel.fromJason(Map<String, dynamic> json){
    final id = json['id'] as String;
    final name = json['name'] as String;
    final destination = json['destination'] as String;
    final remark = json['remark'] as String;
    final orderDetails = json['orderDetails'] as String;
    final payMethod = json['payMethod'] as String;
    final payAmount = json['payAmount'] as Double;
    final totalPacks = json['totalPacks'] as Double;
    final dateTime = json['dateTime'] as String;
    final dt = DateTime.parse(dateTime).toLocal();
    return OrderModel(
      id: id,
      name: name,
      destination: destination,
      remark: remark,
      orderDetails: orderDetails,
      payMethod: payMethod,
      payAmount: payAmount,
      totalPacks: totalPacks,
      dateTime: DateFormat('dd:MM:YYYY').format(dt),
    );
  }
  //to show the change in the value during user interaction
  OrderModel copyWith({
    String? id,
    String? dateTime,
    String? name,
    String? destination,
    String? remark,
    String? payMethod,
    Double? payAmount,
    String? orderDetails,
    Double? totalPacks,
  }){
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      remark: remark ?? this.remark,
      orderDetails: orderDetails ?? this.orderDetails,
      payMethod: payMethod ?? this.payMethod,
      payAmount: payAmount ?? this.payAmount,
      totalPacks: totalPacks ?? this.totalPacks,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}