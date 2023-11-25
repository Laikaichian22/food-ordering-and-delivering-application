import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class GeneralProfilePage extends StatelessWidget {
  const GeneralProfilePage({
    required this.userId,
    super.key
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    var size, heightMax, widthMax;


    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;

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
                                        //change the color of button
                                        backgroundColor: Colors.amber,
                                        minimumSize: const Size(188, 36),
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      child: const Text(
                                        editProfiletxt,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20),
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
  }
}