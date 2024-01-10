// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/services/firestoreDB/pricelist_db_service.dart';
// import 'package:flutter_application_1/src/features/auth/models/price_list.dart';

// class SelectedPriceListProvider with ChangeNotifier {
//   String? selectedPriceListId;

//   void selectPriceList(String? priceListId) {
//     selectedPriceListId = priceListId;
//     _openSelectedPriceListId(priceListId);
//     notifyListeners();
//   }

//   void closePriceList(String? priceListId){
//     selectedPriceListId = null;
//     _closeSelectedPriceListId(priceListId);
//     notifyListeners();
//   }

//   // Method to load the state
//   Future<void> loadState() async {
//     try{
//       print('load state-------------------------------');
//       PriceListModel? openPriceList = await PriceListDatabaseService().getOpenPriceList();
//       if(openPriceList !=null){
//         print('nnot null-------------------------------');
//         selectedPriceListId = openPriceList.priceListId;
//       }else{
//         print('null-------------------------------');
//         selectedPriceListId = null;
//       }
//     }catch(e){
//       print('Error loading state: $e');
//       rethrow;
//     }
//   }

//   //store setpricelistId into firestore
//   Future<void> _openSelectedPriceListId(String? priceListId) async{
//     if(priceListId != null){
//       await PriceListDatabaseService().updateToOpenedStatus(priceListId);
//     }
//   }

//   Future<void> _closeSelectedPriceListId(String? priceListId)async{
//     if(priceListId != null){
//       await PriceListDatabaseService().updateToClosedStatus(priceListId);
//     }
//   }

// }