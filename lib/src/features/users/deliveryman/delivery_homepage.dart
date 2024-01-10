import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_noarrow.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/cash_on_hand/cash_onhand_widget.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/start_delivery/delivery_start_list_page.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/total_order/total_order_widget.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/completed_order/total_ordercompleted_widget.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/pending_order/total_orderpending_widget.dart';

class DeliveryManHomePage extends StatefulWidget {
  const DeliveryManHomePage({super.key});

  @override
  State<DeliveryManHomePage> createState() => _DeliveryManHomePageState();
}

class _DeliveryManHomePageState extends State<DeliveryManHomePage> {
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  OrderOwnerModel? currentOrderForDelivery;
  late Future<void> orderDeliveryStatusFuture;
  
  Future<void> loadOrderDeliveryState()async{
    currentOrderForDelivery = await ownerOrderService.getOrderOpenedForDelivery();
  }

  @override
  void initState() {
    super.initState();
    orderDeliveryStatusFuture = loadOrderDeliveryState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userId),
        appBar: DirectAppBarNoArrow(
          title: 'Welcome', 
          barColor: deliveryColor, 
          textSize: 0,
          userRole: 'deliveryMan'
        ),
        body: FutureBuilder<void>(
          future: orderDeliveryStatusFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width * 0.75,
                    height: height*0.2,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shadowColor: const Color.fromARGB(255, 116, 192, 255),
                      elevation: 9,
                      color: const Color.fromARGB(255, 255, 215, 95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryViewStartDeliveryListPage()
                            )
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Text(
                                'Start delivery',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              const SizedBox(width: 20),
                              Image.asset(
                                'images/food_delivery.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: [
                        const TotalOrders(),
                        TotalPendingOrders(orderDeliveryOpened: currentOrderForDelivery),
                        TotalCompletedOrders(orderDeliveryOpened: currentOrderForDelivery),
                        const TotalCashOnHand(),
                      ]
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