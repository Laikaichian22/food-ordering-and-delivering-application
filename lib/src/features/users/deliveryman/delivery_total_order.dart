import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';

class deliveryManTotalOrderPage extends StatefulWidget {
  const deliveryManTotalOrderPage({super.key});

  @override
  State<deliveryManTotalOrderPage> createState() =>
      _deliveryManTotalOrderPageState();
}

class _deliveryManTotalOrderPageState extends State<deliveryManTotalOrderPage> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: deliveryColor,
        title: const Text(
          'All Orders',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildSearchInput(),
          ],
        ),
        // child: SearchAnchor(
        //     builder: (BuildContext context, SearchController controller) {
        //   return SearchBar(
        //     controller: controller,
        //     padding: const MaterialStatePropertyAll<EdgeInsets>(
        //         EdgeInsets.symmetric(horizontal: 16.0)),
        //     onTap: () {
        //       controller.openView();
        //     },
        //     onChanged: (_) {
        //       controller.openView();
        //     },
        //     leading: const Icon(Icons.search),
        //     trailing: <Widget>[
        //       Tooltip(
        //         message: 'Change brightness mode',
        //         child: IconButton(
        //           isSelected: isDark,
        //           onPressed: () {
        //             setState(() {
        //               isDark = !isDark;
        //             });
        //           },
        //           icon: const Icon(Icons.wb_sunny_outlined),
        //           selectedIcon: const Icon(Icons.brightness_2_outlined),
        //         ),
        //       )
        //     ],
        //   );
        // }, suggestionsBuilder:
        //         (BuildContext context, SearchController controller) {
        //   return List<ListTile>.generate(5, (int index) {
        //     final String item = 'item $index';
        //     return ListTile(
        //       title: Text(item),
        //       onTap: () {
        //         setState(() {
        //           controller.closeView(item);
        //         });
        //       },
        //     );
        //   });
        // }),
      ),
    );
  }
}

Widget buildSearchInput() => Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 30,
              color: Colors.grey,
            ),
            Flexible(
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
