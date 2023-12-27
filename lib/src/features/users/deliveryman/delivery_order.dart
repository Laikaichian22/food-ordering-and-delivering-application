class DeliveryOrder {
  final String name;
  final String id;
  final String date;
  final String time;
  final String paymentType;
  final String paymentStatus;
  final String price;
  final String deliveryStatus;
  final String phone;
  final String destination;

  const DeliveryOrder(
    this.name,
    this.id,
    this.date,
    this.time,
    this.paymentType,
    this.paymentStatus,
    this.price,
    this.deliveryStatus,
    this.phone,
    this.destination,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryOrder &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Getter method for userId
  String getUserId() {
    return id;
  }
}

//maybe can read all the orders at here, more easy to read by other class
const allOrders = [
  DeliveryOrder("Jack", "QFSD34234", "29 Jun 2023", "6:45 PM", "COD",
      "Done paid", "RM6.00", "On the way", "015-52489275", "MA1"),
  DeliveryOrder("Jack", "YBDD43823", "15 Nov 2023", "3:45 PM", "Touch N Go",
      "Done paid", "RM6.50", "On the way", "015-52489275", "PSZ"),
  DeliveryOrder("Jack", "DFDD43823", "15 Nov 2023", "5:45 PM", "Touch N Go",
      "Done paid", "RM6.00", "On the way", "015-52489275", "WA1"),
  DeliveryOrder("Jack", "TGFG43823", "15 Nov 2023", "2:45 PM", "Touch N Go",
      "Not yet paid", "RM6.50", "On the way", "015-52489275", "LA1"),
  DeliveryOrder("Jack", "ERGF43823", "15 Nov 2023", "3:00 PM", "Touch N Go",
      "Not yet paid", "RM7.00", "On the way", "015-52489275", "F04"),
];
