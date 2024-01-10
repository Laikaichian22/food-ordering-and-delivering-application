import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PriceListPage extends StatefulWidget {
  const PriceListPage({super.key});

  @override
  State<PriceListPage> createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PriceListPage> {
  late Future<void> priceListStateFuture;
  final PriceListDatabaseService priceListService = PriceListDatabaseService();
  PriceListModel? getOpenedPriceList;

  Future<void> loadPriceListState()async{
    getOpenedPriceList = await priceListService.getOpenPriceList();
  }
  
  @override
  void initState() {
    super.initState();
    priceListStateFuture = loadPriceListState();
  }

  Widget buildPriceList(String id){
    return FutureBuilder<PriceListModel?>(
      future: PriceListDatabaseService().getPriceListDetails(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return buildErrorTile("Error loading price list details");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return buildErrorTile("No data available for the selected price list");
        } else {
          PriceListModel priceList = snapshot.data!;
          return Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price List Details:',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'List Name: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.listName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Created Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.createdDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black, 
                    ),
                    children: [
                      const TextSpan(
                        text: 'Details: \n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: priceList.priceDesc,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildErrorTile(String text){
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20
          ),
        )
      ),  
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: '', 
          userRole: 'customer',
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              customerRoute,
              (route) => false,
            );
          }, 
          barColor: custColor
        ),
        body: FutureBuilder<void>(
          future: priceListStateFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Price List',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
              
                        const SizedBox(height: 30),
              
                        getOpenedPriceList != null 
                        ? buildPriceList(getOpenedPriceList!.priceListId!)
                        : buildErrorTile("No Price List available"),
              
                        const SizedBox(height: 30),
                      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 240, 145, 3), 
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                  elevation: 10,
                                  shadowColor: const Color.fromARGB(255, 92, 90, 85),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    menuPageRoute,
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]
                    ),
                  ),
                ),
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}
