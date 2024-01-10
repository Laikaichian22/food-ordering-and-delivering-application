import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_owner_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/a_price_list_page.dart';

class PlaceOrderWidget extends StatefulWidget {
  const PlaceOrderWidget({
    super.key
  });

  @override
  State<PlaceOrderWidget> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrderWidget> {
  final OrderOwnerDatabaseService ownerOrderService = OrderOwnerDatabaseService();
  bool isOrderOpenedForCust = false;
  late Future<void> orderOpenedStateFuture;

  Future<void> loadOrderOpenedState()async{
    List<OrderOwnerModel> openOrders = await ownerOrderService.getOpenOrderList();
    if(openOrders.isNotEmpty){
      isOrderOpenedForCust = true;
    }else{
      isOrderOpenedForCust = false;
    }
  }

  @override
  void initState() {
    super.initState();
    orderOpenedStateFuture = loadOrderOpenedState();
  }

  Widget displayBar(String text, bool opened){
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        color: opened == true ? orderOpenedColor : orderClosedColor
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: opened == true ? Colors.black : const Color.fromARGB(255, 255, 231, 160),
          fontSize: 16
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0, 
            spreadRadius: 0.0, 
            offset: const Offset(
              5.0, 
              5.0, 
            ),
          )
        ],
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: const Color.fromARGB(255, 200, 240, 243),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PriceListPage())
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'images/place_order.png',
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),   
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: orderOpenedStateFuture, 
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            return isOrderOpenedForCust
                            ? displayBar('Order is opening', true)
                            : displayBar('Order closed', false);
                          }else{
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}