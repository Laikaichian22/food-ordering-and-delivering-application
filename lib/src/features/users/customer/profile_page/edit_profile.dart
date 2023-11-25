import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/profile_image_controller.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/save_cancel_btn.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var size, heightMax, widthMax;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;

    final userId = AuthService.firebase().currentUser?.id;
    //Documentsnapshot -> can read specific doc
    //querysnapshot -> read all doc
    final Stream<DocumentSnapshot> _users = FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .snapshots();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amber,
          title: const Text(
            editProfiletxt,
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
        body: ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child: Consumer<ProfileController>(
            builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _users,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator()
                      );
    
                    }else if(snapshot.hasData){
                      dynamic data = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Center(
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 5,
                                    )
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:
                                      provider.image == null ?
                                      data['image'].toString() == ""? const Icon(Icons.person, size:35): 
                                      Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(data['image'].toString()),  
                                        loadingBuilder: (context, child, loadingProgress){
                                          if(loadingProgress == null)
                                            return child;
                                          return Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, object, stack){
                                          return Container(
                                            child: Icon(Icons.error_outline),
                                          );
                                        },
                                      ): 
                                      Image.file(
                                          File(provider.image!.path).absolute
                                      )
    
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:75),
                                child: InkWell(
                                  onTap: (){
                                    provider.pickImage(context);
                                  },
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.edit_outlined,size: 20,),   
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: (){
                              provider.showFullNameDialogAlert(context, data['fullName']);
                            },
                            child: EditProfileRows(title: fNametxt, value: data['fullName'], iconData: Icons.person_outline),
                          ),
                          GestureDetector(
                            onTap: (){
                              provider.showEmailDialogAlert(context, data['email']);
                            },
                            child: EditProfileRows(title: emailAddrtxt, value: data['email'], iconData: Icons.email_outlined),
                          ),
                          GestureDetector(
                            onTap: (){
                              provider.showPhoneDialogAlert(context, data['phone']);
                            },
                            child: EditProfileRows(title: phoneNumtxt, value: data['phone'], iconData: Icons.phone_outlined),
                          ),
                        ],
                      );
                    }else{
                      return Center(
                        child: Text(errorMessagetxt),
                      );
                    }   
                  }
                )
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}

class EditProfileRows extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const EditProfileRows({
    required this.title,
    required this.value,
    required this.iconData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 15)),
          leading: Icon(iconData),
          trailing: Text(value,  style: TextStyle(fontSize: 16)),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}

// SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: StreamBuilder<DocumentSnapshot>(
//             stream: _users,
//             builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if(!snapshot.hasData){
//                 return Center(
//                   child: CircularProgressIndicator()
//                 );

//               }else if(snapshot.hasData){
//                 dynamic data = snapshot.data;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Center(
//                           child: Container(
//                             height: 150,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.amber,
//                                 width: 5,
//                               )
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: Image(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage('https://p5.itc.cn/images01/20230925/e78d0c5543304b0cbd9c3e89ae033c24.png'),  
//                                 loadingBuilder: (context, child, loadingProgress){
//                                   if(loadingProgress == null)
//                                     return child;
//                                   return Center(child: CircularProgressIndicator());
//                                 },
//                                 errorBuilder: (context, object, stack){
//                                   return Container(
//                                     child: Icon(Icons.error_outline),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left:75),
//                           child: InkWell(
//                             onTap: (){

//                             },
//                             child: const CircleAvatar(
//                               radius: 15,
//                               backgroundColor: Colors.black,
//                               child: Icon(Icons.edit_outlined,size: 20,),   
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     EditProfileRows(title: 'Full Name', value: data['fullName'], iconData: Icons.person_outline),
//                     EditProfileRows(title: 'Email Address', value: data['email'], iconData: Icons.email_outlined),
//                     EditProfileRows(title: 'Phone Number', value: data['phone'], iconData: Icons.phone_outlined),
//                   ],
//                 );
//               }else{
//                 return Center(
//                   child: Text('Something went wrong'),
//                 );
//               }   
//             }
//           )
//         ),
//       ),



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