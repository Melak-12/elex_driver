import 'package:flutter/foundation.dart';

class MapLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? icon;
  final String? type;
  final bool isDeliveryPoint;

  MapLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.icon,
    this.type,
    this.isDeliveryPoint = false,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      icon: json['icon'] as String?,
      type: json['type'] as String?,
      isDeliveryPoint: json['isDeliveryPoint'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'icon': icon,
      'type': type,
      'isDeliveryPoint': isDeliveryPoint,
    };
  }
}

class DeliveryRoute {
  final String id;
  final MapLocation origin;
  final MapLocation destination;
  final List<MapLocation> waypoints;
  final double distance;
  final String estimatedTime;
  final String status;
  final String? customerName;
  final String? customerPhone;

  DeliveryRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.distance,
    required this.estimatedTime,
    required this.status,
    this.customerName,
    this.customerPhone,
  });

  factory DeliveryRoute.fromJson(Map<String, dynamic> json) {
    return DeliveryRoute(
      id: json['id'] as String,
      origin: MapLocation.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          MapLocation.fromJson(json['destination'] as Map<String, dynamic>),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => MapLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: json['distance'] as double,
      estimatedTime: json['estimatedTime'] as String,
      status: json['status'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'waypoints': waypoints.map((e) => e.toJson()).toList(),
      'distance': distance,
      'estimatedTime': estimatedTime,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }
}
