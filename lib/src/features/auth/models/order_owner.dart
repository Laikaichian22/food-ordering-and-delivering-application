import 'package:cloud_firestore/cloud_firestore.dart';

class OrderOwnerModel{
  String? id;
  String? orderName;
  String? menuChosenId;
  String? feedBack;
  String? desc;
  DateTime? startTime;
  DateTime? endTime;
  String? openDate;

  OrderOwnerModel({
    this.orderName,
    this.menuChosenId,
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
      menuChosenId: data['Menu'] ?? '',
    );
  }

  Map<String, dynamic> toOrderOwnerJason(){
    return{
      'id' : id,
      'Order Name' : orderName,
      'Menu' : menuChosenId,
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
    menuChosenId = doc.data()!['Menu'],
    feedBack = doc.data()!['Feedback description'],
    desc = doc.data()!['Description'],
    startTime = doc.data()!['Start time'],
    endTime = doc.data()!['End time'],
    openDate = doc.data()!['Open date'];
}