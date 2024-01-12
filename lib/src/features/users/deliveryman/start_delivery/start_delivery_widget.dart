import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/start_delivery/delivery_start_list_page.dart';

class StartDeliveryWidget extends StatefulWidget {
  const StartDeliveryWidget({super.key});

  @override
  State<StartDeliveryWidget> createState() => _StartDeliveryWidgetState();
}

class _StartDeliveryWidgetState extends State<StartDeliveryWidget> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width*0.78,
      height: height*0.21,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shadowColor: const Color.fromARGB(255, 116, 192, 255),
        elevation: 9,
        color: const Color.fromARGB(255, 255, 215, 95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeliveryViewStartDeliveryListPage()
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text(
                  'Start delivery',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(width: 15),
                Image.asset(
                  'images/food_delivery.png',
                  height: 75,
                  width: 75,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}