
class IncomingOrder {
  final String id;
  final String customerName;
  final String pickupLocation;
  final String dropoffLocation;
  final double amount;
  final String status;
  final DateTime createdAt;
  final String? customerPhone;
  final String? customerImage;
  final String? orderNote;

  IncomingOrder({
    required this.id,
    required this.customerName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.customerPhone,
    this.customerImage,
    this.orderNote,
  });

  factory IncomingOrder.fromJson(Map<String, dynamic> json) {
    return IncomingOrder(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropoffLocation: json['dropoffLocation'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerPhone: json['customerPhone'] as String?,
      customerImage: json['customerImage'] as String?,
      orderNote: json['orderNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'customerPhone': customerPhone,
      'customerImage': customerImage,
      'orderNote': orderNote,
    };
  }
}
