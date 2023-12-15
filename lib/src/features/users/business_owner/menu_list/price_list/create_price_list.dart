import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';
import 'package:intl/intl.dart';

class CreatePriceListPage extends StatefulWidget {
  const CreatePriceListPage({super.key});

  @override
  State<CreatePriceListPage> createState() => _CreatePriceListPageState();
}

class _CreatePriceListPageState extends State<CreatePriceListPage> {

  final priceListController = TextEditingController();
  final listTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saveBtnOn = false;
  PriceListDatabaseService service = PriceListDatabaseService();

  @override
  void initState(){
    super.initState();
    priceListController.addListener(() {
      setState(() {
        _saveBtnOn = priceListController.text.isNotEmpty;
      });
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
        appBar: GeneralAppBar(
          title: 'Price List', 
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: listTitleController,             //create default menu name if possible
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
                      onPressed: _saveBtnOn 
                      ? () async {
                        if(_formKey.currentState!.validate()){
                          DateTime now = DateTime.now();
                          PriceListModel priceList = PriceListModel(
                            listName: listTitleController.text.trim(), 
                            createdDate: DateFormat('MMMM dd, yyyy').format(now), 
                            priceDesc: priceListController.text.trim(),
                          );


                          await service.addPriceList(priceList);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('A price list is created successfully', style: TextStyle(color: Colors.black),),
                              backgroundColor: Colors.amber,
                            )
                          );
                        }
                      }
                    : null,
                      child: const Text(
                        'Save', 
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

// !isFirstPressed
//                   ? SizedBox(
//                       height: 45,
//                       width: 150,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromARGB(255, 64, 252, 70),
//                           elevation: 10,
//                           shadowColor: const Color.fromARGB(255, 92, 90, 85),
//                         ),
//                         onPressed: () async {
//                           if(_formKey.currentState!.validate()){
//                             DateTime now = DateTime.now();
//                             PriceListModel priceList = PriceListModel(
//                               listName: listTitleController.text.trim(), 
//                               createdDate: DateFormat('MMMM dd, yyyy').format(now), 
//                               priceDesc: priceListController.text.trim(),
//                             );

//                             setState(() {
//                               isFirstPressed = true;
//                             });

//                             await service.addPriceList(priceList);
//                           }
//                         }, 
//                         //ensure the user key in the menu name
//                         child: const Text(
//                           'Save', 
//                           style: TextStyle(
//                             fontSize: 20, 
//                             color: Colors.black
//                           ),
//                         ),
//                       ),
//                     )
//                   : SizedBox(
//                       height: 45,
//                       width: 150,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.amber,
//                           elevation: 10,
//                           shadowColor: const Color.fromARGB(255, 92, 90, 85),
//                         ),
//                         onPressed: (){  //save in database
                          
//                         }, 
//                         child: const Text(
//                           'Continue', 
//                           style: TextStyle(
//                             fontSize: 20, 
//                             color: Colors.black
//                           ),
//                         ),
//                       ),
//                     ),