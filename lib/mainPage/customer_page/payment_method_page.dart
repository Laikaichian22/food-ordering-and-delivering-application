import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';

class paymentMethodPage extends StatefulWidget {
  const paymentMethodPage({super.key});

  @override
  State<paymentMethodPage> createState() => _paymentMethodPageState();
}

class _paymentMethodPageState extends State<paymentMethodPage> {
  final checkBoxList = [
    CheckBoxModal(title: 'Cash on Delivery'),
    CheckBoxModal(title: 'paid TNG'),
    CheckBoxModal(title: 'paid Online Bank Transfer'),
    CheckBoxModal(title: 'Replace Meal'),
    CheckBoxModal(title: 'paid TNG[Attach receipt after submission]'),
    CheckBoxModal(
        title: 'paid Online Bank Transfer[Attach receipt after submission]'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order'),
      ),
      body: Center(
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
                Text('[-------------------------]'),
                Text('[Order Details]'),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              decoration: BoxDecoration(
                border: new Border.all(color: Colors.black, width: 0.5),
              ),
              child: Column(
                children: [
                  Text('payment method'),
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
                margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                height: 40,
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
                      confirmOrderPageRoute,
                      (route) => false,
                    );
                  },
                  child: const Text('back'),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(200, 40, 20, 20),
                height: 40,
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
                      cashMethodPageRoute,
                      (route) => false,
                    );
                  },
                  child: const Text('next'),
                ),
              ),
            ],
          )
        ]),
      ),
    );
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
