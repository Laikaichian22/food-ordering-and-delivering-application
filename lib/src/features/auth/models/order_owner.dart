import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
//import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';

class OrderOwnerModel{
  String? id;
  String? orderName;
  MenuModel? menuChosen;
  String? feedBack;
  String? desc;
  DateTime? startTime;
  DateTime? endTime;
  String? openDate;

  OrderOwnerModel({
    this.orderName,
    this.menuChosen,
    this.feedBack,
    this.desc,
    this.id,
    this.startTime,
    this.endTime,
    this.openDate,
  });

  factory OrderOwnerModel.fromFirestore(Map<String, dynamic> data, String id){
    return OrderOwnerModel(
      id: data['id'] ?? '',
      orderName: data['Order Name'] ?? '',
      feedBack: data['Feedback'] ?? '',
      desc: data['Description'] ?? '',
      startTime: (data['Time start'] as Timestamp?)?.toDate(),
      endTime: (data['Time end'] as Timestamp?)?.toDate(),
      openDate: data['Open date'] ?? '',
      menuChosen: MenuModel.fromMap(data['Menu'] ?? {})
    );
  }

  Map<String, dynamic> toOrderOwnerJason(){
    return{
      'id' : id,
      'Order Name' : orderName,
      'Menu' : menuChosen?.toJason(),
      'Feedback' : feedBack,
      'Description' : desc,
      'Time start' : startTime != null ? Timestamp.fromDate(startTime!) : null,
      'Time end' : endTime != null ? Timestamp.fromDate(endTime!) : null,
      'Open date' : openDate,
    };
  }

  OrderOwnerModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    orderName = doc.data()!['Order Name'],
    menuChosen = doc.data()!['Menu'],
    feedBack = doc.data()!['Feedback description'],
    desc = doc.data()!['Description'],
    startTime = doc.data()!['Start time'],
    endTime = doc.data()!['End time'],
    openDate = doc.data()!['Open date'];
}