import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:elex_driver/core/keys/mapbox_token.dart';

class MapProvider extends ChangeNotifier {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Point destinationPoint = Point(coordinates: Position(38.7072, 9.0508));
  Point pickupPoint = Point(coordinates: Position(38.8272, 9.0208));
  Point? _currentPoint;

  Point get currentPoint => _currentPoint!;

  set currentPoint(Point value) {
    _currentPoint = value;
    notifyListeners();
  }

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
    _showUserLocation();
    _addPointsAndRoute();
  }

  /// [UpdateMethodToUpdateThePoints]

  void updatePoint(bool isPickup, Position position) {
    isPickup
        ? pickupPoint = Point(coordinates: position)
        : destinationPoint = Point(coordinates: position);
    notifyListeners();
  }

  final Location location = Location();

  /// [MethodToGetTheUserLocation] method to get the user location

  Future<void> _showUserLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted &&
        mapboxMap != null) {
      mapboxMap!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
        accuracyRingBorderColor: Colors.blue.value,
        pulsingColor: Colors.blue.value,
        locationPuck: LocationPuck(
            locationPuck2D: LocationPuck2D(
                // topImage: list,
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
          'Camera position:.................... ${_currentPoint?.coordinates.lat}');
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
}
