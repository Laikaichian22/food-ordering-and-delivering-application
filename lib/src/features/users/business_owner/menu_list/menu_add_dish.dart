import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/dish_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/display_menu_created.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class MenuAddDishPage extends StatefulWidget {
  const MenuAddDishPage({super.key});

  @override
  State<MenuAddDishPage> createState() => _MenuAddDishPageState();
}

class _MenuAddDishPageState extends State<MenuAddDishPage> {

  List<DishModel> toMainDishList(){
    for(int i=0 ; i<mainDishList.length ; i++){
      var widget = mainDishList[i];
      dishNameList.add(widget.mainDishName.text);
      mainDishInList.add(DishModel(
        dishId: i, 
        dishName: widget.mainDishName.text,
        dishPhoto: ''
        )
      );
    }
    return mainDishInList.toList();
  }

  List<DishModel> toSideDishList(){
    for(int i=0 ; i<sideDishList.length ; i++){
      var widget = sideDishList[i];
      dishNameList.add(widget.sideDishName.text);
      sideDishInList.add(DishModel(
        dishId: i, 
        dishName: widget.sideDishName.text,
        dishPhoto: ''
        )
      );
    }
    return sideDishInList.toList();
  }

  List<DishModel> toSpecialDishList(){
    for(int i=0 ; i<specialDishList.length ; i++){
      var widget = specialDishList[i];
      dishNameList.add(widget.specialDishName.text);
      specialDishInList.add(DishModel(
        dishId: i, 
        dishName: widget.specialDishName.text,
        dishPhoto: ''
        )
      );
    }
    return specialDishInList.toList();
  }
  
  final menuNameController = TextEditingController();


  // final photoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool saveBtnOn = false;
  MenuDatabaseService serviceMenu = MenuDatabaseService();
  DishDatabaseService serviceDish = DishDatabaseService();

  //create list of main dish text field
  List<MainDishesWidget> mainDishList = [];

  List<SideDishesWidget> sideDishList = [];

  List<SpecialDishesWidget> specialDishList = [];

  //create list of dishes
  List<DishModel> mainDishInList = [];
  List<DishModel> sideDishInList = [];
  List<DishModel> specialDishInList = [];

  //create list of string that store name of dishes
  List<String> dishNameList = [];
  //create list of string that store photo
  List<String> photoList = [];

  @override
  void initState(){
    super.initState();
    menuNameController.addListener(() {
      setState(() {
        saveBtnOn = menuNameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose(){
    menuNameController.dispose();
    // photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //create the list of textfield
    Widget dynamicMainDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: mainDishList.length,
        itemBuilder: (_, index) => mainDishList[index],  
      ),
    );

    Widget dynamicSideDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: sideDishList.length,
        itemBuilder: (_, index) => sideDishList[index],  
      ),
    );

    Widget dynamicSpecialDish = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: specialDishList.length,
        itemBuilder: (_, index) => specialDishList[index], 
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Menu List', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: width*0.5,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(           
                        autovalidateMode: AutovalidateMode.onUserInteraction,  
                        controller: menuNameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "Menu's name",
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        validator: (value) {
                          if(value==null||value.isEmpty){
                            return "Please enter name of menu";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height:30),

                  Container(
                    width: width,
                    height: height*1.8, //*1.8
                    padding: const EdgeInsets.all(10),
                    decoration:BoxDecoration(
                      // color: const Color.fromARGB(255, 176, 219, 255),
                      border:Border.all(),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        //Main dish
                        const Text(
                          'Main dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              //if contain at least one dish, the list of dish will be remained
                              dishNameList = [];
                              photoList = [];
                              mainDishList = [];
                              //dishControllers[mainDishIndex] = TextEditingController();
                            }
                            setState(() {
                              saveBtnOn = true;
                            });
                            //and then add new list under it
                            mainDishList.add(MainDishesWidget());
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicMainDish,

                        //side dish
                        const SizedBox(height: 30),
                        const Text(
                          'Side dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              //if contain at least one dish, the list of dish will be remained
                              dishNameList = [];
                              photoList = [];
                              sideDishList = [];
                            }
                            setState(() {
                              
                            });
                            //and then add new list under it
                            sideDishList.add(
                              SideDishesWidget()
                            );
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicSideDish,

                        const SizedBox(height: 30),
                        const Text(
                          'Special dishes', 
                          style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: (){
                            if(dishNameList.isNotEmpty){
                              //if contain at least one dish, the list of dish will be remained
                              dishNameList = [];
                              photoList = [];
                              specialDishList = [];
                            }
                            setState(() {
                              
                            });
                            //and then add new list under it
                            specialDishList.add(
                              SpecialDishesWidget()
                            );
                          },
                          child: Container(
                            height: height*0.07,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 217, 214),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 157, 158, 159),
                                  offset: Offset(
                                    1.0,
                                    2.0 
                                  ),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                )
                              ]
                            ),
                            child: const ListTile(
                              trailing: Icon(Icons.add_outlined, size: 35),
                              title: Text(
                                'Add dish...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dynamicSpecialDish,
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 55,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: saveBtnOn 
                      ? () async {
                          if(_formKey.currentState!.validate()){
                            DateTime now = DateTime.now();

                            MenuModel menuList = MenuModel(
                              menuName: menuNameController.text.trim(), 
                              createdDate: DateFormat('MMMM dd, yyyy').format(now), 
                              mainDishList: toMainDishList(),
                              sideDishList: toSideDishList(),
                              specialDishList: toSpecialDishList(),
                            );
                            
                            await serviceMenu.addMenu(menuList);
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context)=> DisplayMenuCreated(
                                  menuListSelected: menuList,
                                  dishList: dishNameList,
                                )
                              );
                            Navigator.push(context, route);

                            setState(() {
                    
                            });
                          }
                        }
                      : null,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Save',
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 20 
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class MainDishesWidget extends StatelessWidget{
  MainDishesWidget({
    super.key
  });

  final TextEditingController mainDishName = TextEditingController();

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width:210,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: mainDishName,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Dish Name',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    
                  },
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()
                    ),
                    //backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40
                    ),   
                  ),
                )
              ],
            ), 
          ],
        )
      ],
    );
  }
}


class SideDishesWidget extends StatelessWidget{
  SideDishesWidget({
    super.key
  });
  
  final TextEditingController sideDishName = TextEditingController();

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width:210,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: sideDishName,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Dish Name',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    
                  },
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()
                    ),
                    //backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40
                    ),   
                  ),
                )
              ],
            ), 
          ],
        )
      ],
    );
  }
}


class SpecialDishesWidget extends StatelessWidget{
  SpecialDishesWidget({
    super.key
  });

  final TextEditingController specialDishName = TextEditingController();

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width:210,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: specialDishName,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Dish Name',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    
                  },
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()
                    ),
                    //backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40
                    ),   
                  ),
                )
              ],
            ), 
          ],
        )
      ],
    );
  }
}