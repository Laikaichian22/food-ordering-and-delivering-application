import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/mainPage/customer_page/cust_homepage.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

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
                Text('[Price List]'),
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
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00'),
                  Text('1 mian dish = RM5.00')
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
                      customerRoute,
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
                      menuPageRoute,
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
}
