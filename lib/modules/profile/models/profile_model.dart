class Profile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String licenseNumber;
  final String vehicleType;
  final String vehicleNumber;
  final bool isOnline;
  final double rating;
  final int totalDeliveries;
  final int completedDeliveries;
  final int pendingDeliveries;
  final String status;
  final String lastActive;
  final Map<String, bool> notificationSettings;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.licenseNumber,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.isOnline,
    required this.rating,
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.pendingDeliveries,
    required this.status,
    required this.lastActive,
    required this.notificationSettings,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String,
      licenseNumber: json['licenseNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      isOnline: json['isOnline'] as bool,
      rating: (json['rating'] as num).toDouble(),
      totalDeliveries: json['totalDeliveries'] as int,
      completedDeliveries: json['completedDeliveries'] as int,
      pendingDeliveries: json['pendingDeliveries'] as int,
      status: json['status'] as String,
      lastActive: json['lastActive'] as String,
      notificationSettings:
          Map<String, bool>.from(json['notificationSettings'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'licenseNumber': licenseNumber,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'isOnline': isOnline,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'completedDeliveries': completedDeliveries,
      'pendingDeliveries': pendingDeliveries,
      'status': status,
      'lastActive': lastActive,
      'notificationSettings': notificationSettings,
    };
  }
}
