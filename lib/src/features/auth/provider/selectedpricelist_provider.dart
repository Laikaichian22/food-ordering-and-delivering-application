import 'package:flutter/material.dart';

class SelectedPriceListProvider with ChangeNotifier {
  String? selectedPriceListId;

  void selectPriceList(String? priceListId) {
    selectedPriceListId = priceListId;
    notifyListeners();
  }
}