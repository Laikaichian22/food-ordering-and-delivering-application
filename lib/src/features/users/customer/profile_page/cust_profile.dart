import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  var size, heightMax, widthMax;
  final currentUser = AuthService.firebase().currentUser;

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          // New parameter:
          scrolledUnderElevation: 0,
          title: const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                customerRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: heightMax*0.85,
                      width: widthMax,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 236, 236, 236),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      child: const CircleAvatar(
                        radius: 95,
                        backgroundColor: Colors.amber,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://p5.itc.cn/images01/20230925/e78d0c5543304b0cbd9c3e89ae033c24.png'),
                          radius: 85,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                   
                    Padding(
                      padding: EdgeInsets.only(top:heightMax*0.3),
                      child: Form(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: "LAI KAI CHIAN",
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person_outlined),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                initialValue: "abc@gmail.com",
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                initialValue: "012-34567890",
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.phone_outlined),
                                ),
                              ),

                              const SizedBox(height: 40),

                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //change the color of button
                                    backgroundColor: Colors.amber,
                                    minimumSize: Size(188, 36),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16),
                                    //change the border to rounded side
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25)),
                                      side: BorderSide(
                                          width: 1,
                                          color: Colors.black),
                                    ),
                                    //construct shadow color
                                    elevation: 10,
                                    shadowColor: const Color.fromARGB(
                                        255, 92, 90, 85),
                                  ).copyWith(
                                    //change color onpressed
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                            (Set<MaterialState>
                                                states) {
                                      if (states.contains(
                                          MaterialState.pressed))
                                        return Colors.blue;
                                      return null; // Defer to the widget's default.
                                    }),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      editProfileRoute, 
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ),

                  ],
                ),
                
              ],
            ),
          ),
        )
      ),
    );
  }
}