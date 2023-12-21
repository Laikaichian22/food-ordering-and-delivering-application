import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/order/view_order.dart';
import 'package:intl/intl.dart';
import '../../../../routing/routes_const.dart';

class AddOrDisplayOrderPage extends StatefulWidget {
  const AddOrDisplayOrderPage({super.key});

  @override
  State<AddOrDisplayOrderPage> createState() => _AddOrDisplayOrderPageState();
}

class _AddOrDisplayOrderPageState extends State<AddOrDisplayOrderPage> {
    
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
    } else {
      return 'N/A';
    }
  }
  Widget buildOrderTile(OrderOwnerModel order, double width, double height){
    return InkWell(
      onTap: (){
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ViewOrderPage(
            orderSelected: order
          )
        );
        Navigator.push(context, route);
      },
      child: Container(
        width: width*0.75,
        height: height*0.12,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 117, 117, 117),
              offset: Offset(0, 6)
            )
          ]
        ),
        child: Column(
          children: [
            Text(
              'Order Name: ${order.orderName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),const SizedBox(height:10),
            Text(
              'Start time: ${_formatDateTime(order.startTime)}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              'End time: ${_formatDateTime(order.endTime)}',
              style: const TextStyle(
                fontSize: 15,
              ),
            )
          ],
        ),
      )
    );
  }
  OrderOwnerDatabaseService orderService = OrderOwnerDatabaseService();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: '', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Start your order now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),

                  const SizedBox(height: 30),

                  StreamBuilder<List<OrderOwnerModel>>(
                    stream: orderService.getOrderMethods(),
                    builder: (context, AsyncSnapshot<List<OrderOwnerModel>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      List<OrderOwnerModel>? orderMethods = snapshot.data;
                      if (orderMethods == null || orderMethods.isEmpty) {
                        return Container(
                          width: width * 0.75,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 255, 196, 108)),
                            color: const Color.fromARGB(255, 255, 196, 108),
                          ),
                          child: const Center(
                            child: Text(
                              'No order available',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: orderMethods.map(
                          (order) {
                            return buildOrderTile(order, width, height);
                          },
                        ).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              orderOpenPageRoute, 
              (route) => false,
            );
          },
          shape: const CircleBorder(
            side: BorderSide()
          ),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}