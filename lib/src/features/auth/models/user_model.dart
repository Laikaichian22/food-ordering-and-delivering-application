import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? userId;
  String? fullName;
  String? phone;
  String? email;
  String? role;
  String? token;
  String? profileImage;
  String? carPlateNum;
  String? orderEmail;
  int? totalDeliveredPackage;
  double? moneyEarned;
  String? orderPhone;
  String? orderLocation;
  String? orderCustName;
  String? orderRemark;

  UserModel({
    this.email,
    this.fullName,
    this.phone,
    this.profileImage,
    this.role,
    this.token,
    this.userId,
    this.carPlateNum,
    this.orderCustName,
    this.orderEmail,
    this.orderLocation,
    this.orderPhone,
    this.totalDeliveredPackage,
    this.moneyEarned,
    this.orderRemark,
  });

  factory UserModel.fromFireStore(Map<String, dynamic> data, String id){
    return UserModel(
      email: data['email'] ?? '',
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      profileImage: data['profileImage'] ?? '',
      token: data['token'] ?? '',
      carPlateNum: data['plateNumber'] ?? '',
      totalDeliveredPackage: data['totalDeliveredPackage'] ?? 0,
      moneyEarned: (data['moneyEarned'] ?? 0.0).toDouble(), 
      orderCustName : data['orderCustName'] ?? '',
      orderEmail: data['orderEmail'] ?? '',
      orderLocation: data['orderLocation'] ?? '',
      orderPhone: data['orderPhone'] ?? '',
      orderRemark: data['orderRemark'] ?? ''
    );
  }

  Map<String, dynamic> toCustUserJason(){
    return{
      'email' : email ?? '',
      'userId' : userId ?? '',
      'fullName' : fullName ?? '',
      'phone' : phone ?? '',
      'role' : role ?? '',
      'profileImage' : profileImage ?? '', 
      'token' : token ?? '',
      'orderCustName' : orderCustName ?? '',
      'orderEmail' : orderEmail ?? '',
      'orderLocation' : orderLocation ?? '',
      'orderPhone' : orderPhone ?? '',
      'orderRemark' : orderRemark ?? ''
    };
  }
  Map<String, dynamic> toOwnerUserJason(){
    return{
      'email' : email ?? '',
      'userId' : userId ?? '',
      'fullName' : fullName ?? '',
      'phone' : phone ?? '',
      'role' : role ?? '',
      'profileImage' : profileImage ?? '', 
      'token' : token ?? '',
    };
  }
  Map<String, dynamic> toDeliveryManUserJason(){
    return{
      'email' : email ?? '',
      'userId' : userId ?? '',
      'fullName' : fullName ?? '',
      'phone' : phone ?? '',
      'role' : role ?? '',
      'profileImage' : profileImage ?? '', 
      'token' : token ?? '',
      'plateNumber' : carPlateNum ?? '',
      'moneyEarned' : moneyEarned ?? 0,
      'totalDeliveredPackage' : totalDeliveredPackage ?? 0,
    };
  }

  UserModel.fromDocmentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : userId = doc.data()!['userId'],
    email = doc.data()!['email'],
    fullName = doc.data()!['fullName'],
    phone = doc.data()!['phone'],
    profileImage = doc.data()!['profileImage'],
    token = doc.data()!['token'],
    carPlateNum = doc.data()!['plateNumber'],
    orderCustName = doc.data()!['orderCustName'], 
    orderEmail = doc.data()!['orderEmail'],
    orderLocation = doc.data()!['orderLocation'],
    orderPhone = doc.data()!['orderPhone'],
    orderRemark = doc.data()!['orderRemark'],
    role = doc.data()!['role'];
}