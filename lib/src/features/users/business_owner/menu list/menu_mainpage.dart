import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});

  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}

class _MenuMainPageState extends State<MenuMainPage> {
  
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                businessOwnerRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconWhiteColor
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            CardMenuWidget(
              title: 'Create Menu', 
              iconBtn: Icons.add_outlined, 
              subTitle: "Today's date:", 
              cardColor: Color.fromARGB(255, 220, 220, 220), 
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  menuPriceListRoute, 
                  (route) => false,
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

class CardMenuWidget extends StatelessWidget {
  const CardMenuWidget({
    required this.title,
    required this.iconBtn,
    required this.subTitle,
    required this.cardColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subTitle;
  final Color cardColor;
  final VoidCallback onTap;
  final IconData iconBtn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.18,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: cardColor,
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  //image: DecorationImage(image:, fit:BoxFit.fitWidth),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      trailing: Icon(iconBtn, size: 55),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: textBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: textBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}