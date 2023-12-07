import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuAddDishPage extends StatefulWidget {
  const MenuAddDishPage({super.key});

  @override
  State<MenuAddDishPage> createState() => _MenuAddDishPageState();
}

class _MenuAddDishPageState extends State<MenuAddDishPage> {
  MenuDatabaseService service = MenuDatabaseService();
  //create list of main dish text field 
  List<MainDishesWidget> mainDishList = [];
  //create list of string that store name of dishes
  List<String> dishName = [];
  //create list of string that store photo
  List<String> photo = [];

  addMainDishes(){
    if(dishName.isNotEmpty){
      //if contain at least one dish, the list of dish will be remained
      dishName = [];
      photo = [];
      mainDishList = [];
    }
    setState(() {
      
    });
    //and then add new list under it
    mainDishList.add(MainDishesWidget());
  }
  submitData() {
    dishName = [];
    photo = [];

    for(int i=0 ; i<mainDishList.length ; i++){

    }

    mainDishList.forEach((widget) => dishName.add(widget.dishNameController.text));
    mainDishList.forEach((widget) => photo.add(widget.photoController.text));
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    //create the list of textfield
    Widget dynamicTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: mainDishList.length,
        itemBuilder: (_, index) => mainDishList[index],
      ),
    );

    //display result using Card(), data shows in list type on the card
    Widget result = Flexible(
      flex: 1,
      child: Card(
        child: ListView.builder(
          itemCount: dishName.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Text("${index + 1} : ${dishName[index]} ${photo[index]}"),
                  ),
                  const Divider()
                ],
              ),
            );
          },
        ),
      )
    );

    //NOTE! (ONLY HAPPEN after pressing the SAVE button)
    //After capture the data, the result should display on the same page
    //just make the previous text field become data display field
    //to edit the data, add new edit button that convert data display field into text field

    //function to save data
    Widget submitButton = TextButton(
      onPressed: submitData,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Save'),
      ),
    );
    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final menuNameController = TextEditingController();

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
                    child: TextFormField(             
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
                    ),
                  ),

                  const SizedBox(height:30),

                  Container(
                    width: width,
                    height: height,
                    padding: const EdgeInsets.all(10),
                    decoration:BoxDecoration(
                      border:Border.all(),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
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
                            addMainDishes();
                          },
                          child: Container(
                            width: width*0.6,
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
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ),
                        dishName.isEmpty ? dynamicTextField : result,
                      ],
                    ),
                  ),
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
  final dishNameController = TextEditingController();
  final photoController = TextEditingController();

  MainDishesWidget({super.key});

  @override
  Widget build(BuildContext context){
    return ListBody(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width:200,
                  child: TextFormField(
                    controller: dishNameController,
                    decoration: const InputDecoration(
                      labelText: 'Dish Name',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                    child: TextFormField(
                    controller: photoController,
                      decoration: const InputDecoration(
                          labelText: 'Photo', 
                          border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.number,
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

// final menuNameController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   MenuDatabaseService service = MenuDatabaseService();

//   @override
//   void dispose(){
//     menuNameController.dispose();
//     super.dispose();
//   }

// var width = MediaQuery.of(context).size.width;
//     var _height = MediaQuery.of(context).size.height;
//     List<MainDishesWidget> mainDishList = [];
//     List<String> DishName = [];
//     List<String> photo = [];

//     addMainDishes(){
//       if(DishName.isNotEmpty){
//         DishName = [];
//         photo = [];
//         mainDishList = [];
//       }
//       setState(() {
        
//       });
//       mainDishList.add(MainDishesWidget());
//     }

//     return SafeArea(
//       child: Scaffold(
//         appBar: GeneralAppBar(
//           title: 'Create Menu', 
//           onPress: (){
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               businessOwnerRoute, 
//               (route) => false,
//             );
//           }, 
//           barColor: ownerColor
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Center(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: width*0.5,
//                     child: TextFormField(             
//                       controller: menuNameController,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Menu's name",
//                         contentPadding: EdgeInsets.all(15),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)
//                         ),
//                       ),
//                     ),
//                   ),
        
//                   const SizedBox(height:30),
                  
//                   SingleChildScrollView(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       padding: const EdgeInsets.all(20),
//                       decoration:BoxDecoration(
//                         border:Border.all(),
//                         borderRadius: BorderRadius.circular(20)
//                       ),
//                       child: Column(
//                         children: [
//                           const Text(
//                             'Main dishes', 
//                             style: TextStyle(
//                               fontSize:25,
//                               fontWeight: FontWeight.bold,
//                             )
//                           ),
//                           const SizedBox(height: 10),
//                           InkWell(
//                             onTap: (){
//                               addMainDishes;
//                             },
//                             child: Container(
//                               width: width*0.6,
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(255, 219, 217, 214),
//                                 border: Border.all(),
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Color.fromARGB(255, 157, 158, 159),
//                                     offset: Offset(
//                                       1.0,
//                                       2.0 
//                                     ),
//                                     blurRadius: 1.0,
//                                     spreadRadius: 1.0,
//                                   )
//                                 ]
//                               ),
//                               child: const ListTile(
//                                 trailing: Icon(Icons.add_outlined, size: 35),
//                                 title: Text(
//                                   'Add dish...',
//                                   style: TextStyle(
//                                     fontSize: 23,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height*0.5,
//                             child: ListView.builder(
//                               itemCount: mainDishList.length,
//                               itemBuilder: (_, index) => mainDishList[index],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height:20),
      
//                   SizedBox(
//                     height: 45,
//                     width: 150,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.amber,
//                         elevation: 10,
//                         shadowColor: const Color.fromARGB(255, 92, 90, 85),
//                       ),
//                       onPressed: (){
//                         Navigator.of(context).pushNamed(
//                           menuCompletedRoute, 
//                         );
//                       }, 
//                       //ensure the user keyin infor of dish, save data, when user return, user still can see the data
//                       child: const Text(
//                         'Continue', 
//                         style: TextStyle(
//                           fontSize: 20, 
//                           color: Colors.black
//                         ),
//                       )
//                     ),
//                   ),          
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );