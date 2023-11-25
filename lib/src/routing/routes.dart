import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_mail.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_profile.dart';
import 'package:flutter_application_1/src/features/users/customer/cust_homepage.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/cust_profile.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/edit_profile.dart';
import 'package:flutter_application_1/src/features/users/customer/test_read_data.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/auth/screens/login/login_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/register/register_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/email_verify/verify_email_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/welcome/welcome_page.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

var customRoute = <String, WidgetBuilder>{
  loginRoute: (context) => const LoginPage(),
  registerRoute:(context) => const Register(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
  welcomeRoute: (context) => const WelcomePage(),
  customerRoute: (context) => const CustomerHomePage(),
  businessOwnerRoute: (context) => const BusinessOwnerHomePage(),
  deliveryManRoute: (context) => const DeliveryManHomePage(),
  custProfileRoute: (context) => const CustomerProfilePage(),
  ownrProfileRoute :(context) => const OwnerProfilePage(),
  deliveryProfileRoute :(context) => const DeliveryManProfilePage(),
  editProfileRoute: (context) => const EditProfilePage(),
  testReadRoute: (context) => const testRead(),
  resetPswrdEmailRoute:(context) => const ForgetPasswordMailScreen(),
};