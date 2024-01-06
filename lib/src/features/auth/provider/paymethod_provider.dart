import 'package:flutter/material.dart';

class SelectedPayMethodProvider extends ChangeNotifier{
  //tng button
  bool _isTngButtonOpen = false;
  bool get isTngButtonOpen => _isTngButtonOpen;
  //fpx button
  bool _isFPXButtonOpen = false;
  bool get isFPXButtonOpen => _isFPXButtonOpen;
  //cod button
  bool _isCODButtonOpen = false;
  bool get isCODButtonOpen => _isCODButtonOpen;
  //replace button
  bool _isReplaceMlButtonOpen = false;
  bool get isReplaceMlButtonOpen => _isReplaceMlButtonOpen;

  void setTngButtonState(bool isOpen) {
    _isTngButtonOpen = isOpen;
    notifyListeners();
  }
  void setFPXButtonState(bool isOpen) {
    _isFPXButtonOpen = isOpen;
    notifyListeners();
  }
  void setCODButtonState(bool isOpen) {
    _isCODButtonOpen = isOpen;
    notifyListeners();
  }
  void setReplaceMlButtonState(bool isOpen) {
    _isReplaceMlButtonOpen = isOpen;
    notifyListeners();
  }


  final List<String> _selectedPaymentMethodsId = [];
  List<String> get selectedPaymentMethodsId => _selectedPaymentMethodsId;

  void addSelectedPaymentMethod(String paymentMethodId) {
    _selectedPaymentMethodsId.add(paymentMethodId);
    notifyListeners();
  }

  void removeSelectedPaymentMethod(String paymentMethodId) {
    _selectedPaymentMethodsId.remove(paymentMethodId);
    notifyListeners();
  }

  bool isSelected(String paymentMethodId) {
    return _selectedPaymentMethodsId.contains(paymentMethodId);
  }

  void clearSelectedPaymentMethods() {
    _selectedPaymentMethodsId.clear();
    notifyListeners();
  }
}