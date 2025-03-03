import 'dart:convert';
import 'package:elex_driver/core/keys/mapbox_token.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  Point pickupPoint =
      Point(coordinates: Position(38.7072, 9.0508)); // Example pickup point
  Point destinationPoint = Point(
      coordinates: Position(38.8272, 9.0208)); // Example destination point

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _showUserLocation();
    _addPointsAndRoute();
  }

  _showUserLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      mapboxMap?.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          showAccuracyRing: true,
          pulsingColor: Colors.blue.value,
          locationPuck: LocationPuck(
            locationPuck2D: LocationPuck2D(
              topImage: null,
              bearingImage: null,
              shadowImage: null,
              scaleExpression: null,
            ),
          ),
        ),
      );
    }
  }

  void _addPointsAndRoute() async {
    if (mapboxMap == null) return;

    // Add pickup point
    await mapboxMap!.style.addSource(GeoJsonSource(
      id: "pickup-source",
      data: jsonEncode(pickupPoint.toJson()),
    ));
    await mapboxMap!.style.addLayer(SymbolLayer(
      id: "pickup-layer",
      sourceId: "pickup-source",
      iconImage: "marker-15",
      iconSize: 1.5,
    ));

    // Add destination point
    await mapboxMap!.style.addSource(GeoJsonSource(
      id: "destination-source",
      data: jsonEncode(destinationPoint.toJson()),
    ));
    await mapboxMap!.style.addLayer(SymbolLayer(
      id: "destination-layer",
      sourceId: "destination-source",
      iconImage: "marker-15",
      iconSize: 1.5,
    ));

    // Get the route from Mapbox Directions API
    final response = await http.get(Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${pickupPoint.coordinates.lng},${pickupPoint.coordinates.lat};${destinationPoint.coordinates.lng},${destinationPoint.coordinates.lat}?geometries=geojson&access_token=$mapboxToken'));

    if (response.statusCode == 200) {
      final routeData = jsonDecode(response.body);
      final routeGeometry = routeData['routes'][0]['geometry'];

      // Add route line
      await mapboxMap!.style.addSource(GeoJsonSource(
        id: "route-source",
        data: jsonEncode(routeGeometry),
      ));
      await mapboxMap!.style.addLayer(LineLayer(
        id: "route-layer",
        sourceId: "route-source",
        lineColor: Colors.blue.value,
        lineWidth: 3,
      ));

      // Calculate distance
      double distance =
          routeData['routes'][0]['distance'] / 1000; // Convert to km

      // Show distance
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Distance: ${distance.toStringAsFixed(2)} km')),
      );
    } else {
      print('Failed to get route: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(mapboxToken);

    // Calculate midpoint
    double midLng =
        (pickupPoint.coordinates.lng + destinationPoint.coordinates.lng) / 2;
    double midLat =
        (pickupPoint.coordinates.lat + destinationPoint.coordinates.lat) / 2;

    return Scaffold(
      body: MapWidget(
        key: ValueKey("mapWidget"),
        onMapCreated: _onMapCreated,
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(midLng, midLat)),
          zoom: 11.0,
        ),
      ),
    );
  }
}
