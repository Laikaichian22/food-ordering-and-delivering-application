import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuPriceListPage extends StatefulWidget {
  const MenuPriceListPage({super.key});

  @override
  State<MenuPriceListPage> createState() => _MenuPriceListPageState();
}

class _MenuPriceListPageState extends State<MenuPriceListPage> {

  final priceListController = TextEditingController();
  final menuTitleController = TextEditingController();

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
                menuMainPageRoute, 
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
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: TextFormField(
                      controller: menuTitleController,             //create default menu name if possible
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
        
                  Text(
                    'Price list',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
        
                  const SizedBox(height:10),
                  
                  TextFormField(
                    controller: priceListController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "List of pricing",
                      border: OutlineInputBorder(),
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
                          menuAddDishRoute, 
                        );
                      }, 
                      //ensure the user key in the menu name
                      child: const Text(
                        'Continue', 
                        style: TextStyle(
                          fontSize: 20, 
                          color: Colors.black
                        ),
                      ),
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