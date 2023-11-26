import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {

  Widget categoriesContainer({required String image, required String name}) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image)),
            color: const Color.fromARGB(255, 228, 225, 219),
            borderRadius: BorderRadius.circular(10)
          ),
        ),

        const SizedBox(height: 5),

        Text(
          name,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return Scaffold(
      drawer: DrawerFunction(userId: userId),
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
                categoriesContainer(image: 'images/R.jpg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpg', name: 'Rice'),
                categoriesContainer(image: 'images/R.jpg', name: 'Rice'),
              ],
            ),
          )
        ],
      )
    );
  }
}