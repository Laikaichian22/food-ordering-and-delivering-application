import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/view_price_list.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:provider/provider.dart';

import '../../../../auth/provider/selectedpricelist_provider.dart';

class PriceListMainPage extends StatefulWidget {
  const PriceListMainPage({super.key});

  @override
  State<PriceListMainPage> createState() => _PriceListMainPageState();
}

class _PriceListMainPageState extends State<PriceListMainPage> {
  PriceListDatabaseService service = PriceListDatabaseService();
  Future<List<PriceListModel>>? priceList;
  List<PriceListModel>? retrievedPriceList;

  @override
  void initState(){
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async{
    priceList = service.retrieveList();
    retrievedPriceList = await service.retrieveList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralAppBar(
          title: 'Price List', 
          onPress: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              businessOwnerRoute, 
              (route) => false,
            );
          }, 
          barColor: ownerColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: 
            Column(
              children: [
                CardPriceListWidget(
                  title: 'Create price list', 
                  iconBtn: Icons.add_outlined, 
                  cardColor: const Color.fromARGB(255, 220, 220, 220), 
                  onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      priceListCreatingRoute, 
                      (route) => false,
                    );
                  }
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 186, 224, 255),
                    border: Border.all(),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.65,
                      child: FutureBuilder(
                        future: priceList, 
                        builder: (BuildContext context, AsyncSnapshot<List<PriceListModel>> snapshot){
                          if(snapshot.hasData && snapshot.data!.isNotEmpty){
                            return Consumer<SelectedPriceListProvider>(
                              builder: (context, selectedPriceListProvider, _){
                                return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: retrievedPriceList!.length,
                                  separatorBuilder: (context, index) => const SizedBox(
                                    height: 10,
                                  ), 
                                  itemBuilder: (context, index){
                                  final isSelected = selectedPriceListProvider.selectedPriceListId == retrievedPriceList![index].priceListId;
                                    return Dismissible(
                                      //swipe to left to delete the list
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(16.0)
                                        ),
                                        padding: const EdgeInsets.only(right: 28.0),
                                        alignment: AlignmentDirectional.centerEnd,
                                        child: const Text(
                                        "DELETE",
                                        style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context, 
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              content: Text('Are you sure you want to delete list: ${retrievedPriceList![index].listName}?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel')
                                                ),
                                                TextButton(
                                                  onPressed: () async{
                                                    await service.deletePriceList(
                                                      retrievedPriceList![index].priceListId.toString()
                                                    );
                                                    setState(() {
                                                      _initRetrieval();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete')
                                                )
                                              ],
                                            );
                                          }
                                        ); 
                                      },
                                      key: UniqueKey(),
                                      child: Center(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.8,
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color.fromARGB(255, 191, 48, 216) : Colors.amber,
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: ListTile(
                                          onTap:() {
                                            MaterialPageRoute route = MaterialPageRoute(
                                              builder: (context) => ViewPriceListPage(priceListSelected: retrievedPriceList![index])
                                            );
                                            Navigator.push(context, route);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          title: Text(
                                            retrievedPriceList![index].listName,
                                            style: const TextStyle(
                                              color: Colors.black
                                            ),
                                          ),
                                          subtitle: Text(retrievedPriceList![index].createdDate),
                                          trailing: const Icon(Icons.arrow_right_sharp),
                                          ),
                                        ),
                                      ),
                                    );
                                  }, 
                                );
                              }
                            );
                            
                          }else if(snapshot.connectionState == ConnectionState.done && retrievedPriceList!.isEmpty){
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          }else{
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),  
          ),
        ),
      )
    );
  }
}

class CardPriceListWidget extends StatelessWidget {
  const CardPriceListWidget({
    required this.title,
    required this.iconBtn,
    required this.cardColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final Color cardColor;
  final VoidCallback onTap;
  final IconData iconBtn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.1,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: cardColor,
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    trailing: Icon(iconBtn, size: 55),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
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
    );
  }
}