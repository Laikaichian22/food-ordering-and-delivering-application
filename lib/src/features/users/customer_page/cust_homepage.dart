import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/customer_page/cancel_order/cancel_order_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/delivery_progress/delivery_progress_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_widget.dart';
import 'package:flutter_application_1/src/features/users/customer_page/view_order/view_order_widget.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  OrderOwnerModel? currentOrderOpened;
  late Future<void> orderOpenedStatusFuture;
  
  Future<void> loadOrderOpenedStatus()async{
    currentOrderOpened = await ownerOrderService.getTheOpenedOrder();
  }

  @override
  void initState() {
    super.initState();
    orderOpenedStatusFuture = loadOrderOpenedStatus();
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userID),
        appBar: DirectAppBarNoArrow(
          title: 'Welcome',
          barColor: custColor, 
          textSize: 0,
          userRole: 'customer'
        ),
        body: FutureBuilder<void>(
          future: orderOpenedStatusFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
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
                        const PlaceOrderWidget(),
                        ViewOrderWidget(orderOpened: currentOrderOpened),
                        const CancelOrderWidget(),
                        DeliveryProgressWidget(orderOpened: currentOrderOpened),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}