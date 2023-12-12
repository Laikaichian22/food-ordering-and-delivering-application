import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/mainPage/customer_page/confirm_order_page.dart';
import 'package:flutter_application_1/mainPage/customer_page/cutomer.dart';

class placeOrderPage extends StatefulWidget {
  const placeOrderPage({super.key});

  @override
  State<placeOrderPage> createState() => _placeOrderPageState();
}

class _placeOrderPageState extends State<placeOrderPage> {
  final allchecked = CheckBoxModal(title: 'Select All');
  final checkBoxList = [
    CheckBoxModal(title: 'Main Dish A'),
    CheckBoxModal(title: 'Main Dish B'),
    CheckBoxModal(title: 'Main Dish C'),
    CheckBoxModal(title: 'Main Dish D'),
    CheckBoxModal(title: 'Side Dish A'),
    CheckBoxModal(title: 'Side Dish B'),
    CheckBoxModal(title: 'Side Dish C'),
    CheckBoxModal(title: 'Side Dish D'),
    CheckBoxModal(title: 'Special Dish F'),
    CheckBoxModal(title: 'Special Dish G'),
  ];

  // bool _checkboxSelected = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order'),
      ),
      body: SingleChildScrollView(
        child: Center(
          //center cannot have children but column can
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              //child: Image.asset('images/R.jpeg'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('[Place Order]'),
                  Text('[Lunch Thursday 26/10/2023]'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Email',
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Phone number [e.g 012-345678]',
                      ),
                    ),
                    TextFormField(
                      controller: placeController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Pick up your order at? [e.g MA1]',
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Name',
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 250),
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //change the color of button
                  backgroundColor: Color.fromARGB(
                      255, 240, 145, 3), //change the border to rounded side
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  //construct shadow color
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 92, 90, 85),
                ).copyWith(
                  //change color onpressed
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blue;
                    return null; // Defer to the widget's default.
                  }),
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    menuPageRoute,
                    (route) => false,
                  );
                },
                child: const Text('remember me'),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  children: [
                    Text('[Order 1 [1st pack]'),
                    Text(
                        '[If any of the selection cannot be seen in the list, it means that'),
                    Text('the dishes is SOLD OUT , please select the others]'),
                    // CheckboxListTile(
                    //   value: _checkboxSelected,
                    //   title: const Text('A'),
                    //   activeColor: Colors.red, //选中时的颜色
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _checkboxSelected = value!;
                    //     });
                    //   },
                    // )
                    ListTile(
                        onTap: () => onAllClicked(allchecked),
                        leading: Checkbox(
                          value: allchecked.value,
                          onChanged: (value) => onAllClicked(allchecked),
                        ),
                        title: Text(allchecked.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                    Divider(),
                    ...checkBoxList
                        .map(
                          (item) => ListTile(
                              onTap: () => onItemClicked(item),
                              leading: Checkbox(
                                value: item.value,
                                onChanged: (value) => onItemClicked(item),
                              ),
                              title: Text(item.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        )
                        .toList()
                  ],
                )),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: Color.fromARGB(
                          255, 240, 145, 3), //change the border to rounded side
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      //construct shadow color
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 92, 90, 85),
                    ).copyWith(
                      //change color onpressed
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue;
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        menuPageRoute,
                        (route) => false,
                      );
                    },
                    child: const Text('back'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 250),
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: Color.fromARGB(
                          255, 240, 145, 3), //change the border to rounded side
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      //construct shadow color
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 92, 90, 85),
                    ).copyWith(
                      //change color onpressed
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue;
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () async {
                      Customer customerInfo = Customer(
                          nameController.text,
                          emailController.text,
                          phoneController.text,
                          placeController.text);

                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //   confirmOrderPageRoute,
                      //   (route) => false,
                      // );
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) =>
                              confirmOrderPage(passObj: customerInfo));
                      Navigator.push(context, route);
                    },
                    child: const Text('next'),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  onAllClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      checkBoxList.forEach((element) {
        element.value = newValue;
      });
    });
  }

  onItemClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
    });
  }
}

class CheckBoxModal {
  String title;
  bool value;
  CheckBoxModal({required this.title, this.value = false});
}
