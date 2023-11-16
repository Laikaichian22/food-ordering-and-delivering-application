import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    required this.color,
    required this.text,
    required this.onPress,
    super.key,
  });

  final Color color;
  final VoidCallback onPress;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30),
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            side: BorderSide(
              width: 1,
              color: Colors.black
            ),
          ),
          elevation: 10,
          shadowColor: const Color.fromARGB(255, 92, 90, 85),
        ).copyWith( 
          overlayColor: MaterialStateProperty
          .resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(
                  MaterialState.pressed))
                return Colors.blue;
              return null;
            }
          ),
        ),
        onPressed: () {
          onPress;
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20
          ),
        ),
      ),
    );
  }
}