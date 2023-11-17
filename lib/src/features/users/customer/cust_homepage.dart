import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utilities/dialogs/logout.dart';

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
    return Scaffold(
        drawer: Drawer(
          child: Container(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 185, 35),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 46,
                        child: CircleAvatar(
                            radius: 42, backgroundColor: Colors.amber),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("This is owner page"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home_outlined,
                  ),
                  title: Text('Home', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new BusinessOwnerHomePage()));
                  }),
                ListTile(
                  leading: Icon(
                    Icons.person_outlined,
                  ),
                  title: Text('My profile',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      custProfileRoute, 
                      (route) => false,
                    );
                  }),
                ListTile(
                  leading: Icon(
                    Icons.settings_outlined,
                  ),
                  title:
                      Text('Setting', style: TextStyle(color: Colors.black)),
                  onTap: () {}),
                ListTile(
                  leading: Icon(
                    Icons.format_quote_outlined,
                  ),
                  title: Text('FAQs', style: TextStyle(color: Colors.black)),
                  onTap: () {}),
                ListTile(
                  leading: Icon(
                    Icons.logout_outlined,
                  ),
                  title:
                      Text('Logout', style: TextStyle(color: Colors.black)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Support",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Call us:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '0123456789',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Mail us:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'abc@gmail.com',
                              style: TextStyle(
                                color: Colors.black,
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
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          elevation: 0.0,
          
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/homeImage.jpg'),
              ),
            )
          ],
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