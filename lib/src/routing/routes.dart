import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/change_email.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/change_pswrd.dart';
import 'package:flutter_application_1/src/features/auth/screens/privacy_security/privacy_security.dart';
import 'package:flutter_application_1/src/features/auth/screens/forgetPswrd/forget_pswrd_mail.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/pricelist_page.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_function.dart/delvry_progresspage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/choose_paymethod.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_add_dish.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_completed.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_mainpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/create_price_list.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/fpx_method/fpx.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/tng_method/tng_page.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_function.dart/order_listpage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_function.dart/owner_edit_profile.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_homepage.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_function.dart/owner_profile.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/create_paymethod_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cash_on_delivery_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/confirm_order_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cust_homepage.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cust_profile.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cutomer.dart';
import 'package:flutter_application_1/src/features/users/customer_page/edit_profie.dart';
import 'package:flutter_application_1/src/features/users/customer_page/menu_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/payment_method_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order_page.dart';
import 'package:flutter_application_1/src/features/users/customer_page/price_list_page.dart';
// import 'package:flutter_application_1/src/features/users/customer/cust_homepage.dart';
// import 'package:flutter_application_1/src/features/users/customer/profile_page/cust_profile.dart';
// import 'package:flutter_application_1/src/features/users/customer/profile_page/cust_edit_profile.dart';
// import 'package:flutter_application_1/src/features/users/customer/test_read_data.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_edit_profile.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/auth/screens/login/login_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/register/register_page.dart';
import 'package:flutter_application_1/src/features/auth/screens/email_verify/verify_emailpage.dart';
import 'package:flutter_application_1/src/features/auth/screens/welcome/welcome_page.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

var customRoute = <String, WidgetBuilder>{
  loginRoute: (context) => const LoginPage(),
  registerRoute: (context) => const Register(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
  welcomeRoute: (context) => const WelcomePage(),

  resetPswrdEmailRoute: (context) => const ForgetPasswordMailScreen(),
  privacySecurityRoute: (context) => const PrivacyAndSecurity(),
  changePswrdRoute: (context) => const ChangePasswordPage(),
  changeEmailRoute: (context) => const ChangeEmailPage(),

  //----------------------Customer Route------------------------------
  customerRoute: (context) => const CustomerHomePage(),
  menuPageRoute: (context) => const MenuPage(),
  confirmOrderPageRoute: (context) => const placeOrderPage(),
  cashMethodPageRoute: (context) => const cashPage(),
  detailRoute: (context) => const DetailPage(),
  placeOrderPageRoute: (context) => const placeOrderPage(),
  custProfileRoute: (context) => const CustomerProfilePage(),
  editProfileRoute: (context) => const EditProfilePage(),
  paymentMethodPageRoute: (context) => const paymentMethodPage(),

  //------------------------------------------------------------------

  //---------------------Business Owner Route------------------------------
  businessOwnerRoute: (context) => const BusinessOwnerHomePage(),
  ownrProfileRoute: (context) => const OwnerProfilePage(),
  editOwnerProfileRoute: (context) => const OwnerEditProfilePage(),
  menuMainPageRoute: (context) => const MenuMainPage(),
  menuAddDishRoute: (context) => const MenuAddDishPage(),
  //-----------------------Price list--------------------------------------
  priceListCreatingRoute: (context) => const CreatePriceListPage(),
  priceListRoute: (context) => const PriceListMainPage(),
  //-----------------------------------------------------------------------
  menuCompletedRoute: (context) => const MenuCompletedPage(),
  orderListPageRoute: (context) => const OrderListPage(),
  payMethodPageRoute: (context) => const PaymentMethodPage(),
  choosePayMethodRoute: (context) => const ChoosePaymentMethodPage(),
  payMethodTnGRoute: (context) => const TouchNGoPage(),
  payMethodOnlineBankingRoute: (context) => const OnlineBankingPage(),
  ownerDlvryProgressRoute: (context) => const OwnerDeliveryProgressPage(),
  //-----------------------------------------------------------------------

  //------------------------Deliveryman Route----------------------------
  deliveryManRoute: (context) => const DeliveryManHomePage(),
  deliveryProfileRoute: (context) => const DeliveryManProfilePage(),
  editDeliveryProfileRoute: (context) => const DeliveryEditProfilePage(),
  //---------------------------------------------------------------------
};
