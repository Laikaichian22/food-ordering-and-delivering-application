import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: empty_constructor_bodies
class PriceListModel{
  String? priceListId;
  String listName;
  String priceDesc;
  String createdDate;

  PriceListModel({
    this.priceListId,
    required this.listName,
    required this.createdDate,
    required this.priceDesc,
  });

  Map<String, dynamic> toJason(){
    return{
      'PriceListName' : listName,
      'PriceListDescription' : priceDesc,
      'createdDate' : createdDate,
    };
  }

  PriceListModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  : priceListId = doc.id,
    listName = doc.data()!['PriceListName'],
    priceDesc = doc.data()!['PriceListDescription'],
    createdDate = doc.data()!['createdDate'];
}