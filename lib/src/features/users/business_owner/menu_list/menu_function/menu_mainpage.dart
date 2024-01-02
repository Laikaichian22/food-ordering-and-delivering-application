import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_function/view_menu_created.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});

  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}

class _MenuMainPageState extends State<MenuMainPage> {
  MenuDatabaseService service = MenuDatabaseService();
  Future<List<MenuModel>>? menuList;
  List<MenuModel>? retrievedMenuList;

  @override
  void initState(){
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async{
    menuList = service.retrieveMenu();
    retrievedMenuList = await service.retrieveMenu();
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

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
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CardMenuWidget(
                  title: 'Create Menu', 
                  iconBtn: Icons.add_outlined, 
                  subTitle: "Today's date: ${DateFormat('MMM dd, yyyy').format(now)}", 
                  cardColor: const Color.fromARGB(255, 220, 220, 220), 
                  onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      menuAddDishRoute, 
                      (route) => false,
                    );
                  }
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 186, 224, 255),
                    border: Border.all(),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.65,
                      child: FutureBuilder(
                        future: menuList, 
                        builder: (BuildContext context, AsyncSnapshot<List<MenuModel>> snapshot){
                          if(snapshot.hasData && snapshot.data!.isNotEmpty){
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                              separatorBuilder: (context, index) => 
                              const SizedBox(
                                height: 10,
                              ), 
                              itemBuilder: (context, index){
                                return Dismissible(
                                  //swipe to left to delete the list
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(16.0)
                                    ),
                                    padding: const EdgeInsets.only(right: 28.0),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: const Text(
                                    "DELETE",
                                    style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: Text('Are you sure you want to delete menu: ${retrievedMenuList![index].menuName}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel')
                                            ),
                                            TextButton(
                                              onPressed: () async{
                                                await service.deleteMenu(
                                                  retrievedMenuList![index].menuId.toString()
                                                );
                                                setState(() {
                                                  _initRetrieval();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete')
                                            )
                                          ],
                                        );
                                      }
                                    ); 
                                  },
                                  key: UniqueKey(),
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: ListTile(
                                      onTap:() {
                                        MaterialPageRoute route = MaterialPageRoute(
                                          builder: (context) => DisplayMenuCreated(menuListSelected: retrievedMenuList![index])
                                        );
                                        Navigator.push(context, route);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      title: Text(
                                        retrievedMenuList![index].menuName,
                                        style: const TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      subtitle: Text(retrievedMenuList![index].createdDate),
                                      trailing: const Icon(Icons.arrow_right_sharp),
                                      ),
                                    ),
                                  ),
                                );
                              }, 
                            );
                            
                          }else if(snapshot.connectionState == ConnectionState.done && retrievedMenuList!.isEmpty){
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          }else{
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardMenuWidget extends StatelessWidget {
  const CardMenuWidget({
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
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.15,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: cardColor,
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  //image: DecorationImage(image:, fit:BoxFit.fitWidth),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      trailing: Icon(iconBtn, size: 55),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: textBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: textBlackColor,
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