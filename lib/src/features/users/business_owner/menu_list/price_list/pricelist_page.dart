import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/direct_appbar_arrow.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/price_list/view_price_list.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class PriceListMainPage extends StatefulWidget {
  const PriceListMainPage({super.key});

  @override
  State<PriceListMainPage> createState() => _PriceListMainPageState();
}

class _PriceListMainPageState extends State<PriceListMainPage> {
  final PriceListDatabaseService service = PriceListDatabaseService();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GeneralDirectAppBar(
          title: 'Price List', 
          userRole: 'owner',
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
                      child: StreamBuilder(
                        stream: service.retrieveListStream(), 
                        builder: (BuildContext context, AsyncSnapshot<List<PriceListModel>> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          } else if(snapshot.hasError){
                            return const Center(
                              child: Text(
                                'Error in fetching Data. Please reload again',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(fontSize: 30),
                              )
                            );
                          }else{
                            List<PriceListModel> priceList = snapshot.data!;
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: priceList.length,
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ), 
                              itemBuilder: (context, index){
                                return Dismissible(
                                  key: Key(priceList[index].priceListId.toString()),
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: deleteButtonColor,
                                      borderRadius: BorderRadius.circular(16.0)
                                    ),
                                    padding: const EdgeInsets.only(right: 28.0),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: const Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: yellowColorText,
                                        fontSize: 18
                                      ),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: Text('Are you sure you want to delete list: ${priceList[index].listName}?'),
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
                                                  priceList[index].priceListId.toString()
                                                );
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Delete')
                                            )
                                          ],
                                        );
                                      }
                                    ); 
                                  },
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      decoration: BoxDecoration(
                                        color: priceList[index].openStatus == 'Yes' ? const Color.fromARGB(255, 225, 55, 255) : Colors.amber,
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: ListTile(
                                      onTap:() {
                                        MaterialPageRoute route = MaterialPageRoute(
                                          builder: (context) => ViewPriceListPage(priceListSelected: priceList[index])
                                        );
                                        Navigator.push(context, route);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      title: Text(
                                        priceList[index].listName,
                                        style: const TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      subtitle: Text(priceList[index].createdDate),
                                      trailing: const Icon(Icons.arrow_right_sharp),
                                      ),
                                    ),
                                  ),
                                );
                              }, 
                            );
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