import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile_image_controller.dart';
import 'package:provider/provider.dart';

class EditPhotoWidget extends StatelessWidget {
  const EditPhotoWidget(
      {required this.userId, required this.colorUsed, super.key});
  final String userId;
  final Color colorUsed;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _users =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: _users,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
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
                                      )),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: provider.image == null
                                          ? data['image'].toString() == ""
                                              ? Icon(Icons.food_bank_sharp,
                                                  size: 35)
                                              : Image(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      data['image'].toString()),
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  },
                                                  errorBuilder:
                                                      (context, object, stack) {
                                                    return Container(
                                                      child: Icon(
                                                          Icons.error_outline),
                                                    );
                                                  },
                                                )
                                          : Image.file(
                                              File(provider.image!.path)
                                                  .absolute)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 75),
                                child: InkWell(
                                  onTap: () {
                                    provider.pickImage(context);
                                  },
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(errorMessagetxt),
                      );
                    }
                  }),
            ),
          );
        },
      ),
    );
  }
}
