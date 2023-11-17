
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:path/path.dart';

class testRead extends StatefulWidget {
  const testRead({super.key});

  @override
  State<testRead> createState() => _testReadState();
}

class _testReadState extends State<testRead> {

  

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userId = AuthService.firebase().currentUser?.id;
    final Stream<DocumentSnapshot> _users = FirebaseFirestore
    .instance
    .collection('users').
    doc(userId).
    snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('read data'),
      ),
      body:
        StreamBuilder<DocumentSnapshot>(
          stream: _users, 
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData){
              return Text('Loading');
            }else if(snapshot.hasError){
              return Text('Error');
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            dynamic data = snapshot.data;
            return Column(
              children: [
                Text(data['fullName']),
                Text(data['phone']),
                Text(data['email']),
              ],
            );
          }
        )
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
    );
    
  }
}

