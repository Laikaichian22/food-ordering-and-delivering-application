import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/order_cust_db_service.dart';
import 'package:flutter_application_1/services/firestoreDB/user_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';
import 'package:flutter_application_1/src/features/auth/models/user_model.dart';
import 'package:flutter_application_1/src/features/auth/provider/deliverystart_provider.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/delivery_progress/delivery_man_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

class DeliveryManListPage extends StatefulWidget {
  const DeliveryManListPage({super.key});

  @override
  State<DeliveryManListPage> createState() => _DeliveryManListPageState();
}

class _DeliveryManListPageState extends State<DeliveryManListPage> {
  final UserDatabaseService userService = UserDatabaseService();
  final OrderCustDatabaseService custOrderService = OrderCustDatabaseService();
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //var height= MediaQuery.of(context).size.height;
    OrderOwnerModel? currentOrderDelivery = Provider.of<DeliveryStartProvider>(context).currentOrderDelivery;
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Delivery Man List',
          userRole: 'owner', 
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
            child: Column(
              children: [
                currentOrderDelivery == null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 100,
                      width: width,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'No delivery started yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Click 'start' button to start delivery",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 30,
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
                                      fontSize: 19,
                                      color: Colors.black
                                    ),
                                  ),
                                ), 
                              ),
                              const SizedBox(height: 5),
                            ],
                          )
                        ],
                      )
                    ),
                  )
                : Container(),
                const SizedBox(height: 10),
                const Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'Delivey Man List',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                StreamBuilder<List<UserModel>>(
                  stream: userService.getDeliveryManList(), 
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        height: 40,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 197, 197, 197),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('No delivery man registered yet.'),
                      );
                    }else{
                      List<UserModel> deliveryMan = snapshot.data!;
                      return Column(
                        children: deliveryMan.map((delivery){
                          return Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.lime,
                                contentPadding: const EdgeInsetsDirectional.all(10),
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: delivery.fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: purpleColorText
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Phone Number: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: delivery.phone,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: purpleColorText
                                            )
                                          ),
                                          const TextSpan(
                                            text: '\nCar plate Numebr: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: delivery.carPlateNum,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: purpleColorText
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 105, 1, 107),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => ViewDeliveryManProgressPage(userSelected: delivery),
                                  );
                                  Navigator.push(context, route);
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  }
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}