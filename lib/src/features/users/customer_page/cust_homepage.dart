import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/order_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cancel_order/cancel_order_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/delivery_progress/delivery_progress_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_order_widget.dart';
import 'package:provider/provider.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    OrderOwnerModel? currentOrder = Provider.of<OrderProvider>(context).currentOrder;
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    // var width = MediaQuery.of(context).size.width;
    // var height= MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userID),
        appBar: AppBar(
          backgroundColor: custColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children:[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,

                  children: [
                    PlaceOrderWidget(orderOpened: currentOrder),
                    const ViewOrderWidget(),
                    const CancelOrderWidget(),
                    const DeliveryProgressWidget(),
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