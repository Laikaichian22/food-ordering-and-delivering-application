import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/save_cancel_btn.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var size, heightMax, widthMax;
  final currentUser = AuthService.firebase().currentUser;

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              custProfileRoute, 
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.arrow_back_outlined, 
            color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.topCenter,
                child: const CircleAvatar(
                  radius: 95,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://p5.itc.cn/images01/20230925/e78d0c5543304b0cbd9c3e89ae033c24.png'),
                    radius: 90,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: "LAI KAI CHIAN",
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        initialValue: "abc@gmail.com", 
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        initialValue: "012-34567890",
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          EditProfileButton(
                            color: const Color.fromARGB(255, 205, 205, 205),
                            text: 'Cancel',
                            onPress: (){
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                editProfileRoute, 
                                (route) => false,
                              );
                            }
                          ),
                          SizedBox(width: widthMax*0.2),
                          EditProfileButton(
                            color: Colors.amber,
                            text: 'Save',
                            onPress: (){
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   editProfileRoute, 
                              //   (route) => false,
                              // );
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Container(
//           child: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: ListView(
//               children: [
//                 Center(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 160,
//                         height: 160,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 4, color: Colors.white),
//                           boxShadow: [
//                             BoxShadow(
//                               spreadRadius: 2,
//                               blurRadius: 10,
//                               color: Colors.black.withOpacity(0.1))
//                           ],
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: NetworkImage(
//                               'https://p5.itc.cn/images01/20230925/e78d0c5543304b0cbd9c3e89ae033c24.png'),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(width: 4, color: Colors.white),
//                               color: Colors.blue),
//                           child: Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
//                   child: Column(
//                     children: [
//                       TextField(
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.only(bottom: 5),
//                           labelText: 'Full Name',
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                           hintText: 'Jack Sully',
//                           hintStyle: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           )
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.only(bottom: 5),
//                           labelText: 'Email',
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                           hintText: 'Jacksully@gmail.com',
//                           hintStyle: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           )
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.only(bottom: 5),
//                           labelText: 'Phone Number',
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                           hintText: '012-34567890',
//                           hintStyle: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           )
//                         ),
//                       ),
//                     ],
//                   )
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       OutlinedButton(
//                         onPressed: (){
    
//                         }, 
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsetsDirectional.symmetric(horizontal: 50),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                           side: BorderSide(
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: (){
                
//                         }, 
//                         child: Text(
//                           'Save', 
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsetsDirectional.symmetric(horizontal: 50),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),