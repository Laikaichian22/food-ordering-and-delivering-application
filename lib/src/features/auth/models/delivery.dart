import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel{
  //main information
  String? docId;
  String? deliveryUserId;
  List<String> location;
  String? orderId;  //to differentiate if there are more that one order opened

  //when sending order
  String? currLocation;
  String? nextLocation;
  DateTime? startTime;
  DateTime? extimatedTime;

  DeliveryModel({
    this.deliveryUserId,
    this.docId,
    this.orderId,
    required this.location,

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

    currLocation = doc.data()!['currLocation'],
    nextLocation = doc.data()!['nextLocation'],
    startTime = doc.data()!['startTime'],
    extimatedTime = doc.data()!['extimatedTime'];
}