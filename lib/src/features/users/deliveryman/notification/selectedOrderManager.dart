import 'package:flutter_application_1/src/features/users/deliveryman/delivery_order.dart';

//created to store specific users' id being selected during the total pending order(for send notification and photo)
class SelectedOrdersManager {
  static List<DeliveryOrder> selectedOrders = [];

  static void addToSelectedOrders(DeliveryOrder order) {
    selectedOrders.add(order);
  }

  static List<String> getSelectedOrders() {
    List<String> userIds = [];
    for (var order in selectedOrders) {
      userIds.add(order.getUserId());
    }
    return userIds;
  }

  static void clearSelectedOrders() {
    selectedOrders.clear();
  }
}
