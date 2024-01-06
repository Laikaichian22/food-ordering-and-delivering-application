import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class AppBarNoArrow extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final Color barColor;
  final String userRole;

  const AppBarNoArrow({
    required this.title,
    required this.barColor,
    required this.userRole,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: barColor,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        InkWell(
          onTap: (){
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  title: const Text('Confirm to leave this page'),
                  content: const Text('Leaving this page might cause you lose the details entered in this page.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if(userRole == 'deliveryMan'){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            deliveryManRoute,
                            (route) => false,
                          );
                        }else if(userRole == 'owner'){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            businessOwnerRoute,
                            (route) => false,
                          );
                        }else if(userRole == 'customer'){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            customerRoute,
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Confirm'),
                    )
                  ],
                );
              }
            );
          },
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/homeImage.jpg'),
              radius: 24, 
            ),
          ),
        ),
      ],
      
    );
  }
}