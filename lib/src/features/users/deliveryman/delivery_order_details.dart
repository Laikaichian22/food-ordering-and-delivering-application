import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_homepage.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_pending_order.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class DeliveryManOrderDetails extends StatefulWidget {
  const DeliveryManOrderDetails({super.key});

  @override
  State<DeliveryManOrderDetails> createState() =>
      _DeliveryManOrderDetailsState();
}

class _DeliveryManOrderDetailsState extends State<DeliveryManOrderDetails> {
  // final List<DeliveryOrder> orderList = [
  //   DeliveryOrder("Jack", "QFSD34234", "29 Jun 2023", "6:45 PM", "COD",
  //       "Done paid", "RM6.00", "On the way"),
  //   DeliveryOrder("Jack", "YBDD43823", "15 Nov 2023", "3:45 PM", "Touch N Go",
  //       "Done paid", "RM6.50", "On the way"),
  //   DeliveryOrder("Jack", "DFDD43823", "15 Nov 2023", "5:45 PM", "Touch N Go",
  //       "Done paid", "RM6.00", "On the way"),
  //   DeliveryOrder("Jack", "TGFG43823", "15 Nov 2023", "2:45 PM", "Touch N Go",
  //       "Not yet paid", "RM6.50", "On the way"),
  //   DeliveryOrder("Jack", "ERGF43823", "15 Nov 2023", "3:00 PM", "Touch N Go",
  //       "Not yet paid", "RM7.00", "On the way"),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deliveryColor,
        title: const Text(
          'Order id',
          style: TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryManPendingPage()));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: new EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 20.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    5.0, // Move to right 10  horizontally
                    5.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: Color.fromARGB(255, 191, 220, 182),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/id.png",
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        Text('Name'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/destination.png",
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        Text('MA1'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/payment_method.png",
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        Text('COD'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/payment_status.png",
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        Text('Not paid yet'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/phone.png",
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        Text('012-12345645'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: OrdersPackage(),
          ),
        ],
      ),
    );
  }
}

class OrdersPackage extends StatelessWidget {
  const OrdersPackage({super.key});

  @override
  Widget build(BuildContext context) {
    TableRow _tableRow = const TableRow(
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Order"),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Remark"),
          ),
        )
      ],
    );
    TableRow _tableRow2 = const TableRow(
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("D1"),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("less kuah more rice no onion"),
          ),
        )
      ],
    );
    return Container(
      //width: MediaQuery.of(context).size.width * 0.94,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Material(
              color: Color.fromARGB(255, 191, 220, 182),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Table(
                  border: TableBorder.all(),
                  defaultColumnWidth: const FixedColumnWidth(120.0),
                  children: <TableRow>[
                    _tableRow,
                    _tableRow2,
                    _tableRow,
                    _tableRow,
                    _tableRow,
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
