class DeliveryOrder {
  final String name;
  final String id;
  final String date;
  final String time;
  final String paymentType;
  final String paymentStatus;
  final String price;
  final String deliveryStatus;

  DeliveryOrder(
    this.name,
    this.id,
    this.date,
    this.time,
    this.paymentType,
    this.paymentStatus,
    this.price,
    this.deliveryStatus,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryOrder &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
