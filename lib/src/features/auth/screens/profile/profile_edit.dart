import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/edit_profile_row.dart';
import 'package:flutter_application_1/src/features/auth/controllers/profile_image_controller.dart';
import 'package:provider/provider.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({
    required this.userId,
    required this.colorUsed,
    super.key
  });

  final String userId;
  final Color colorUsed;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> users = FirebaseFirestore.instance
    .collection('user')
    .doc(userId)
    .snapshots();
    
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: StreamBuilder<DocumentSnapshot>(
              stream: users,
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
                                  color: colorUsed,
                                  width: 5,
                                )
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                  provider.image == null 
                                  ? data['profileImage'].toString() == ""
                                    ? const Icon(Icons.person, size:35)
                                    : Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data['profileImage'].toString()),  
                                      loadingBuilder: (context, child, loadingProgress){
                                        if(loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, object, stack){
                                        return const Icon(Icons.error_outline);
                                      },
                                    )
                                  : 
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
                          ),
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
                          provider.showPhoneDialogAlert(context, data['phone']);
                        },
                        child: EditProfileRows(title: phoneNumtxt, value: data['phone'], iconData: Icons.phone_outlined),
                      ),
                      data['role'] == 'Delivery man'
                      ? GestureDetector(
                          onTap: (){
                            provider.showPlateNumberDialogAlert(context, data['plateNumber']);
                          },
                          child: EditProfileRows(title: 'Car Plate Number', value: data['plateNumber'], iconData: Icons.car_rental_outlined),
                        )
                      : Container()
                    ],
                  );
                }else{
                  return const Center(
                    child: Text(errorMessagetxt),
                  );
                }   
              }
            ),
          ),
        );
      },
      ),
    );
  }
}