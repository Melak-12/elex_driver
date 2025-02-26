class Order {
  final String id;
  final String type; // 'food', 'document', 'cylinder'
  final String status;
  final String customerName;
  final String customerPhone;
  final double pickupLat;
  final double pickupLong;
  final double deliveryLat;
  final double deliveryLong;

  Order({
    required this.id,
    required this.type,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLat,
    required this.pickupLong,
    required this.deliveryLat,
    required this.deliveryLong,
  });
}
