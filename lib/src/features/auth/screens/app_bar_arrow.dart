import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final VoidCallback onPress;
  final Color barColor;

  const GeneralAppBar({
    required this.title,
    required this.onPress,
    required this.barColor,
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
      //a image button that lead user to main page on pressed
      actions: const <Widget>[

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