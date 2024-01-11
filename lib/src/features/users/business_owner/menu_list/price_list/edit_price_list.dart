import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/auth/models/price_list.dart';
import 'package:flutter_application_1/src/features/auth/screens/appBar/app_bar_arrow.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class EditPriceListPage extends StatefulWidget {
  const EditPriceListPage({
    required this.priceListSelected,
    super.key
  });

  final PriceListModel priceListSelected;

  @override
  State<EditPriceListPage> createState() => _EditPriceListPageState();
}

class _EditPriceListPageState extends State<EditPriceListPage> {
  final priceListController = TextEditingController();
  final listTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool anyChanges = false;
  bool isLoading = false;
  PriceListDatabaseService service = PriceListDatabaseService();

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
      await service.updateCreatedPriceList(
        widget.priceListSelected.priceListId!,
        listTitleController.text.trim(),
        priceListController.text.trim()
      );
      _showDialog('Update price list', '${listTitleController.text} updated successfully');
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
    //initiate the data to display it on the screen
    priceListController.text = widget.priceListSelected.priceDesc;
    listTitleController.text = widget.priceListSelected.listName;
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
          title: 'Edit price list', 
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
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirm'),
                      )
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pop();
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
                        const Text(
                          'Name of price list:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black
                          )
                        ),

                        const SizedBox(height: 5),
                        
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
                        
                        const Text(
                          'Description of price list:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black
                          )
                        ),

                        const SizedBox(height: 5),

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
                              return "Please enter price list's description";
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
                      onPressed: (isLoading || !anyChanges) ? null : _handleSaveButtonPress,
                      child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                        'Update',
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
        )
      )
    );
  }
}