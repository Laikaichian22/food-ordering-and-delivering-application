import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/change_email.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/change_pswrd.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/privacy_security.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_mail.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delvry_progresspage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_mainpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order_listpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_edit_profile.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_profile.dart';
import 'package:flutter_application_1/src/features/users/business_owner/pay_methodpage.dart';
import 'package:flutter_application_1/src/features/users/customer/cust_homepage.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/cust_profile.dart';
import 'package:flutter_application_1/src/features/users/customer/profile_page/cust_edit_profile.dart';
import 'package:flutter_application_1/src/features/users/customer/test_read_data.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/notification/Notification_page.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_completed_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/profile_page/delivery_edit_profile.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/auth/screens/login/login_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/register/register_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/email_verify/verify_emailpage.dart';
import 'package:flutter_application_1/src/features/auth/screens/welcome/welcome_page.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order_details.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_pending_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/profile_page/delivery_profile.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_total_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/upload_photo_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:path/path.dart';

var customRoute = <String, WidgetBuilder>{
  loginRoute: (context) => const LoginPage(),
  registerRoute: (context) => const Register(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
  welcomeRoute: (context) => const WelcomePage(),
  testReadRoute: (context) => const testRead(),
  resetPswrdEmailRoute: (context) => const ForgetPasswordMailScreen(),
  privacySecurityRoute: (context) => const PrivacyAndSecurity(),
  changePswrdRoute: (context) => const ChangePasswordPage(),
  changeEmailRoute: (context) => const ChangeEmailPage(),

  //----------------------Customer Route------------------------------
  customerRoute: (context) => const CustomerHomePage(),
  custProfileRoute: (context) => const CustomerProfilePage(),
  editCustProfileRoute: (context) => const CustomerEditProfilePage(),
  notificationRoute: (context) => const NotificationPage(),
  //------------------------------------------------------------------

  //---------------------Business Owner Route------------------------------
  businessOwnerRoute: (context) => const BusinessOwnerHomePage(),
  ownrProfileRoute: (context) => const OwnerProfilePage(),
  editOwnerProfileRoute: (context) => const OwnerEditProfilePage(),
  menuMainPageRoute: (context) => const MenuMainPage(),
  orderListPageRoute: (context) => const OrderListPage(),
  payMethodPageRoute: (context) => const PaymentMethodPage(),
  ownerDlvryProgressRoute: (context) => const OwnerDeliveryProgressPage(),
  //-----------------------------------------------------------------------

  //------------------------Deliveryman Route----------------------------
  deliveryManRoute: (context) => const DeliveryManHomePage(),
  deliveryProfileRoute: (context) => const DeliveryManProfilePage(),
  editDeliveryProfileRoute: (context) => const DeliveryEditProfilePage(),
  deliveryCompletedOrderRoute: (context) => const DeliveryManCompletedPage(),
  deliveryPendingOrderRoute: (context) => const DeliveryManPendingPage(),
  deliveryTotalOrderRoute: (context) => const deliveryManTotalOrderPage(),
  uploadPhotoRoute: (context) => const uploadPhotoPage(),
  deliveryOrderDeatilsRoute: (context) => const DeliveryManOrderDetails(),
  //searchOrdersRoute: (context) => const searchOrders(),
  //---------------------------------------------------------------------
};
