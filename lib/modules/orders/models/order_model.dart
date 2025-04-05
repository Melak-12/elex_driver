class Order {
  final int id;
  final String orderType;
  final DateTime orderTime;
  final int customerId;
  final String method;
  final double amount;
  final double tax;
  final double deliveryFee;
  final String status;
  final String invoice;
  final String deliveryAddress;
  final String contactNumber;
  final String specialInstructions;
  final int gasProvider;
  final int productId;
  final String cylinderType;
  final int cylinderQuantity;
  final String pickupLocation;
  final String deliveryStreetAddress;
  final double price;
  final double totalPerProduct;
  final int assignedDriverId;

  Order({
    required this.id,
    required this.orderType,
    required this.orderTime,
    required this.customerId,
    required this.method,
    required this.amount,
    required this.tax,
    required this.deliveryFee,
    required this.status,
    required this.invoice,
    required this.deliveryAddress,
    required this.contactNumber,
    required this.specialInstructions,
    required this.gasProvider,
    required this.productId,
    required this.cylinderType,
    required this.cylinderQuantity,
    required this.pickupLocation,
    required this.deliveryStreetAddress,
    required this.price,
    required this.totalPerProduct,
    required this.assignedDriverId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderType: json['orderType'] as String,
      orderTime: DateTime.parse(json['orderTime'] as String),
      customerId: json['customerId'] as int,
      method: json['method'] as String,
      amount: double.parse(json['amount'] as String),
      tax: double.parse(json['tax'] as String),
      deliveryFee: double.parse(json['deliveryFee'] as String),
      status: json['status'] as String,
      invoice: json['invoice'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      contactNumber: json['contactNumber'] as String,
      specialInstructions: json['specialInstructions'] as String,
      gasProvider: json['gasProvider'] as int,
      productId: json['productId'] as int,
      cylinderType: json['cylinderType'] as String,
      cylinderQuantity: json['cylinderQuantity'] as int,
      pickupLocation: json['pickupLocation'] as String,
      deliveryStreetAddress: json['deliveryStreetAddress'] as String,
      price: double.parse(json['price'] as String),
      totalPerProduct: double.parse(json['totalPerProduct'] as String),
      assignedDriverId: json['AssignedDriverId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderType': orderType,
      'orderTime': orderTime.toIso8601String(),
      'customerId': customerId,
      'method': method,
      'amount': amount.toString(),
      'tax': tax.toString(),
      'deliveryFee': deliveryFee.toString(),
      'status': status,
      'invoice': invoice,
      'deliveryAddress': deliveryAddress,
      'contactNumber': contactNumber,
      'specialInstructions': specialInstructions,
      'gasProvider': gasProvider,
      'productId': productId,
      'cylinderType': cylinderType,
      'cylinderQuantity': cylinderQuantity,
      'pickupLocation': pickupLocation,
      'deliveryStreetAddress': deliveryStreetAddress,
      'price': price.toString(),
      'totalPerProduct': totalPerProduct.toString(),
      'AssignedDriverId': assignedDriverId,
    };
  }
}
