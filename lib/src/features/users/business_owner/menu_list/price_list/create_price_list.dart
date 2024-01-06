import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CreatePriceListPage extends StatefulWidget {
  const CreatePriceListPage({super.key});

  @override
  State<CreatePriceListPage> createState() => _CreatePriceListPageState();
}

class _CreatePriceListPageState extends State<CreatePriceListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final priceListController = TextEditingController();
  final listTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PriceListDatabaseService service = PriceListDatabaseService();
  bool isLoading = false;
  bool anyChanges = false;

  Future<void> _showDialog(String title, String content) async{
    return showDialog(
      context: _scaffoldKey.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  priceListRoute, 
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20
                )
              ),
            ),
          ],
        );
      }
    );
  }

  Future<void> _uploadData()async{
    if(_formKey.currentState!.validate()){
      DateTime now = DateTime.now();
      PriceListModel priceList = PriceListModel(
        priceListId: '',
        listName: listTitleController.text.trim(), 
        createdDate: DateFormat('MMMM dd, yyyy').format(now), 
        priceDesc: priceListController.text.trim(),
      );
      DocumentReference documentReference = await service.addPriceList(priceList);
      String docId = documentReference.id;
      await service.updatePriceList(
        PriceListModel(
          priceListId: docId,
          listName: listTitleController.text.trim(), 
          createdDate: DateFormat('MMMM dd, yyyy').format(now), 
          priceDesc: priceListController.text.trim()
        )
      );
      _showDialog('New price list added', '${listTitleController.text} added successfully');
    }
  }

  void _handleSaveButtonPress() async {
    setState(() {
      isLoading = true;
    });

    await _uploadData(); 
    
    setState(() {
      isLoading = false;
    });
  }
  

  @override
  void initState(){
    super.initState();
    priceListController.addListener(() {
      if(priceListController.text.isNotEmpty) {
        anyChanges = true;
      }
    });
    listTitleController.addListener(() {
      if(listTitleController.text.isNotEmpty) {
        anyChanges = true;
      }
    });
  }
  
  @override
  void dispose(){
    priceListController.dispose();
    listTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Price List', 
          userRole: 'owner',
          onPress: (){
            if (anyChanges == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      'Confirm to leave this page?\n\nPlease save your work before you leave',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            priceListRoute,
                            (route) => false,
                          );
                        },
                        child: const Text('Confirm'),
                      )
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                priceListRoute,
                (route) => false,
              );
            }
          }, 
          barColor: ownerColor
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: listTitleController,   
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: "Price list's name",
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                              ),
                            ),
                            validator: (value) {
                              if(value==null||value.isEmpty){
                                return 'Please enter name of the list';
                              }
                              return null;
                            },
                          ),
                        ),
              
                        const SizedBox(height:30),
                        
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: priceListController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "List of pricing",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if(value==null||value.isEmpty){
                              return 'Please enter price list first';
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                  ), 

                  const SizedBox(height: 40),
                 
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 252, 70),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 92, 90, 85),
                      ),
                      onPressed: isLoading ? null : _handleSaveButtonPress,
                      child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )
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