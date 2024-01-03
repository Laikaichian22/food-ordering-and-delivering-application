
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/provider/deliverystart_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delivey_progress/order_pending.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class OwnerDeliveryProgressPage extends StatefulWidget {
  const OwnerDeliveryProgressPage({super.key});

  @override
  State<OwnerDeliveryProgressPage> createState() => _OwnerDeliveryProgressPageState();
}

class _OwnerDeliveryProgressPageState extends State<OwnerDeliveryProgressPage> {
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height= MediaQuery.of(context).size.height;
    
    OrderOwnerModel? currentOrderDelivery = Provider.of<DeliveryStartProvider>(context).currentOrderDelivery;

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Delivery Progress', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: currentOrderDelivery == null
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: height*0.6,
                  width: width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'No delivery started yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Click 'start' button to start delivery",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                                elevation: 10,
                                shadowColor: const Color.fromARGB(255, 92, 90, 85),
                              ),
                              onPressed: (){
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  orderAddPageRoute, 
                                  (route) => false,
                                );
                              }, 
                              child: const Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black
                                ),
                              )
                            ),
                          )
                        ],
                      )
                      
                    ],
                  )
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder(
                        stream: custOrderService.getOrder(), 
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Container(
                              height: 400,
                              width: 400,
                              decoration: BoxDecoration(
                                border: Border.all()
                              ),
                              child: const Center(
                                child: Text(
                                  "No order",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                )
                              ),
                            );
                          }else{
                            List<OrderCustModel> orders = snapshot.data!;
                            int numOrderUndelivered = orders.where((order)=> order.delivered == 'No').length;
                            int numOrderCompleted = orders.where((order)=> order.delivered == 'Yes').length;
                            return Column(
                              children: [
                                CardWidget(
                                  title: 'Order pending', 
                                  subTitle: 'Total orders: $numOrderUndelivered', 
                                  cardColor: orderHasNotDeliveredColor,
                                  onTap: (){
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context)=> OwnerViewOrderPendingPage(
                                        type: 'Pending',
                                        orderDeliveryOpened: currentOrderDelivery,
                                      )
                                    );
                                    Navigator.push(context, route);
                                  }
                                ),

                                CardWidget(
                                  title: 'Order delivered', 
                                  subTitle: 'Total orders: $numOrderCompleted', 
                                  cardColor: orderDeliveredColor,  
                                  onTap: (){
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context)=> OwnerViewOrderPendingPage(
                                        type: 'Delivered',
                                        orderDeliveryOpened: currentOrderDelivery,
                                      )
                                    );
                                    Navigator.push(context, route);
                                  }
                                )
                              ],
                            );
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ),
          )
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.title,
    required this.subTitle,
    required this.cardColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subTitle;
  final Color cardColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 300,
          height: 150,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      trailing: const Icon(Icons.arrow_right_outlined, size: 35),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          color: textBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}