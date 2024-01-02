import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel{
  String? docId;
  String? deliveryManName;
  String? userId;
  String? phone;
  String? platNum;
  String? currLocation;
  String? nextLocation;
  DateTime? startTime;
  DateTime? extimatedTime;
  String? messageSent;
  

  DeliveryModel({
    this.platNum,
    this.currLocation,
    this.nextLocation,
    this.startTime,
    this.extimatedTime,
    this.messageSent,
    this.deliveryManName,
    this.userId,
    this.phone,
    this.docId,
  });

  factory DeliveryModel.fromFireStore(Map<String,dynamic> data, String id){
    return DeliveryModel(
      userId: data['userId'] ?? '',
      platNum: data['platNumber'] ?? '',
      currLocation: data['currLocation'] ?? '',
      nextLocation: data['nexrLocation'] ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate(), 
      extimatedTime: (data['extimatedTime'] as Timestamp?)?.toDate(),
      messageSent: data['messageSent'] ?? '',
      deliveryManName: data['deliveryMan_Name'] ?? '',
      phone: data['phone'] ?? '',
      docId: data['docId'] ?? '',
    );
  }

  Map<String, dynamic> toDeliveryJason(){
    return{
      'platNumber' : platNum,
      'currLocation' : currLocation,
      'nextLocation' : nextLocation,
      'startTime' : startTime,
      'extimatedTime' : extimatedTime,
      'messageSent' : messageSent,
      'deliveryMan_Name' : deliveryManName,
      'phone' : phone,
      'userId' : userId,
      'docId' : docId
    };
  }

  DeliveryModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : docId = doc.id,
    userId = doc.data()!['userId'],
    platNum = doc.data()!['platNumber'],
    currLocation = doc.data()!['currLocation'],
    nextLocation = doc.data()!['nextLocation'],
    startTime = doc.data()!['startTime'],
    extimatedTime = doc.data()!['extimatedTime'],
    messageSent = doc.data()!['messageSent'],
    phone = doc.data()!['phone'],
    deliveryManName = doc.data()!['deliveryMan_Name'];
  

  // DeliveryModel.fromMap(Map<String, dynamic> deliveryMap)
  // : platNum = deliveryMap['platNumber'],
  //   currLocation = deliveryMap['currLocation'],
  //   nextLocation = deliveryMap['nextLocation'],
  //   startTime = deliveryMap['startTime'],
  //   extimatedTime = deliveryMap['extimatedTime'],
  //   phone = deliveryMap['phone'],
  //   userId = deliveryMap['userId'],
  //   deliveryManName = deliveryMap['deliveryMan_Name'],
  //   docId = deliveryMap['docId'],
  //   messageSent = deliveryMap['messageSent'];


}