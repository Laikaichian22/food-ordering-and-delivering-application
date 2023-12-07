import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';

class DeliveryManCompletedPage extends StatefulWidget {
  const DeliveryManCompletedPage({super.key});

  @override
  State<DeliveryManCompletedPage> createState() =>
      _DeliveryManCompletedPageState();
}

class _DeliveryManCompletedPageState extends State<DeliveryManCompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 91, 159, 182),
        backgroundColor: deliveryColor,
        centerTitle: true,
        title: const Text(
          'Completed Orders',
          style: TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DeliveryManHomePage()));
          },
        ),
      ),
      body: Column(),
    );
  }
}
