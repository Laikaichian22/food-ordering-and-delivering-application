import 'package:flutter/material.dart';

import 'package:flutter_application_1/src/routing/routes_const.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bottomContainer({required String image, required String name}) {
      return Container(
        height: 250,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(image),
          ),
          ListTile(
            leading: Text(
              name,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                Icon(
                  Icons.star,
                  color: Colors.white,
                )
              ],
            ),
          )
        ]),
      );
    }

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
                  Text(
                    '[Todays Menu]',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                  border: new Border.all(color: Color(0xFFFF0000), width: 0.5),
                  borderRadius: BorderRadius.circular((8)),
                ),
                child: Column(
                  children: [
                    Text(
                      'main dishes',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              height: 520,
              child: GridView.count(
                shrinkWrap: false,
                primary: false,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  bottomContainer(image: 'images/R.jpg', name: 'Fried Chicken'),
                  bottomContainer(image: 'images/R.jpg', name: 'Fried Chicken'),
                  bottomContainer(image: 'images/R.jpg', name: 'Fried Chicken'),
                  bottomContainer(image: 'images/R.jpg', name: 'Fried Chicken'),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: new Border.all(color: Color(0xFFFF0000), width: 0.5),
                  borderRadius: BorderRadius.circular((8)),
                ),
                child: Column(
                  children: [
                    Text(
                      'side dishes',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              height: 520,
              child: GridView.count(
                shrinkWrap: false,
                primary: false,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  bottomContainer(image: 'images/R.jpg', name: 'vegetables'),
                  bottomContainer(image: 'images/R.jpg', name: 'vegetables'),
                  bottomContainer(image: 'images/R.jpg', name: 'vegetables'),
                  bottomContainer(image: 'images/R.jpg', name: 'vegetables'),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        detailRoute,
                        (route) => false,
                      );
                    },
                    child: const Text('back'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(210, 20, 20, 20),
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
                        placeOrderPageRoute,
                        (route) => false,
                      );
                    },
                    child: const Text('next'),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
