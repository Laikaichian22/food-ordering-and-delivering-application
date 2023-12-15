import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/owner_function.dart/order_class.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {

  List<OrderModel> orderLists = [
    OrderModel(id: '1', name: 'girl', dateTime: '', destination: 'MA1', remark: 'HERERW', payAmount: 6.5, payMethod: "Touch'n Go", orderDetails: 'A12'),
    OrderModel(id: '2', name: 'boy', dateTime: '', destination: 'MA4', remark: '', payAmount: 7.5, payMethod: "Cash On delivery", orderDetails: 'A22'),
    OrderModel(id: '3', name: 'boy12', dateTime: '', destination: 'D01', remark: '', payAmount: 8.5, payMethod: "Online banking", orderDetails: 'D32'),
  ];




  String? currentItemSelected;
  List<String> featuresList = <String>[
    'Sorting', 
    'Highlight', 
    'Grouping', 
    'Default'
  ];

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Order List', 
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
                  const SizedBox(height: 10),
                  Container(
                    height: height*0.07,
                    width: width*0.7,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: IconButton(
                          onPressed: (){
                            searchController.clear();
                          }, 
                          icon: const Icon(Icons.clear),
                        ),
                        prefixIcon: IconButton(
                          onPressed: (){
              
                          }, 
                          icon: const Icon(Icons.search)
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      //menu, data and day will change depends on the day and menu name
                      Table(
                        defaultColumnWidth: const FixedColumnWidth(100),
                        border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.none,
                        ),
                        children: [
                          TableRow(
                            children: [
                              const Column(
                                children: [
                                  Text('Menu:'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Lunch'),
                                ],
                              ),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Column(
                                children: [
                                  Text('Date:'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('26/11/2023'),
                                ],
                              ),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Column(
                                children: [
                                  Text('Day:'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Thursday'),
                                ],
                              ),
                            ]
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      DropdownMenu<String>(
                        width: 130,
                        hintText: 'Features',
                        onSelected: (String? value){
                          setState(() {
                            currentItemSelected;
                          });
                        },
                        dropdownMenuEntries: featuresList.map<DropdownMenuEntry<String>>((String newValue) {
                          return DropdownMenuEntry<String>(value: newValue, label: newValue);
                        }).toList(),
                      )

                    ],
                  ),
                  const SizedBox(height: 30),

                  // this label is fixed, the data row will add in automatically
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Table(
                  //     defaultColumnWidth: const FixedColumnWidth(200),
                  //     border: TableBorder.all(
                  //       color: Colors.black,
                  //       style: BorderStyle.solid,
                  //     ),
                  //     children: const [
                  //       TableRow(
                  //         children: [
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Timestamp',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Destination',
                  //                 textAlign: TextAlign.center,
                  //               ),
                                
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Name',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Order 1 [1st Pack]',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Order2+Order3 [2nd pack or more]',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text('Remark'),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Payment method',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 'Payment amount',
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //         ]
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // FutureBuilder<List<OrderModel>>(
                  //   future: future, 
                  //   builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
                  //     if(!snapshot.hasData){
                  //       return const Center(child: CircularProgressIndicator());
                  //     }else{
                  //       return OrderClass(datalist: snapshot.data as List<OrderModel>);
                  //     }
                  //   })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}