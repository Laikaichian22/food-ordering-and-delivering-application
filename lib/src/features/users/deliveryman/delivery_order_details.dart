import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';

//one click in every order to view the details of the orders
class DeliveryManOrderDetails extends StatefulWidget {
  const DeliveryManOrderDetails({super.key});

  @override
  State<DeliveryManOrderDetails> createState() => _DeliveryManOrderDetailsState();
}

class _DeliveryManOrderDetailsState extends State<DeliveryManOrderDetails> {
  
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 20.0, 
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
                color: const Color.fromARGB(255, 191, 220, 182),
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
                        const Text('Name'),
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
                        const Text('MA1'),
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
                        const Text('COD'),
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
                        const Text('Not paid yet'),
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
                        const Text('012-12345645'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const OrdersPackage(),
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
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
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
            color: const Color.fromARGB(255, 191, 220, 182),
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
            )
          ),
        ),
      ),
    );
  }
}
