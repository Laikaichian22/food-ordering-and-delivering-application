import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';

import '../../../../routing/routes_const.dart';

class AddOrDisplayOrderPage extends StatefulWidget {
  const AddOrDisplayOrderPage({super.key});

  @override
  State<AddOrDisplayOrderPage> createState() => _AddOrDisplayOrderPageState();
}

class _AddOrDisplayOrderPageState extends State<AddOrDisplayOrderPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: '', 
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
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Start your order now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),

                  const SizedBox(height: 30),

                  

                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              orderOpenPageRoute, 
              (route) => false,
            );
          },
          shape: const CircleBorder(
            side: BorderSide()
          ),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}