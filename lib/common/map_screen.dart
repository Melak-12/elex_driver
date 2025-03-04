import 'package:elex_driver/core/keys/mapbox_token.dart';
import 'package:elex_driver/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapProvider? mapProvider;

  @override
  void initState() {
    super.initState();
    mapProvider = Provider.of<MapProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(mapboxToken); 
    
    // Calculate midpoint
    double midLng = (mapProvider!.pickupPoint.coordinates.lng +
            mapProvider!.destinationPoint.coordinates.lng) /
        2;
    double midLat = (mapProvider!.pickupPoint.coordinates.lat +
            mapProvider!.destinationPoint.coordinates.lat) /
        2;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen"),
      ),
      body: Selector<MapProvider, MapboxMap?>(
        // Selector will listen for changes in the MapboxMap object
        selector: (_, mapProvider) => mapProvider.mapboxMap,
        builder: (_, mapboxMap, child) {
          if (mapboxMap == null) {
            // return const Center(child: CircularProgressIndicator());
          }

          return MapWidget(
            key: const ValueKey("mapWidget"),
            onMapCreated: mapProvider?.onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(midLng, midLat)),
              zoom: 11.0,
            ),
          );
        },
      ),
    );
  }
}
