import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/order_owner.dart';

class DeliveryStartProvider extends ChangeNotifier{
  OrderOwnerModel? _currentOrderDelivery;
  OrderOwnerModel? get currentOrderDelivery => _currentOrderDelivery;

  //access by owner
  void setOrderDelivery(OrderOwnerModel order){
    _currentOrderDelivery = order;
    notifyListeners();
  }

  //access by owner and deliveryman??
  void closeOrderDelivery() {
    _currentOrderDelivery = null;
    notifyListeners();
  }
}