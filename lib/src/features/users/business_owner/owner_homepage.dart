import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delivery_progress/delivery_progress_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/menu_function/menu_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/paymethod_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/price_list_widget.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/order_widget.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class BusinessOwnerHomePage extends StatefulWidget {
  const BusinessOwnerHomePage({super.key});

  @override
  State<BusinessOwnerHomePage> createState() => _BusinessOwnerHomePageState();
}

class _BusinessOwnerHomePageState extends State<BusinessOwnerHomePage> {
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userID),
        appBar: const DirectAppBarNoArrow(
          title: 'Welcome', 
          userRole: 'owner',
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: height*0.9,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: const [
                  PriceListWidget(),
                  MenuWidget(),
                  OrderWidget(),
                  PayMethodWidget(),
                  DeliveryProgressWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}