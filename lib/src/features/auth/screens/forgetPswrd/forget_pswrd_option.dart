
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_btn.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';


class ForgetPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context)=> Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              forgetPswrdTitletxt, 
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              forgetPswrdSubTitletxt,
              style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),

            ForgetPasswordWidget(
              btnIcon: Icons.mail_outline_outlined,
              title: emailAddrtxt,
              subTitle: resetviaEmailtxt,
              onTap: (){
                // Navigator.push(context,
                //   MaterialPageRoute(
                //     builder: ((context) {
                //       return ForgetPasswordMailScreen();
                //     })
                //   )
                // );
                Navigator.of(context).pushNamed(resetPswrdEmailRoute);
              },
            ),
            const SizedBox(height: 20),

            ForgetPasswordWidget(
              btnIcon: Icons.mobile_friendly_outlined,
              title: phoneNumtxt,
              subTitle: resetViaPhonetxt,
              onTap: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}