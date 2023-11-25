import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/logout.dart';

class BusinessOwnerHomePage extends StatefulWidget {
  const BusinessOwnerHomePage({super.key});

  @override
  State<BusinessOwnerHomePage> createState() => _BusinessOwnerHomePageState();
}

class _BusinessOwnerHomePageState extends State<BusinessOwnerHomePage> {
  
  Widget categoriesContainer({required String image, required String name}) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image)),
              color: Color.fromARGB(255, 228, 225, 219),
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 15, color: Colors.black),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return Scaffold(
      drawer: DrawerFunction(userId: userID),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: "Search Food",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Color.fromARGB(255, 231, 231, 99),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpeg', name: 'Rice'),
              ],
            ),
          )
        ],
      )
    );
  }
}