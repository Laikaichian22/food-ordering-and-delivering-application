class OrderData {
  String email;
  String name;
  String pickupPlace;
  String phoneNumber;
  List<String> dishes;
  List<String> sideDishes;

  OrderData({
    required this.email,
    required this.name,
    required this.pickupPlace,
    required this.phoneNumber,
    required this.dishes,
    required this.sideDishes,
  });
}