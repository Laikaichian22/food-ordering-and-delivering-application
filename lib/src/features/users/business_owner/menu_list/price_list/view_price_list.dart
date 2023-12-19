import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/edit_price_list.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class ViewPriceListPage extends StatelessWidget {
  const ViewPriceListPage({
    required this.priceListSelected,
    super.key
  });

  final PriceListModel priceListSelected;

  @override
  Widget build(BuildContext context) {    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'View Price List', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              priceListRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.05,
                        width: width*0.25,
                        child: const Text(
                          "List's name: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Container(
                        padding: const EdgeInsets.all(5),
                        height: height*0.05,
                        width: width*0.55,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: Text(
                          priceListSelected.listName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width*0.25,
                        child: const Text(
                          "List's Description: ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Container(
                        padding: const EdgeInsets.all(5),
                        
                        width: width*0.55,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: Text(
                          priceListSelected.priceDesc,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: (){
                        MaterialPageRoute route = MaterialPageRoute(builder: (context) => EditPriceListPage(priceListSelected: priceListSelected));
                        Navigator.push(context, route);
                      }, 
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}