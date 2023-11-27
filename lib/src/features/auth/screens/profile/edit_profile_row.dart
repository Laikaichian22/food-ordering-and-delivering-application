import 'package:flutter/material.dart';

class EditProfileRows extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const EditProfileRows({
    required this.title,
    required this.value,
    required this.iconData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 15)),
          leading: Icon(iconData),
          trailing: Text(value,  style: TextStyle(fontSize: 16)),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}