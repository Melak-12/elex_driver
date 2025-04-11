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
    _activeRoute = _routes.firstWhere(
      (route) => route.id == routeId,
      orElse: () => _routes.first,
    );
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
      // Return null if no route is found
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
    } catch (e) {
      print('Error initializing MapBox: $e');
      rethrow;
    }
  }

  void onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    notifyListeners();
    // Initialize map features after map is created
    _initializeMapFeatures();
  }

  Future<void> _initializeMapFeatures() async {
    if (_mapboxMap == null) return;

    try {
      await _addMarkers();
      await _drawRoute();
      await showUserLocation();
      notifyListeners();
    } catch (e) {
      print('Error initializing map features: $e');
    }
  }

  /// [UpdateMethodToUpdateThePoints]

  void updatePoint(bool isPickup, Position position) {
    isPickup
        ? pickupPoint = Point(coordinates: position)
        : destinationPoint = Point(coordinates: position);
    notifyListeners();
  }

  /// [MethodToGetTheUserLocation] method to get the user location
  Future<void> showUserLocation() async {
    if (_mapboxMap == null) return;

    if (await Permission.locationWhenInUse.request().isGranted) {
      final ByteData bytes =
          await rootBundle.load('assets/images/location.png');
      final Uint8List list = bytes.buffer.asUint8List();

      await _mapboxMap!.location.updateSettings(LocationComponentSettings(
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

      // Fetch current location
      LocationData currentLocation = await location.getLocation();
      currentPoint = Point(
        coordinates: Position(
          currentLocation.longitude!,
          currentLocation.latitude!,
        ),
      );
    }
  }

  /// [MethodToAddPointsAndRoute]
  Future<void> addPointsAndRoute() async {
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

  Future<void> _addMarkers() async {
    if (_mapboxMap == null || _activeRoute == null) return;

    try {
      // Load marker images
      final pickupIcon = await rootBundle.load('assets/images/location.png');
      final destinationIcon =
          await rootBundle.load('assets/images/location.png');
      final waypointIcon = await rootBundle.load('assets/images/location.png');
      final locationIcon = await rootBundle.load('assets/images/location.png');

      final manager =
          await _mapboxMap!.annotations.createPointAnnotationManager();

      // Add pickup marker with location icon
      manager.create(PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            _activeRoute!.origin.longitude,
            _activeRoute!.origin.latitude,
          ),
        ),
        iconSize: 1.0,
        image: pickupIcon.buffer.asUint8List(),
      ));
      manager.create(PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            _activeRoute!.origin.longitude,
            _activeRoute!.origin.latitude,
          ),
        ),
        iconSize: 0.5,
        image: locationIcon.buffer.asUint8List(),
      ));

      // Add destination marker with location icon
      manager.create(PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            _activeRoute!.destination.longitude,
            _activeRoute!.destination.latitude,
          ),
        ),
        iconSize: 1.0,
        image: destinationIcon.buffer.asUint8List(),
      ));
      manager.create(PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            _activeRoute!.destination.longitude,
            _activeRoute!.destination.latitude,
          ),
        ),
        iconSize: 0.5,
        image: locationIcon.buffer.asUint8List(),
      ));

      // Add waypoint markers
      for (var waypoint in _activeRoute!.waypoints) {
        manager.create(PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              waypoint.longitude,
              waypoint.latitude,
            ),
          ),
          iconSize: 1.0,
          image: waypointIcon.buffer.asUint8List(),
        ));
      }
    } catch (e) {
      print('Error adding markers: $e');
    }
  }

  Future<void> _drawRoute() async {
    if (_mapboxMap == null || _activeRoute == null) return;

    try {
      // Draw route from current location to pickup if we have current location
      if (_currentPoint != null) {
        final currentToPickupResponse = await http.get(Uri.parse(
            'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentPoint!.coordinates.lng},${_currentPoint!.coordinates.lat};${_activeRoute!.origin.longitude},${_activeRoute!.origin.latitude}?geometries=geojson&access_token=$mapboxToken'));

        if (currentToPickupResponse.statusCode == 200) {
          final routeData = jsonDecode(currentToPickupResponse.body);
          final routeGeometry = routeData['routes'][0]['geometry'];

          await _mapboxMap!.style.addSource(GeoJsonSource(
              id: "current-to-pickup-source", data: jsonEncode(routeGeometry)));

          await _mapboxMap!.style.addLayer(LineLayer(
            id: "current-to-pickup-layer",
            sourceId: "current-to-pickup-source",
            lineColor: Colors.red.value,
            lineWidth: 4.0,
          ));
        }
      }

      // Draw main route from pickup to destination
      final coordinates = <Position>[];
      coordinates.add(Position(
          _activeRoute!.origin.longitude, _activeRoute!.origin.latitude));

      // Add waypoints to coordinates list
      for (var waypoint in _activeRoute!.waypoints) {
        coordinates.add(Position(waypoint.longitude, waypoint.latitude));
      }

      coordinates.add(Position(_activeRoute!.destination.longitude,
          _activeRoute!.destination.latitude));

      // Create the route URL with all coordinates
      final coordinatesString =
          coordinates.map((pos) => '${pos.lng},${pos.lat}').join(';');
      final response = await http.get(Uri.parse(
          'https://api.mapbox.com/directions/v5/mapbox/driving/$coordinatesString?geometries=geojson&access_token=$mapboxToken'));

      if (response.statusCode == 200) {
        final routeData = jsonDecode(response.body);
        final routeGeometry = routeData['routes'][0]['geometry'];

        // Add route source and layer
        await _mapboxMap!.style.addSource(
            GeoJsonSource(id: "route-source", data: jsonEncode(routeGeometry)));

        await _mapboxMap!.style.addLayer(LineLayer(
          id: "route-layer",
          sourceId: "route-source",
          lineColor: Colors.blue.value,
          lineWidth: 4.0,
        ));
      }
    } catch (e) {
      print('Error drawing route: $e');
    }
  }
}
