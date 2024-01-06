import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCustModel{
  String? id;
  String? userid;
  DateTime? dateTime;
  String? custName;
  String? destination;
  String? remark;
  String? payMethod;   
  double? payAmount;    
  String? orderDetails; 
  String? receipt;      
  String? feedback;
  String? phone;
  String? email;
  String? menuOrderName;
  String? menuOrderID;
  String? delivered;
  String? paid;
  bool? isSelected;
  String? isCollected;
  String? deliveryManId;
  String? deliveryStatus;
  String? orderDeliveredImage;

  OrderCustModel({
    this.id,
    this.userid,
    this.custName,
    this.dateTime,
    this.destination,
    this.remark,
    this.payAmount,
    this.payMethod,
    this.orderDetails,
    this.receipt,
    this.feedback,
    this.email,
    this.phone,
    this.menuOrderName,
    this.menuOrderID,
    this.delivered,
    this.paid,
    this.deliveryStatus,
    this.isSelected = false,
    this.orderDeliveredImage,
    this.isCollected,
    this.deliveryManId,
  });

  factory OrderCustModel.fromFirestore(Map<String, dynamic> data, String id){
    return OrderCustModel(
      id: data['id'] ?? '', 
      userid: data['userId'] ?? '',
      custName: data['custName'] ?? '', 
      dateTime: (data['Date'] as Timestamp?)?.toDate(), 
      destination: data['Destination'] ?? '', 
      remark: data['Remark'] ?? '', 
      payAmount: (data['Pay Amount'] ?? 0.0).toDouble(), 
      payMethod: data['Pay Method'] ?? '', 
      orderDetails: data['Order details'] ?? '',
      receipt: data['Receipt'] ?? '',
      feedback: data['Feedback'] ?? '',
      email: data['Email'] ?? '',
      phone: data['Phone'] ?? '',
      menuOrderName: data['Menu_order name'] ?? '',
      menuOrderID: data['Menu_orderId'] ?? '',
      delivered: data['Delivered'] ?? '',
      paid: data['Payment Status'] ?? '',
      deliveryStatus: data['DeliveryStatus'] ?? '',
      orderDeliveredImage: data['Delivered order image'] ?? '',
      isCollected: data['isCollected'] ?? '',
      deliveryManId: data['DeliveryManId'] ?? '',
    );
  }

  //method that return map of values
  Map<String, dynamic> toOrderJason(){
    return{
      'id' : id,
      'userId' : userid,
      'custName' : custName ?? '',
      'Date' : dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'Destination' : destination ?? '',
      'Remark' : remark ?? '',
      'Pay Amount' : payAmount ?? '',
      'Pay Method' : payMethod ?? '',
      'Order details' : orderDetails ?? '',
      'Receipt' : receipt ?? '',
      'Feedback' : feedback ?? '',
      'Email' : email ?? '',
      'Phone' : phone ?? '',
      'DeliveryManId' : deliveryManId ?? '',
      'Menu_order name' : menuOrderName ?? '',
      'Menu_orderId' : menuOrderID ?? '',
      'Delivered' : delivered ?? '',
      'Payment Status' : paid ?? '',
      'DeliveryStatus' : deliveryStatus ?? '',
      'Delivered order image' : orderDeliveredImage ?? '',
      'isCollected' : isCollected ?? ''
    };
  }

  OrderCustModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    userid = doc.data()!['userId'],
    custName = doc.data()!['custName'],
    dateTime = doc.data()!['Date'],
    destination = doc.data()!['Destination'],
    remark = doc.data()!['Remark'],
    payAmount = doc.data()!['Pay Amount'],
    payMethod = doc.data()!['Pay Method'],
    orderDetails = doc.data()!['Order details'],
    receipt = doc.data()!['Receipt'],
    feedback = doc.data()!['Feedback'],
    email = doc.data()!['Email'],
    menuOrderName = doc.data()!['Menu_order name'],
    menuOrderID = doc.data()!['Menu_orderId'],
    delivered = doc.data()!['Delivered'],
    paid = doc.data()!['Payment Status'],
    deliveryStatus = doc.data()!['DeliveryStatus'],
    orderDeliveredImage = doc.data()!['Delivered order image'],
    isCollected = doc.data()!['isCollected'],
    deliveryManId = doc.data()!['DeliveryManId'],
    phone = doc.data()!['Phone'];
    
}