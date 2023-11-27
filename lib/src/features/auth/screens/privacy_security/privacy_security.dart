import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PrivacyAndSecurity extends StatefulWidget {
  const PrivacyAndSecurity({super.key});

  @override
  State<PrivacyAndSecurity> createState() => _PrivacyAndSecurityState();
}

class _PrivacyAndSecurityState extends State<PrivacyAndSecurity> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), 
            onPressed: () { 
              Navigator.of(context).pushNamedAndRemoveUntil(
                businessOwnerRoute, 
                (route) => false,
              );
            },
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.6,
            padding: const EdgeInsets.all(tPaddingSize),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Update Your Account',
                  style: TextStyle(
                    fontSize: 29, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                  'Maintain the safety of account.',
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
            
                const SizedBox(height: 50),
            
                ListTile(
                  shape: BeveledRectangleBorder(
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  contentPadding: const EdgeInsetsDirectional.all(10),
                  leading: const Icon(
                    Icons.email_sharp,
                    size: 35,
                  ),
                  title: const Text('Update email', style: TextStyle(fontSize: 22, color: Colors.black)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 35,
                  ),
                  onTap: (){},

                ),
        
                const SizedBox(height: 30),
            
                ListTile(
                  shape: BeveledRectangleBorder(
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  contentPadding: const EdgeInsetsDirectional.all(10),
                  leading: const Icon(
                    Icons.lock_outline,
                    size: 35,
                  ),
                  title: const Text('Update password', style: TextStyle(fontSize: 22, color: Colors.black)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 35,
                  ),
                  onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      changePswrdRoute, 
                      (route) => false,
                    );
                  },
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}