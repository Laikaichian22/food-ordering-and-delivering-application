import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuAddDishPage extends StatefulWidget {
  const MenuAddDishPage({super.key});

  @override
  State<MenuAddDishPage> createState() => _MenuAddDishPageState();
}

class _MenuAddDishPageState extends State<MenuAddDishPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                menuPriceListRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconWhiteColor
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextFormField(             //get the menu name from previous page
                    //controller: menuTitleController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Menu's name",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height:30),
                
                SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(20),
                    decoration:BoxDecoration(
                      border:Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Main dishes', style: TextStyle(fontSize:20)),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add dish...',       
                                  contentPadding: EdgeInsets.all(10),                     //use conditional to switch
                                  prefixIcon: Icon( Icons.add_outlined, size: 35),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 150),

                        Text('Side dishes', style: TextStyle(fontSize:20)),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add dish...',             
                                  contentPadding: EdgeInsets.all(10),                //use conditional to switch
                                  prefixIcon: Icon( Icons.add_outlined, size: 35),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 150),

                        Text('Special dishes', style: TextStyle(fontSize:20)),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add dish...',      
                                  contentPadding: EdgeInsets.all(10),                       //use conditional to switch
                                  prefixIcon: Icon( Icons.add_outlined, size: 35),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height:20),
    
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 92, 90, 85),
                    ),
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                        menuCompletedRoute, 
                      );
                    }, 
                    //ensure the user keyin infor of dish, save data, when user return, user still can see the data
                    child: const Text(
                      'Continue', 
                      style: TextStyle(
                        fontSize: 20, 
                        color: Colors.black
                      ),
                    )
                  ),
                ),          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}