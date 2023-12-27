import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order_details.dart';
import 'package:flutter_application_1/src/features/users/deliveryman/selected_order_manager.dart';

class DeliveryManPendingPage extends StatefulWidget {
  const DeliveryManPendingPage({super.key});

  @override
  State<DeliveryManPendingPage> createState() => _DeliveryManPendingPageState();
}

class _DeliveryManPendingPageState extends State<DeliveryManPendingPage> {

  final searchBarController = TextEditingController();
  List<DeliveryOrder> orderList = allOrders;
  bool isDark = false;
  HashSet<DeliveryOrder> selectedItem = HashSet();
  List<String> selectedOrderIds = [];
  List<String> getSelectedOrderIds() {
    return selectedOrderIds;
  }

  bool isMultiSelectionEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deliveryColor,
        centerTitle: isMultiSelectionEnabled ? false : true,
        leading: isMultiSelectionEnabled
        ? IconButton(
          onPressed: () {
            selectedItem.clear();
            isMultiSelectionEnabled = false;
            setState(() {});
          },
          icon: const Icon(Icons.close))
        : IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              //Navigator.push(context,MaterialPageRoute(builder: (context) => const DeliveryManHomePage()));
            },
          ),
        title: Text(
          isMultiSelectionEnabled ? getSelectedItemCount() : "Running Orders",
          style: const TextStyle(
            fontSize: 20,
            color: textBlackColor,
          ),
        ),
        actions: [
          Visibility(
            visible: selectedItem.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                selectedItem.forEach((nature) {
                  orderList.remove(nature);
                });
                selectedItem.clear();
                setState(() {});
              },
            )
          ),
          Visibility(
            visible: selectedItem.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            )
          ),
          Visibility(
            visible: isMultiSelectionEnabled,
            child: IconButton(
              icon: Icon(
                Icons.select_all,
                color: selectedItem.length == orderList.length
                    ? Colors.red
                    : Colors.black,
              ),
              onPressed: () {
                if (selectedItem.length == orderList.length) {
                  selectedItem.clear();
                } else {
                  for (int index = 0; index < orderList.length; index++) {
                    selectedItem.add(orderList[index]);
                  }
                }
                setState(() {});
              },
            )
          ),
          Visibility(
            visible: isMultiSelectionEnabled,
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => uploadPhotoPage()));
                setState(() {});
              },
            ),
          ),
        ],
      ),
      
      body: Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: searchBarController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search order',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onChanged: searchOrders,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children:
                orderList.map((DeliveryOrder nature) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: 150.0,
                    child: getListItem(nature),
                  )
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
    ? "${selectedItem.length} item selected"
    : "No item selected";
  }

  void doMultiSelection(DeliveryOrder nature) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(nature)) {
        selectedItem.remove(nature);
        //remove userid that want to push message to specific users in notification page
        selectedOrderIds.remove(nature.id);
        SelectedOrdersManager.selectedOrders.remove(nature);
      } else {
        selectedItem.add(nature);
        //add or return userid to push message to specific users in notification page (into a list)
        selectedOrderIds.add(nature.id);
        SelectedOrdersManager.addToSelectedOrders(nature);
      }
      setState(() {});
    } else {
    }
  }

  InkWell getListItem(DeliveryOrder nature) {
    return InkWell(
      onTap: () {
        doMultiSelection(nature);
      },
      onLongPress: () {
        isMultiSelectionEnabled = true;
        doMultiSelection(nature);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              //color:selectedItem = ?,
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
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: isMultiSelectionEnabled
                ? const Color.fromARGB(255, 242, 183, 252)
                : const Color.fromARGB(255, 191, 220, 182),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: !isMultiSelectionEnabled
                  ? () {
                      debugPrint('Card tapped.');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryManOrderDetails()));
                    }
                  : () => () {

                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        //alignment: Alignment.topLeft,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.space,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Need to read from firestore
                                Text(
                                  nature.id,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                SizedBox(
                                  height: 23,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: const Color.fromARGB(255, 13, 44, 198),
                                    ), 
                                    child: Text(
                                      nature.deliveryStatus,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        color: Color.fromARGB(255, 255, 255, 255),
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                  "Payment Type: ",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                  )
                                ),
                                Text(
                                  nature.paymentType,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                  )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${nature.date} ${nature.time}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                                
                                Text(nature.price,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isMultiSelectionEnabled,
                        child: Icon(
                          selectedItem.contains(nature)
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 30,
                          color: Colors.red,
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
          },
        ),
      ),
    );
  }

  void searchOrders(String query) {
    final suggestions = allOrders.where((order) {
      final orderTitle = order.destination.toLowerCase();
      final input = query.toLowerCase();
      return orderTitle.contains(input);
    }).toList();
    setState(() => orderList = suggestions);
  }
}

//card for orders
class RunningOrders extends StatelessWidget {
  const RunningOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 20.0, 
                spreadRadius: 0.0, 
                offset: const Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Material(
              color: const Color.fromARGB(255, 191, 220, 182),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      //alignment: Alignment.topLeft,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.space,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Need to read from firestore
                              const Text(
                                '#Order id',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              SizedBox(
                                height: 23,
                                width: 100,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: const Color.fromARGB(255, 13, 44, 198),
                                  ), //Need to read from firestore
                                  child: const Text(
                                    'On the way',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const Row(
                            children: <Widget>[
                              Text(
                                'Payment Type: ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                )
                              ),
                              //Need to read from the firestore
                              Text(
                                'Cash or Touch N GO',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                )
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '20 Dec 2023, 6:45 AM',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                )
                              ),
                              //Need to read from the firestore
                              Text(
                                'RM 6.00',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                            ],
                          )
                        ],
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
