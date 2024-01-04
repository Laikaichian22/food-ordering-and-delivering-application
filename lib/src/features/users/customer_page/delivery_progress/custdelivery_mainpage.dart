import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_noarrow.dart';

class CustDeliveryProgressPage extends StatefulWidget {
  const CustDeliveryProgressPage({super.key});

  @override
  State<CustDeliveryProgressPage> createState() => _CustDeliveryProgressPageState();
}

class _CustDeliveryProgressPageState extends State<CustDeliveryProgressPage> {

  @override 
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    Widget buildCircle(String text) {
      return Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    Widget buildArrow() {
      return const Icon(
        Icons.arrow_forward,
        size: 30,
        color: Colors.black,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: const AppBarNoArrow(
          title: 'Lunch order delivery', 
          barColor: custColor
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildCircle('MA1'),
                          buildArrow(),
                          buildCircle('MA2'),
                          buildArrow(),
                          buildCircle('MA3'),
                          buildArrow(),
                          buildCircle('MA4'),
                          buildArrow(),
                          buildCircle('MA5'),
                        ],
                      )
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(160),
                          1: FixedColumnWidth(100),
                        },
                        children: const [
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery process: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'In progress',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Car plate number: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ABC1223',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current location: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MA1',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Next location: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MA2',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated time: ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '5 minutes',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      "Remember to press 'Collect' button to complete the delivery process.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    const Text(
                      'Your order', 
                      style: TextStyle(fontSize: 22),
                    ),

                    StreamBuilder<List<OrderCustModel>>(
                      stream: custOrderService.getOrderById(userID),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            height: 200,
                            width: width,
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                            child: const Text(
                              "You haven't placed any order yet",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }else {
                          List<OrderCustModel> orders = snapshot.data!;
                          orders.sort((a, b) {
                            // First, prioritize 'delivered' status
                            if (a.delivered == 'Yes' && b.delivered != 'Yes') {
                              return -1; // a comes first if 'delivered' is 'Yes'
                            } else if (a.delivered != 'Yes' && b.delivered == 'Yes') {
                              return 1; // b comes first if 'delivered' is 'Yes'
                            } else {
                              // If 'delivered' status is the same, prioritize 'isCollected'
                              if (a.isCollected == 'No' && b.isCollected != 'No') {
                                return -1; // a comes first if 'isCollected' is 'No'
                              } else if (a.isCollected != 'No' && b.isCollected == 'No') {
                                return 1; // b comes first if 'isCollected' is 'No'
                              } else {
                                // If both 'delivered' and 'isCollected' are the same, sort based on dateTime
                                return b.dateTime!.compareTo(a.dateTime!);
                              }
                            }
                          });
                          return Container(
                            height: 360,
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                            child: ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                var widgets = <Widget>[
                                  Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(90),
                                      1: FixedColumnWidth(100),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: ',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orders[index].custName!,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order: ',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orders[index].orderDetails!,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Location: ',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orders[index].destination!,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ];
                                if(orders[index].orderDeliveredImage != '' &&  orders[index].delivered == 'Yes'){
                                  widgets.addAll([
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 320,
                                      padding: const EdgeInsets.all(2),
                                      color: Colors.amber,
                                      child: const Center(
                                        child: Text(
                                          'Delivered',
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black
                                          ),
                                        )
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Image(image: NetworkImage(orders[index].orderDeliveredImage!)),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: orders[index].isCollected == 'No' 
                                          ? const Color.fromARGB(255, 0, 255, 234) 
                                          : const Color.fromARGB(255, 148, 148, 148), 

                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                          ),
                                          elevation: 10,
                                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                        ),
                                        onPressed: orders[index].isCollected == 'No' 
                                        ? ()async{
                                            await custOrderService.updateCollectedStatus(orders[index].id!);
                                          }
                                        : null, 
                                        child: Text(
                                          orders[index].isCollected == 'No' ? 'Collect' : 'Collected',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black
                                          ),
                                        )
                                      ),
                                    )
                                  ]);
                                }else if(orders[index].orderDeliveredImage == '' &&  orders[index].delivered == 'Yes'){
                                  widgets.addAll([
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 320,
                                      padding: const EdgeInsets.all(2),
                                      color: statusYellowColor,
                                      child: const Center(
                                        child: Text(
                                          'Delivered',
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black
                                          ),
                                        )
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: orders[index].isCollected == 'No' 
                                          ? const Color.fromARGB(255, 0, 255, 234) 
                                          : const Color.fromARGB(255, 91, 91, 91), 

                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                          ),
                                          elevation: 10,
                                          shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                        ),
                                        onPressed: orders[index].isCollected == 'No' 
                                        ? ()async{
                                            await custOrderService.updateCollectedStatus(orders[index].id!);
                                          }
                                        : null, 
                                        child: Text(
                                          orders[index].isCollected == 'No' ? 'Collect' : 'Collected',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: orders[index].isCollected == 'No' ? Colors.black : const Color.fromARGB(255, 75, 75, 75)
                                          ),
                                        )
                                      ),
                                    )
                                  ]);
                                }
                                else{
                                  widgets.addAll({
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 320,
                                      padding: const EdgeInsets.all(2),
                                      color: onTheWayBarColor,
                                      child: const Center(
                                        child: Text(
                                          'On the way',
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: yellowColorText
                                          ),
                                        )
                                      ),
                                    ),
                                  });
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    color: orders[index].delivered == 'Yes' ? orderDeliveredColor : orderHasNotDeliveredColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: widgets
                                    ),
                                  ),
                                );
                              }
                            )
                          );
                        }
                      } 
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}