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
  String? openedStatus;
  String? openForDeliveryStatus;

  OrderOwnerModel({
    this.orderName,
    this.menuChosenId,
    this.feedBack,
    this.desc,
    this.id,
    this.startTime,
    this.endTime,
    this.openDate,
    this.openedStatus,
    this.openForDeliveryStatus
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
      openedStatus: data['OpenedStatus'] ?? '',
      menuChosenId: data['Menu'] ?? '',
      openForDeliveryStatus: data['OpenedDeliveryStatus'] ?? ''
    );
  }

  Map<String, dynamic> toOrderOwnerJason(){
    return{
      'id' : id ?? '',
      'Order Name' : orderName ?? '',
      'Menu' : menuChosenId ?? '',
      'Feedback' : feedBack ?? '',
      'Description' : desc ?? '',
      'Time start' : startTime != null ? Timestamp.fromDate(startTime!) : null,
      'Time end' : endTime != null ? Timestamp.fromDate(endTime!) : null,
      'Open date' : openDate,
      'OpenedStatus' : openedStatus,
      'OpenedDeliveryStatus' : openForDeliveryStatus
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
    openedStatus = doc.data()!['OpenedStatus'],
    openForDeliveryStatus = doc.data()!['OpenedDeliveryStatus'],
    openDate = doc.data()!['Open date'];
}