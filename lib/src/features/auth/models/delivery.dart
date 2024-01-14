import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel{
  //main information
  String? docId;
  String? deliveryUserId;
  List<String> location;
  String? orderId;  //to differentiate if there are more that one order opened
  String? deliveryStatus;

  DateTime? startTime;
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

    this.startTime,
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

      startTime: (data['startTime'] as Timestamp?)?.toDate(), 
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

      'startTime' : startTime,
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
    startTime = doc.data()!['startTime'];

}