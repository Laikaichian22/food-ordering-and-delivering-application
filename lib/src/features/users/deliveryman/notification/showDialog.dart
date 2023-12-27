import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/send_notify.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/upload_photo_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

//show the confirmation diaglog to send notification to specific user
class showDialogBox extends StatefulWidget {
  const showDialogBox({super.key});

  @override
  State<showDialogBox> createState() => _showDialogBoxState();
}

class _showDialogBoxState extends State<showDialogBox> {
  @override
  void initState() {
    super.initState();
    SendNoti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Send notification'),
          content: const Text('Confirm to send photo delivered to customer'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).pushNamedAndRemoveUntil(
                  uploadPhotoRoute,
                  (route) => false,
                );
                //Navigator.pop(context, 'CANCEL');
                //Navigator.pop(context, 'OK');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await SendNoti.showBigTextNotification(
                    title: "Delivery Sent",
                    body: "Hurry Up! Come take your orders.",
                    //image: "",
                    fln: flutterLocalNotificationsPlugin);
                await Navigator.of(context).pushNamedAndRemoveUntil(
                  deliveryPendingOrderRoute,
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Upload Photo',
          style: TextStyle(
            fontSize: 21,
            color: textBlackColor,
          )),
    );
  }
}
