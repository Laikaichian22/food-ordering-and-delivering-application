import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';

class UserDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void>addUser(UserModel userData) async{
    try {
      await _db.collection('user').doc(userData.userId).set(userData.toUserJason());
    } catch (e) {
      throw Exception('Error adding user');
    }
  }

  updateUser(UserModel userData) async{
    await _db.collection('user').doc(userData.userId).update(userData.toUserJason());
  }

  //update user by userId
  Future<void> updateDeliveryManInfo(String userId, String name, String phone, String platNum)async{
    await _db.collection('user').doc(userId).update({
      'fullName' : name,
      'phone' : phone,
      'plateNumber' : platNum
    });
  }

  //update information when user press on 'remember me' button
  Future<void> updateCustOrderInfor(String userId, String custName, String email, String phone, String location, String remark)async{
    await _db.collection('user').doc(userId).update({
      'orderCustName' : custName,
      'orderEmail' : email,
      'orderLocation' : location,
      'orderPhone' : phone,
      'orderRemark' : remark
    });
  }

  //get business owner information
  Future<UserModel?> getBusinessOwnerData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
      .collection('user')
      .where('role', isEqualTo: 'Business owner')
      .limit(1) // Assuming there's only one business owner
      .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document found (assuming there's only one business owner)
        return UserModel.fromFireStore(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      } else {
        return null; // No business owner found
      }
    } catch (e) {
      throw Exception('Error fetching business owner data');
    }
  }

  //get list of deliveryMan
  Stream<List<UserModel>> getDeliveryManList(){
    return _db.collection('user')
    .where('role', isEqualTo: 'Delivery man')
    .snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map(
          (DocumentSnapshot doc){
            return UserModel.fromFireStore(
              doc.data() as Map<String, dynamic>, doc.id
            );
          }
        ).toList();
    });
  }

  //get user tokens by userid
  Future<UserModel?> getUsertokens(String userId) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('user').doc(userId).get();
      if(snapshot.exists){
        return UserModel.fromDocmentSnapshot(snapshot);
      }else{
        return null;
      }
    }catch(e){
      throw Exception('Error fetching user tokens');
    }
  }

  //read existing user email
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String email) async {
    try {
      return await _db
      .collection('user')
      .where('email', isEqualTo: email)
      .get();
    } catch (e) {
      throw Exception('Error getting user by email');
    }
  }

  Future<UserModel?> getUserDataByUserId(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('user').doc(userId).get();
      if (snapshot.exists) {
        return UserModel.fromFireStore(snapshot.data()!, snapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching user data');
    }
  }

  //get list of customer's token
  Future<List<String>> getCustomerToken() async{
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
      .collection('user')
      .where('role', isEqualTo: 'Customer')
      .get();

      List<String> customerTokens = querySnapshot.docs
      .map((doc) => doc['token'] as String?)
      .where((token) => token != null && token.isNotEmpty)
      .map((token) => token!)
      .toList();

      return customerTokens;
    } catch (e) {
      throw Exception('Error fetching customer tokens');
    }
  }

  //get user data by userId
  Future<UserModel?> getUserDataById(String userId) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('user').doc(userId).get();
      if(snapshot.exists){
        return UserModel.fromFireStore(snapshot.data()!, snapshot.id);
      }else{
        return null;
      }
    }catch(e){
      throw Exception('Error fetching customer data');
    }
  }

  //get list of specific customers' token
  Future<List<String>> getCustomersTokenById(List<String> customerIds) async {
    
    List<String> tokens = [];
    for (String userId in customerIds) {
      try {
        UserModel? userData = await getUserDataById(userId);
        if (userData?.token != null) {
          tokens.add(userData!.token!);
        }
      } catch (e) {
        debugPrint('Error fetching user data for ID: $userId - $e');
      }
    }
    return tokens;
  }

  //get list of deliveryman's token
  Future<List<String>> getDeliveryManToken() async{
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
      .collection('user')
      .where('role', isEqualTo: 'Delivery man')
      .get();

      List<String> customerTokens = querySnapshot.docs
      .map((doc) => doc['token'] as String?)
      .where((token) => token != null && token.isNotEmpty)
      .map((token) => token!)
      .toList();

      return customerTokens;
    } catch (e) {
      throw Exception('Error fetching deliveryman tokens');
    }
  }
}
