import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/utilities/dialogs/logout.dart';

class DrawerFunction extends StatelessWidget {
  const DrawerFunction({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {

    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: drawerColor,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: drawerImageBorderColor,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/homeImage.jpg'),
                    radius: 42, 
                    backgroundColor: drawerColor
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        welcometxt,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(ownerPagetxt),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text(listTileHometxt, style: TextStyle(color: textBlackColor)),
            onTap: () {
              
            }),
          ListTile(
            leading: const Icon(
              Icons.person_outlined,
            ),
            title: const Text(listTileProfiletxt, style: TextStyle(color: textBlackColor)),
            onTap: () async {
              await userCollection
              .doc(userId)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
                if(documentSnapshot.exists){
                  if(documentSnapshot.get('role') == "Business owner"){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      ownrProfileRoute, 
                      (route) => false,
                    );
                  }
                  else if(documentSnapshot.get('role') == "Customer"){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      custProfileRoute, 
                      (route) => false,
                    );
                  }else if(documentSnapshot.get('role') == "Delivery man"){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      deliveryProfileRoute, 
                      (route) => false,
                    );
                  }  
                }
              });
            }),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text(listTileSettingtxt, style: TextStyle(color: textBlackColor)),
            onTap: () {}),
          ListTile(
            leading: const Icon(
              Icons.format_quote_outlined,
            ),
            title: const Text(listTileFAQtxt, style: TextStyle(color: textBlackColor)),
            onTap: () {}),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
            ),
            title: const Text(listTileLogouttxt, style: TextStyle(color: textBlackColor)),
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              //devtools.log(shouldLogout.toString()); //give special output in terminal
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactSupporttxt,
                    style: TextStyle(
                      color: textBlackColor,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        callUstxt,
                        style: TextStyle(
                          color: textBlackColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '0123456789',
                        style: TextStyle(
                          color: textBlackColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        mailUstxt,
                        style: TextStyle(
                          color: textBlackColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'abc@gmail.com',
                        style: TextStyle(
                          color: textBlackColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}