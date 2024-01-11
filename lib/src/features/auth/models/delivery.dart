import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel{
  //main information
  String? docId;
  String? deliveryUserId;
  List<String> location;
  String? orderId;  //to differentiate if there are more that one order opened
  String? deliveryStatus;
  //when sending order
  String? currLocation;
  String? nextLocation;
  DateTime? startTime;
  DateTime? extimatedTime;
  double? cashOnHand;
  double? finalCashOnHand;

  DeliveryModel({
    this.deliveryUserId,
    this.docId,
    this.orderId,
    required this.location,
    this.deliveryStatus,
    this.cashOnHand,
    this.finalCashOnHand,

    this.currLocation,
    this.nextLocation,
    this.startTime,
    this.extimatedTime,
  });

  factory DeliveryModel.fromFireStore(Map<String,dynamic> data, String id){
    List<String> locationList = (data['location'] as List<dynamic>)
    .map((dynamic item) => item.toString())
    .toList();

    return DeliveryModel(
      deliveryUserId: data['deliveryUserId'] ?? '',
      docId: data['docId'] ?? '',
      location: locationList,
      orderId: data['orderOpenedId'] ?? '',
      deliveryStatus: data['DeliveryStatus'] ?? '',
      cashOnHand: (data['cashOnHand'] ?? 0.0).toDouble(),
      finalCashOnHand: (data['finalCashOnHand'] ?? 0.0).toDouble(),

      currLocation: data['currLocation'] ?? '',
      nextLocation: data['nextLocation'] ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate(), 
      extimatedTime: (data['extimatedTime'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toDeliveryJason(){
    return{
      'deliveryUserId' : deliveryUserId ?? '',
      'docId' : docId ?? '',
      'location': location,
      'orderOpenedId' : orderId ?? '',
      'DeliveryStatus' : deliveryStatus ?? '',
      'cashOnHand' : cashOnHand ?? 0,
      'finalCashOnHand' : finalCashOnHand??0,

      'currLocation' : currLocation ?? '',
      'nextLocation' : nextLocation ?? '',
      'startTime' : startTime,
      'extimatedTime' : extimatedTime,
    };
  }

  DeliveryModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : docId = doc.id,
    deliveryUserId = doc.data()!['deliveryUserId'],
    location = (doc.data()!['location'] as List<String>),
    orderId = doc.data()!['orderOpenedId'],
    deliveryStatus = doc.data()!['DeliveryStatus'],
    cashOnHand = (doc.data()!['cashOnHand'] as num?)?.toDouble(),
    finalCashOnHand = (doc.data()!['finalCashOnHand'] as num?)?.toDouble(),

    currLocation = doc.data()!['currLocation'],
    nextLocation = doc.data()!['nextLocation'],
    startTime = doc.data()!['startTime'],
    extimatedTime = doc.data()!['extimatedTime'];
}