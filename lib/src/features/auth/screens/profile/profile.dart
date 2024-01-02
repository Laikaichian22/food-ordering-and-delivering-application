import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/controllers/profile_image_controller.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class GeneralProfilePage extends StatelessWidget {
  const GeneralProfilePage({
    required this.userId,
    required this.colorUsed,
    super.key
  });

  final String userId;
  final Color colorUsed;

  @override
  Widget build(BuildContext context) {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
    var heightMax = MediaQuery.of(context).size.height;
    var widthMax = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, provider, child){
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future: userCollection.doc(userId).get(),
                builder: (BuildContext context,  snapshot) { 
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: heightMax*0.85,
                                width: widthMax,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: const BoxDecoration(
                                  color: profileLayoutColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                              
                              Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
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
                                            return const Center(
                                              child: CircularProgressIndicator()
                                            );
                                          },
                                          errorBuilder: (context, object, stack){
                                            return const Icon(Icons.error_outline);
                                          },
                                        )
                                      : Image.file(
                                        File(provider.image!.path).absolute
                                      )
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top:heightMax*0.3),
                                child: Form(
                                  child: Container(
                                    padding: const EdgeInsets.all(tPaddingSize),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          initialValue: data['fullName'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: fNametxt,
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.person_outlined),
                                          ),
                                        ),
                    
                                        const SizedBox(height: 20),
                    
                                        TextFormField(
                                          initialValue: data['email'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: emailAddrtxt,
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.email_outlined),
                                          ),
                                        ),
                    
                                        const SizedBox(height: 20),
                    
                                        TextFormField(
                                          initialValue: data['phone'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: phoneNumtxt,
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.phone_outlined),
                                          ),
                                        ),
                    
                                        const SizedBox(height: 40),
                    
                                        SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colorUsed,
                                              minimumSize: const Size(188, 36),
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                side: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                ),
                                              ),
                                              elevation: 10,
                                              shadowColor: shadowClr,
                                            ),
                                            onPressed: () async {
                                              await userCollection
                                              .doc(userId)
                                              .get()
                                              .then((DocumentSnapshot documentSnapshot) async {
                                                if(documentSnapshot.exists){
                                                  if(documentSnapshot.get('role') == "Business owner"){
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                      editOwnerProfileRoute, 
                                                      (route) => false,
                                                    );
                                                  }
                                                  else if(documentSnapshot.get('role') == "Customer"){
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                      editCustProfileRoute, 
                                                      (route) => false,
                                                    );
                                                  }else if(documentSnapshot.get('role') == "Delivery man"){
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                      editDeliveryProfileRoute, 
                                                      (route) => false,
                                                    );
                                                  }  
                                                }
                                              });
                                            },
                                            child: const Text(
                                              editProfiletxt,
                                              style: TextStyle(
                                                color: textBlackColor,
                                                fontSize: 20
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),    
                        ],
                      );
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString())
                      ); 
                    }else{
                      return const Center(
                        child: Text(errorMessagetxt)
                      ); 
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
      )
    );
  }
}