import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCustModel{
  String? id;
  DateTime? dateTime;
  String? custName;
  String? destination;
  String? remark;
  String? payMethod;    //store the id of the selected payment method
  double? payAmount;    //in RM 
  String? orderDetails; //store the special Id of the dishes????
  String? receipt;      //store the image url of receipt
  String? feedback;


  OrderCustModel({
    this.id,
    this.custName,
    this.dateTime,
    this.destination,
    this.remark,
    this.payAmount,
    this.payMethod,
    this.orderDetails,
    this.receipt,
    this.feedback,
  });

  OrderCustModel.defaults()
  : custName = '';

  factory OrderCustModel.fromFirestore(Map<String, dynamic> data, String id){
    return OrderCustModel(
      id: data['id'] ?? '', 
      custName: data['Customer custName'] ?? '', 
      dateTime: (data['Date'] as Timestamp?)?.toDate(), 
      destination: data['Destination'] ?? '', 
      remark: data['Remark'] ?? '', 
      payAmount: data['Pay Amount'] ?? '', 
      payMethod: data['Pay Method'] ?? '', 
      orderDetails: data['Order details'] ?? '',
      receipt: data['Receipt'] ?? '',
      feedback: data['Feedback'] ?? '',
    );
  }

  //method that return map of values
  Map<String, dynamic> toOrderJason(){
    return{
      'id' : id,
      'Customer custName' : custName,
      'Date' : dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'Destination' : destination,
      'Remark' : remark,
      'Pay Amount' : payAmount,
      'Pay Method' : payMethod,
      'Order details' : orderDetails,
      'Receipt' : receipt,
      'Feedback' : feedback
    };
  }

  OrderCustModel.fromDocumentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : id = doc.id,
    custName = doc.data()!['Customer custName'],
    dateTime = doc.data()!['Date'],
    destination = doc.data()!['Destination'],
    remark = doc.data()!['Remark'],
    payAmount = doc.data()!['Pay Amount'],
    payMethod = doc.data()!['Pay Method'],
    orderDetails = doc.data()!['Order details'],
    receipt = doc.data()!['Receipt'],
    feedback = doc.data()!['Feedback'];
    
}