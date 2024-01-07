import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/privacy_security.dart';
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
    UserDatabaseService userDatabaseService = UserDatabaseService();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: drawerColor,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 46,
                  backgroundColor: drawerImageBorderColor,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/homeImage.jpg'),
                    radius: 42, 
                    backgroundColor: drawerColor
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: FutureBuilder<UserModel?>(
                    future: userDatabaseService.getUserDataByUserId(userId),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching user data'));
                      } else{
                        UserModel? userData = snapshot.data;
                        String userName = userData?.fullName ?? 'User';
                        return Center(
                          child: Text(
                            'Welcome,\n$userName',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20
                            ),
                          ),
                        );
                      }
                    }
                  )
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outlined,
            ),
            title: const Text(listTileProfiletxt, style: TextStyle(color: textBlackColor)),
            onTap: () async {
              UserModel? userData = await userDatabaseService.getUserDataByUserId(userId);
              if (userData != null) {
                if (userData.role == "Business owner") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    ownrProfileRoute,
                    (route) => false,
                  );
                } else if (userData.role == "Customer") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    custProfileRoute,
                    (route) => false,
                  );
                } else if (userData.role == "Delivery man") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    deliveryProfileRoute,
                    (route) => false,
                  );
                }
              }
            }
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
            ),
            title: const Text(listTileSettingtxt, style: TextStyle(color: textBlackColor)),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const PrivacyAndSecurity()
              );
              Navigator.push(context, route);
            }),
          ListTile(
            leading: const Icon(
              Icons.format_quote_outlined,
            ),
            title: const Text(listTileFAQtxt, style: TextStyle(color: textBlackColor)),
            onTap: () {}
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text(listTileLogouttxt, style: TextStyle(color: textBlackColor)),
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            }
          ),
          Container(
            height: 330,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  contactSupporttxt,
                  style: TextStyle(
                    color: textBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
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
                      ' 012-3456789',
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
                      ' vongolaTeam@gmail.com',
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
        ],
      ),
    );
  }
}