import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class GeneralDirectAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final VoidCallback onPress;
  final Color barColor;
  final String userRole;

  const GeneralDirectAppBar({
    required this.title,
    required this.onPress,
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
          onTap: () {
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
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/homeImage.jpg'),
              radius: 22, 
              backgroundColor: drawerColor
            ),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: onPress,
        icon: const Icon(
          Icons.arrow_back_outlined, 
          color: iconWhiteColor
        ),
      ),
    );
  }
}