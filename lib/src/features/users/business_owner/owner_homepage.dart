import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/screens/drawer.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class BusinessOwnerHomePage extends StatefulWidget {
  const BusinessOwnerHomePage({super.key});

  @override
  State<BusinessOwnerHomePage> createState() => _BusinessOwnerHomePageState();
}

class _BusinessOwnerHomePageState extends State<BusinessOwnerHomePage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerFunction(userId: userID),
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CardWidget(
                title: 'Menu', 
                iconBtn: Icons.food_bank_outlined,
                subTitle: 'Create your own menu',
                cardColor: Colors.amber, 
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    menuMainPageRoute, 
                    (route) => false,
                  );
                },
              ),
              CardWidget(
                title: 'Price List', 
                iconBtn: Icons.food_bank_outlined,
                subTitle: 'Create price list',
                cardColor: Colors.amber, 
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    priceListRoute, 
                    (route) => false,
                  );
                },
              ),
              CardWidget(
                title: 'Order', 
                iconBtn: Icons.list_outlined,
                subTitle: 'open order and view order list',
                cardColor: Colors.amber,
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    orderAddPageRoute,
                    (route) => false,
                  );
                },
              ),
              CardWidget(
                title: 'Payment Method', 
                iconBtn: Icons.payment_outlined,
                subTitle: 'Add payment methods',
                cardColor: Colors.amber,
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    payMethodPageRoute, 
                    (route) => false,
                  );
                },
              ),
              CardWidget(
                title: 'Delivery Progress', 
                iconBtn: Icons.delivery_dining_outlined,
                subTitle: 'Keep track of progress',
                cardColor: Colors.amber,
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    ownerDeliveryManListRoute, 
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.title,
    required this.iconBtn,
    required this.subTitle,
    required this.cardColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subTitle;
  final Color cardColor;
  final VoidCallback onTap;
  final IconData iconBtn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.75,
          height: MediaQuery.of(context).size.height*0.18,
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
                  //image: DecorationImage(image:, fit:BoxFit.fitWidth),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      trailing: Icon(iconBtn, size: 35),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: textBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 15,
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