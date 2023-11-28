import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class TestRead extends StatefulWidget {
  const TestRead({super.key});

  @override
  State<TestRead> createState() => _TestReadState();
}

class _TestReadState extends State<TestRead> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userId = AuthService.firebase().currentUser?.id;
    final Stream<DocumentSnapshot> _users = FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Data'),
        backgroundColor: Colors.blue, // Set the app bar color
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _users,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Loading'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          dynamic data = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Full Name: ${data['fullName']}',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              Text(
                'Phone: ${data['phone']}',
                style: TextStyle(color: Colors.orange, fontSize: 20),
              ),
              Text(
                'Email: ${data['email']}',
                style: TextStyle(color: Colors.purple, fontSize: 20),
              ),
            ],
          );
        },
      ),
    );
  }
}

        
      // FutureBuilder<DocumentSnapshot>(
      //   future: users.doc(userId).get(), 
      //   builder: 
      //   (BuildContext context, snapshot) {
      //     if(snapshot.hasError){
      //       return Text('something went wrong');
      //     }
      //     else if(snapshot.hasData && !snapshot.data!.exists){
      //       return Text('Document does not exist');
      //     }
      //     else if(snapshot.connectionState == ConnectionState.done){
      //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
      //       return Text("Full name: ${data['firstName']} ${data['lastName']}");

      //     }
          
      //     return Text('loading');

      //   }
      // ),
 
 

