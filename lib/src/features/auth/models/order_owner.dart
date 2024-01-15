import 'package:cloud_firestore/cloud_firestore.dart';

class OrderOwnerModel{
  String? id;
  String? orderName;
  String? menuChosenId;
  DateTime? startTime;
  DateTime? endTime;
  String? openDate;
  String? openedStatus;
  String? openForDeliveryStatus;

  OrderOwnerModel({
    this.orderName,
    this.menuChosenId,
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
      'Time start' : startTime != null ? Timestamp.fromDate(startTime!) : null,
      'Time end' : endTime != null ? Timestamp.fromDate(endTime!) : null,
      'Open date' : openDate,
      'OpenedStatus' : openedStatus ?? '',
      'OpenedDeliveryStatus' : openForDeliveryStatus ?? ''
    };
  }

  OrderOwnerModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    orderName = doc.data()!['Order Name'],
    menuChosenId = doc.data()!['Menu'],
    startTime = doc.data()!['Start time'],
    endTime = doc.data()!['End time'],
    openedStatus = doc.data()!['OpenedStatus'],
    openForDeliveryStatus = doc.data()!['OpenedDeliveryStatus'],
    openDate = doc.data()!['Open date'];
}