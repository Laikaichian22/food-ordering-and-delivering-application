import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class CombinedProfilePage extends StatefulWidget {
  const CombinedProfilePage({Key? key}) : super(key: key);

  @override
  State<CombinedProfilePage> createState() => _CombinedProfilePageState();
}

class _CombinedProfilePageState extends State<CombinedProfilePage> {
  final userId = AuthService.firebase().currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          title: const Text(
            profileTitletxt,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                deliveryManRoute,
                (route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 80.0,
                backgroundImage: Image.asset(Assets.images.profile).image,
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: Ben',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.nunitoSans, // Changed fonts to Fonts
                      ),
                    ),
                    Text(
                      'Email Address: Ben10@gmail.com',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily:FontStyle.italic, // Changed fonts to Fonts
                      ),
                    ),
                    Text(
                      'Phone Number: 012-3456789',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: Fonts.nunitoSans, // Changed fonts to Fonts
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
