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
  List<MainDishesWidget> mainDishList = [];
  List<String> dishName = [];
  List<String> price = [];
  addMainDishes(){
    if(dishName.isNotEmpty){
      dishName = [];
      price = [];
      mainDishList = [];
    }
    setState(() {
      
    });
    mainDishList.add(MainDishesWidget());
  }
  submitData() {
    dishName = [];
    price = [];
    mainDishList.forEach((widget) => dishName.add(widget.dishNameController.text));
    mainDishList.forEach((widget) => price.add(widget.priceController.text));
    setState(() {});
    print(mainDishList.length);

  }

  @override
  Widget build(BuildContext context) {
    Widget dynamicTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: mainDishList.length,
        itemBuilder: (_, index) => mainDishList[index],
      ),
    );

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
                  child: Text("${index + 1} : ${dishName[index]} ${price[index]}"),
                ),
                const Divider()
              ],
            ),
          );
        },
      ),
    ));

    Widget submitButton = Container(
      child: TextButton(
          onPressed:
            submitData,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Submit Data'),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Price List', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor,
        ),
        body: Container(
          child: Column(
            children: [
              dishName.length == 0 ? dynamicTextField : result,
              dishName.length == 0 ? submitButton : Container(),

              FloatingActionButton(
                onPressed: addMainDishes,
                child:const Icon(Icons.add)
              )
            ],
          ),
          
        )
      ),
    );
  }
}

class MainDishesWidget extends StatelessWidget{
  final dishNameController = TextEditingController();
  final priceController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      child: ListBody(
        children: [
          Row(
            children: [
              Container(
                width:200,
                child: TextFormField(
                  controller: dishNameController,
                  decoration: const InputDecoration(
                    labelText: 'Dish Name',
                    border: OutlineInputBorder()
                  ),
                ),
              ),
              Container(
                width: 100,
                  child: TextFormField(
                  controller: priceController,
                    decoration: const InputDecoration(
                        labelText: 'Price', 
                        border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )
        ],
      ),
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
//     List<String> price = [];

//     addMainDishes(){
//       if(DishName.isNotEmpty){
//         DishName = [];
//         price = [];
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