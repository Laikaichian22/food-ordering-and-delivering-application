import 'package:flutter/material.dart';

class AddMenuProvider with ChangeNotifier{
  //initial variables
  late String _mainDish;
  late String _sideDish;
  late String _specialDish;
  late String _downloadImageUrl;

  //getters
  String get mainDish => _mainDish;
  String get sideDish => _sideDish;
  String get specialDish => _specialDish;
  String get downloadImageUrl => _downloadImageUrl;

  //Setter
  set changeMainDish(String mainDish){
    _mainDish = mainDish;
    notifyListeners();
  }
  set changeSideDish(String sideDish){
    _sideDish = sideDish;
    notifyListeners();
  }
  set changeSpecialDish(String specialDish){
    _specialDish = specialDish;
    notifyListeners();
  }
  set changeUrl(String imageUrl){
    _downloadImageUrl = imageUrl;
    notifyListeners();
  }



}