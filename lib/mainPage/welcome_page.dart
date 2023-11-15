import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('images/homeImage.jpg', height: height*0.6),
            Column(
              children: [
                Text("Welcome to Sister Fen food delivery", style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      //change the border to rounded side
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
                    onPressed: () { 
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute, 
                        (route) => false,
                      );
                      }, 
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),  

                SizedBox(width: 10.0,),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      //change the border to rounded side
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
                    onPressed: () { 
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, 
                        (route) => false,
                      );
                      }, 
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),         
              ],
            )
          ],
        ),
      )
    );
  }
}