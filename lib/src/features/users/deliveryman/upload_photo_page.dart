import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_edit_photo.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_edit_profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class uploadPhotoPage extends StatefulWidget {
  const uploadPhotoPage({super.key});

  @override
  State<uploadPhotoPage> createState() => _uploadPhotoPageState();
}

class _uploadPhotoPageState extends State<uploadPhotoPage> {
  var size, heightMax, widthMax;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightMax = size.height;
    widthMax = size.width;

    final userId = AuthService.firebase().currentUser?.id;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: deliveryColor,
          title: const Text(
            "Upload Photo Delivered",
            style: TextStyle(
              fontSize: 20,
              color: textBlackColor,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                deliveryProfileRoute,
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back_outlined, color: iconBlackColor),
          ),
        ),
        body: Column(
          children: [
            EditPhotoWidget(
                userId: userId.toString(), colorUsed: deliveryColor),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //change the color of button
                      backgroundColor: deliveryColor,
                      minimumSize: const Size(188, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      //change the border to rounded side
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        side: BorderSide(width: 1, color: Colors.black),
                      ),
                      //construct shadow color
                      elevation: 10,
                      shadowColor: shadowClr,
                    ).copyWith(
                      //change color onpressed
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue;
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Upload Photo",
                      style: TextStyle(color: textBlackColor, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     backgroundColor: deliveryColor,
    //     title: const Text(
    //       'Upload Photo Delivered',
    //       style: TextStyle(
    //         fontSize: 20,
    //         color: textBlackColor,
    //       ),
    //     ),
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back, color: Colors.black),
    //       onPressed: () {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => DeliveryManHomePage()));
    //       },
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       Center(
    //         child: SizedBox(
    //           height: 50,
    //           child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               //change the color of button
    //               backgroundColor: deliveryColor,
    //               minimumSize: const Size(188, 36),
    //               padding: const EdgeInsets.symmetric(horizontal: 16),
    //               //change the border to rounded side
    //               shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(25)),
    //                 side: BorderSide(width: 1, color: Colors.black),
    //               ),
    //               //construct shadow color
    //               elevation: 10,
    //               shadowColor: shadowClr,
    //             ).copyWith(
    //               //change color onpressed
    //               overlayColor: MaterialStateProperty.resolveWith<Color?>(
    //                   (Set<MaterialState> states) {
    //                 if (states.contains(MaterialState.pressed))
    //                   return Colors.blue;
    //                 return null; // Defer to the widget's default.
    //               }),
    //             ),
    //             onPressed: () {},
    //             child: const Text(
    //               "Upload Photo",
    //               style: TextStyle(color: textBlackColor, fontSize: 20),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
