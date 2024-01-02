
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/features/auth/models/user.dart';

class UserDatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void>addUser(UserModel userData) async{
    try {
      // Set the document ID as the userId
      await _db.collection('user').doc(userData.userId).set(userData.toUserJason());
    } catch (e) {
      throw Exception('Error adding user');
    }
  }

  updateUser(UserModel userData) async{
    await _db.collection('user').doc(userData.userId).update(userData.toUserJason());
  }

  Future<UserModel?> getUserDetails(String userId) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('user').doc(userId).get();
      if(snapshot.exists){
        return UserModel.fromDocmentSnapshot(snapshot);
      }else{
        return null;
      }
    }catch(e){
      throw Exception('Error fetching user details');
    }
  }
}