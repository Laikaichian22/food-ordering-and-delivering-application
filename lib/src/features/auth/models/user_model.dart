import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? userId;
  String? fullName;
  String? phone;
  String? email;
  String? role;
  String? token;
  String? profileImage;

  UserModel({
    this.email,
    this.fullName,
    this.phone,
    this.profileImage,
    this.role,
    this.token,
    this.userId,
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
    );
  }

  Map<String, dynamic> toUserJason(){
    return{
      'email' : email,
      'userId' : userId,
      'fullName' : fullName,
      'phone' : phone,
      'role' : role,
      'profileImage' : profileImage,
      'token' : token,
    };
  }

  UserModel.fromDocmentSnapshot(DocumentSnapshot <Map<String, dynamic>> doc)
  : userId = doc.data()!['userId'],
    email = doc.data()!['email'],
    fullName = doc.data()!['fullName'],
    phone = doc.data()!['phone'],
    profileImage = doc.data()!['profileImage'],
    token = doc.data()!['token'],
    role = doc.data()!['role'];
}