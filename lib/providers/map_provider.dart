import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:elex_driver/core/keys/mapbox_token.dart';
import 'package:elex_driver/modules/map/models/map_model.dart';
import 'package:collection/collection.dart';

class MapProvider with ChangeNotifier {
  List<MapLocation> _locations = [];
  List<DeliveryRoute> _routes = [];
  DeliveryRoute? _activeRoute;
  bool _isLoading = false;
  String? _error;

  List<MapLocation> get locations => _locations;
  List<DeliveryRoute> get routes => _routes;
  DeliveryRoute? get activeRoute => _activeRoute;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Current driver's location
  MapLocation? _currentLocation;
  MapLocation? get currentLocation => _currentLocation;

  // Active and highlighted location (when user selects)
  MapLocation? _selectedLocation;
  MapLocation? get selectedLocation => _selectedLocation;

  MapboxMap? _mapboxMap;
  MapboxMap? get mapboxMap => _mapboxMap;

  MapProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadMapData();

    // Set default current location to the depot
    _currentLocation = _locations.firstWhere(
      (loc) => loc.type == 'depot',
      orElse: () => _locations.isNotEmpty
          ? _locations.first
          : MapLocation(
              id: 'default',
              name: 'Default Location',
              address: 'Addis Ababa',
              latitude: 9.0372,
              longitude: 38.7518,
              type: 'default',
            ),
    );

    // Set default active route (first active route)
    if (_routes.isNotEmpty) {
      _activeRoute = _routes.firstWhere(
        (route) => route.status == 'active',
        orElse: () => _routes.first,
      );
    }
  }

  Future<void> loadMapData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load map data from JSON file
      final String response =
          await rootBundle.loadString('assets/jsons/map_data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Parse locations
      _locations = (data['locations'] as List<dynamic>)
          .map((loc) => MapLocation.fromJson(loc as Map<String, dynamic>))
          .toList();

      // Parse routes
      _routes = (data['routes'] as List<dynamic>)
          .map((route) => DeliveryRoute.fromJson(route as Map<String, dynamic>))
          .toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load map data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLocation(String locationId) {
    try {
      _selectedLocation = _locations.firstWhere(
        (loc) => loc.id == locationId,
      );
      notifyListeners();
    } catch (e) {
      _selectedLocation = null;
      notifyListeners();
    }
  }

  void clearSelectedLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  void setActiveRoute(String routeId) {
    try {
      _activeRoute = _routes.firstWhere((route) => route.id == routeId);
      _addMarkers();
      _drawRoute();
    } catch (e) {
      // If the route is not found, use the first route if available
      if (_routes.isNotEmpty) {
        _activeRoute = _routes.first;
        _addMarkers();
        _drawRoute();
      }
    }
    notifyListeners();
  }

  void updateCurrentLocation(double latitude, double longitude) {
    if (_currentLocation != null) {
      final updatedLocation = MapLocation(
        id: _currentLocation!.id,
        name: _currentLocation!.name,
        address: _currentLocation!.address,
        latitude: latitude,
        longitude: longitude,
        icon: _currentLocation!.icon,
        type: _currentLocation!.type,
        isDeliveryPoint: _currentLocation!.isDeliveryPoint,
      );

      _currentLocation = updatedLocation;
      notifyListeners();
    }
  }

  // Return all delivery points for the active route
  List<MapLocation> get activeRouteLocations {
    if (_activeRoute == null) return [];

    final List<MapLocation> routeLocations = [
      _activeRoute!.origin,
      ..._activeRoute!.waypoints,
      _activeRoute!.destination,
    ];

    return routeLocations;
  }

  // Get a route by ID
  DeliveryRoute? getRouteById(String id) {
    try {
      return _routes.firstWhere((route) => route.id == id);
    } catch (e) {
      print('Route not found with id: $id');
      // Create a default route to return if none is found
      if (_routes.isNotEmpty) {
        return _routes.first;
      }
      return null;
    }
  }

  // Get a location by ID
  MapLocation? getLocationById(String locationId) {
    try {
      return _locations.firstWhere((loc) => loc.id == locationId);
    } catch (e) {
      return null;
    }
  }

  // Get distance and time between current location and destination
  Map<String, dynamic> getDistanceAndTime(MapLocation destination) {
    if (_currentLocation == null) {
      return {
        'distance': 0.0,
        'time': '0 min',
      };
    }

    // This is a placeholder calculation - in a real app you would use a routing API
    final double distance = calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        destination.latitude,
        destination.longitude);

    // Estimate time based on distance (assuming 30 km/h average speed)
    final int minutes = (distance / 30 * 60).round();
    final String time = '$minutes min';

    return {
      'distance': distance,
      'time': time,
    };
  }

  // Simple placeholder distance calculation using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert degrees to radians
    final double radLat1 = lat1 * (math.pi / 180);
    final double radLon1 = lon1 * (math.pi / 180);
    final double radLat2 = lat2 * (math.pi / 180);
    final double radLon2 = lon2 * (math.pi / 180);

    // Calculate differences
    final double dLat = radLat2 - radLat1;
    final double dLon = radLon2 - radLon1;

    // Calculate distance using Haversine formula
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(radLat1) *
            math.cos(radLat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c;

    return double.parse(distance.toStringAsFixed(1));
  }

  PointAnnotationManager? pointAnnotationManager;
  Point destinationPoint = Point(coordinates: Position(38.7072, 9.0508));
  Point pickupPoint = Point(coordinates: Position(38.8272, 9.0208));
  Point? _currentPoint;

  Point get currentPoint => _currentPoint!;

  set currentPoint(Point value) {
    _currentPoint = value;
    notifyListeners();
  }

  final Location location = Location();

  /// Initializes the MapBox SDK and prepares it for use
  Future<void> initMapBox() async {
    try {
      MapboxOptions.setAccessToken(mapboxToken);
      notifyListeners();
    } catch (e) {
      print('Error initializing MapBox: $e');
      rethrow;
    }
  }

  void onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _addMarkers();
    _drawRoute();
    notifyListeners();
  }

  /// [UpdateMethodToUpdateThePoints]

  void updatePoint(bool isPickup, Position position) {
    isPickup
        ? pickupPoint = Point(coordinates: position)
        : destinationPoint = Point(coordinates: position);
    notifyListeners();
  }

  /// [MethodToGetTheUserLocation] method to get the user location

  Future<void> _showUserLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted &&
        mapboxMap != null) {
        final ByteData bytes =
          await rootBundle.load('assets/images/location.png');
      final Uint8List list = bytes.buffer.asUint8List();
          
      mapboxMap!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
        accuracyRingBorderColor: Colors.blue.value,
        pulsingColor: Colors.blue.value,
        locationPuck: LocationPuck(
            locationPuck2D: LocationPuck2D(
                topImage: list,
                )),
      ));

      //! Get the camera state
      final cameraState = await mapboxMap!.getCameraState();

      // currentPoint = Point(
      //     coordinates: Position(cameraState.center.coordinates.lng,
      //         cameraState.center.coordinates.lat));
      //Todo get the current location of the user coordinate points

      // Fetch current location
      LocationData currentLocation = await location.getLocation();
      currentPoint = Point(
        coordinates: Position(
          currentLocation.longitude!,
          currentLocation.latitude!,
        ),
      );
      // Optionally, update the map's camera position
      // mapboxMap?.moveCamera(CameraUpdate.newLatLng(
      //   LatLng(currentLocation.latitude!, currentLocation.longitude!),
      // ));
      print(
          'Camera position:.................... ${_currentPoint!.coordinates.lat + pickupPoint.coordinates.lat}');
    }
  }

  /// [MethodToAddPointsAndRoute]

  Future<void> _addPointsAndRoute() async {
    if (mapboxMap == null) return;
    pointAnnotationManager =
        await mapboxMap!.annotations.createPointAnnotationManager();
    final imageData = (await rootBundle.load('assets/images/location.png'))
        .buffer
        .asUint8List();

    pointAnnotationManager?.create(PointAnnotationOptions(
        geometry: pickupPoint, image: imageData, iconSize: 1.0));
    pointAnnotationManager?.create(PointAnnotationOptions(
        geometry: destinationPoint, image: imageData, iconSize: 1.0));
    if (_currentPoint != null) {
      pointAnnotationManager?.create(PointAnnotationOptions(
        geometry: _currentPoint!, image: imageData, iconSize: 1.0));
    }

    final response = await http.get(Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${pickupPoint.coordinates.lng},${pickupPoint.coordinates.lat};${destinationPoint.coordinates.lng},${destinationPoint.coordinates.lat}?geometries=geojson&access_token=$mapboxToken'));
    if (_currentPoint != null) {
      final response2 = await http.get(Uri.parse(
          'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentPoint!.coordinates.lng},${_currentPoint!.coordinates.lat};${pickupPoint.coordinates.lng},${pickupPoint.coordinates.lat}?geometries=geojson&access_token=$mapboxToken'));
      if (response2.statusCode == 200) {
        final routeData = jsonDecode(response2.body);
        final routeGeometry = routeData['routes'][0]['geometry'];

        double distance = routeData['routes'][0]['distance'] / 1000;
        print('Distance: $distance km');

        await mapboxMap!.style.addSource(GeoJsonSource(
            id: "route-source1", data: jsonEncode(routeGeometry)));

        await mapboxMap!.style.addLayer(LineLayer(
          id: "route-layer1",
          sourceId: "route-source1",
          lineColor: Colors.red.value,
          lineWidth: 4.0,
        ));
      }
    } else {
      print('No current location');
    }

    if (response.statusCode == 200) {
      final routeData = jsonDecode(response.body);
      final routeGeometry = routeData['routes'][0]['geometry'];

      double distance = routeData['routes'][0]['distance'] / 1000;
      print('Distance: $distance km');

      await mapboxMap!.style.addSource(
          GeoJsonSource(id: "route-source", data: jsonEncode(routeGeometry)));

      await mapboxMap!.style.addLayer(LineLayer(
        id: "route-layer",
        sourceId: "route-source",
        lineColor: Colors.blue.value,
        lineWidth: 4.0,
      ));
    } else {
      print('Failed to get route: ${response.statusCode}');
    }
    notifyListeners();
  }

  void _addMarkers() {
    if (_mapboxMap == null || _activeRoute == null) return;

    try {
      // Add origin marker
      _mapboxMap!.annotations.createPointAnnotationManager().then((manager) {
        final options = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              _activeRoute!.origin.longitude,
              _activeRoute!.origin.latitude,
            ),
          ),
          iconSize: 1.0,
          iconImage: 'assets/images/markers/start_marker.png',
        );
        manager.create(options);
      });

      // Add destination marker
      _mapboxMap!.annotations.createPointAnnotationManager().then((manager) {
        final options = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              _activeRoute!.destination.longitude,
              _activeRoute!.destination.latitude,
            ),
          ),
          iconSize: 1.0,
          iconImage: 'assets/images/markers/end_marker.png',
        );
        manager.create(options);
      });

      // Add waypoint markers if any
      if (_activeRoute!.waypoints.isNotEmpty) {
        _mapboxMap!.annotations.createPointAnnotationManager().then((manager) {
          for (var waypoint in _activeRoute!.waypoints) {
            final options = PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  waypoint.longitude,
                  waypoint.latitude,
                ),
              ),
              iconSize: 1.0,
              iconImage: 'assets/images/markers/waypoint_marker.png',
            );
            manager.create(options);
          }
        });
      }
    } catch (e) {
      print('Error adding markers: $e');
    }
  }

  void _drawRoute() {
    if (_mapboxMap == null || _activeRoute == null) return;

    try {
      // This is a simplified example - in a real app you would use the Mapbox Directions API
      // to get actual route coordinates and then draw the route line

      _mapboxMap!.annotations.createPolylineAnnotationManager().then((manager) {
        final coordinates = <Position>[];

        // Add origin
        coordinates.add(Position(
          _activeRoute!.origin.longitude,
          _activeRoute!.origin.latitude,
        ));

        // Add waypoints in order
        for (var waypoint in _activeRoute!.waypoints) {
          coordinates.add(Position(
            waypoint.longitude,
            waypoint.latitude,
          ));
        }

        // Add destination
        coordinates.add(Position(
          _activeRoute!.destination.longitude,
          _activeRoute!.destination.latitude,
        ));

        final options = PolylineAnnotationOptions(
          geometry: LineString(coordinates: coordinates),
          lineColor: 0xFF4882c5, // Using hex color as integer
          lineWidth: 5.0,
        );

        manager.create(options);
      });
    } catch (e) {
      print('Error drawing route: $e');
    }
  }
}
