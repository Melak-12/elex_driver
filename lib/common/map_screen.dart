import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatelessWidget {
  static const String MAPBOX_ACCESS_TOKEN =
      "pk.eyJ1IjoibWVsYWIxMiIsImEiOiJjbTdrN2k0c2YwZTZ5MnFzY3g1bGg3d3JpIn0.VBMxLhjuQ1k0KjQ4I3HpSA";

  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Mapbox Test")), body: Container()
        //     Consumer<MapProvider>(
        //   builder: (context, mapProvider, child) {
        //     return MapboxMap(
        //       accessToken: MAPBOX_ACCESS_TOKEN,
        //       initialCameraPosition: CameraPosition(
        //         target: mapProvider.userLocation ??
        //             const LatLng(37.7749,
        //                 -122.4194), // Default to San Francisco if no location
        //         zoom: 12,
        //       ),
        //       onMapCreated: (MapboxMapController controller) {
        //         mapProvider.setMapController(controller);
        //       },
        //       myLocationEnabled: true,
        //       myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        //     );
        //   },
        // ),
        );
  }
}
