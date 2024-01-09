import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: empty_constructor_bodies
class PriceListModel{
  String? priceListId;
  String listName;
  String priceDesc;
  String createdDate;
  String? openStatus;

  PriceListModel({
    this.priceListId,
    this.openStatus,
    required this.listName,
    required this.createdDate,
    required this.priceDesc,
  });

  Map<String, dynamic> toJason(){
    return{
      'PriceListName' : listName ,
      'PriceListDescription' : priceDesc,
      'createdDate' : createdDate,
      'PriceList id' : priceListId ?? '',
      'OpenStatus' : openStatus ?? ''
    };
  }

  PriceListModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  : priceListId = doc.data()!['PriceList id'],
    listName = doc.data()!['PriceListName'],
    openStatus = doc.data()!['OpenStatus'],
    priceDesc = doc.data()!['PriceListDescription'],
    createdDate = doc.data()!['createdDate'];
}