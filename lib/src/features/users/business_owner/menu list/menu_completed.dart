import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuCompletedPage extends StatefulWidget {
  const MenuCompletedPage({super.key});

  @override
  State<MenuCompletedPage> createState() => _MenuCompletedPageState();
}

class _MenuCompletedPageState extends State<MenuCompletedPage> {
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
        body: Padding(
          padding: const EdgeInsets.all(20),
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

                const SizedBox(height: 50),

                CardListWidget(
                  title: 'Price List', 
                  iconBtn: Icons.arrow_drop_down_outlined, 
                  subTitle: 'Check price list', 
                  cardColor: Colors.yellowAccent, 
                  onTap: (){

                  }
                ),

                const SizedBox(height: 30),

                CardListWidget(
                  title: 'Menu List', 
                  iconBtn: Icons.arrow_drop_down_outlined,  //if press, it become up, then back to down again
                  subTitle: 'Check menu list', 
                  cardColor: Colors.yellowAccent, 
                  onTap: (){
                    
                  }
                ),

                const SizedBox(height: 150),

                SizedBox(
                  height: 55,
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      'Open order', 
                      style: TextStyle(
                        fontSize: 25, 
                        color: Colors.black
                      ),
                    ),
                  ),
                ),         
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class CardListWidget extends StatelessWidget {
  const CardListWidget({
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
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.11,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  //image: DecorationImage(image:, fit:BoxFit.fitWidth),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      trailing: Icon(iconBtn, size: 55),
                      title: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: textBlackColor,
                          ),
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          subTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: textBlackColor,
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
      ),
    );
  }
}