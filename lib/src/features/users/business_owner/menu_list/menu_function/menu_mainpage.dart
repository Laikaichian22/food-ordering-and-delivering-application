import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/menu_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/menu.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_function/view_menu_created.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});

  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}

class _MenuMainPageState extends State<MenuMainPage> {
  final MenuDatabaseService menuService = MenuDatabaseService();

  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Menu List',
          userRole: 'owner',
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
                      height: MediaQuery.of(context).size.height*0.6,
                      child: StreamBuilder(
                        stream: menuService.retrieveMenuStream(), 
                        builder: (BuildContext context, AsyncSnapshot<List<MenuModel>> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          } else if(snapshot.hasError){
                            return const Center(
                              child: Text(
                                'Error in fetching Data. Please reload again',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          }else{
                            List<MenuModel> menuList = snapshot.data!;
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: menuList.length,
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ), 
                              itemBuilder: (context, index){
                                return Dismissible(
                                  key: Key(menuList[index].menuId.toString()), 
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: deleteButtonColor,
                                      borderRadius: BorderRadius.circular(16.0)
                                    ),
                                    padding: const EdgeInsets.only(right: 28.0),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: const Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: yellowColorText,
                                        fontSize: 18
                                      ),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: Text('Are you sure you want to delete menu: ${menuList[index].menuName}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel')
                                            ),
                                            TextButton(
                                              onPressed: () async{
                                                await menuService.deleteMenu(menuList[index].menuId.toString());
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Delete')
                                            )
                                          ],
                                        );
                                      }
                                    ); 
                                  },      
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      decoration: BoxDecoration(
                                        color: menuList[index].openStatus == 'Yes' ? const Color.fromARGB(255, 225, 55, 255): Colors.amber,
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: ListTile(
                                      onTap:() {
                                        MaterialPageRoute route = MaterialPageRoute(
                                          builder: (context) => DisplayMenuCreated(menuListSelected: menuList[index])
                                        );
                                        Navigator.push(context, route);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      title: Text(
                                        menuList[index].menuName,
                                        style: const TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      subtitle: Text(menuList[index].createdDate),
                                      trailing: const Icon(Icons.arrow_right_sharp),
                                      ),
                                    ),
                                  ),
                                );
                              }, 
                            );
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
    );
  }
}