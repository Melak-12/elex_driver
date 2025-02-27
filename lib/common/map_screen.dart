import 'package:elex_driver/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:tuple/tuple.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  late final MapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    mapProvider = Provider.of<MapProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapProvider.getCurrentLocation();
      mapProvider.getDirections(); // Automatically show default route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        " ELEX Map",
        style: TextStyle(fontSize: 15),
      )),
      body: Selector<MapProvider,
          Tuple5<dynamic, dynamic, dynamic, Set<Marker>, Set<Polyline>>>(
        selector: (_, p0) => Tuple5(
          p0.fromLocation,
          p0.toLocation,
          p0.currentLocation,
          p0.markers,
          p0.polylines,
        ),
        builder: (context, val, child) {
          final Set<Marker> markers = val.item4;
          final Set<Polyline> polylines = val.item5;

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(9.0108, 38.7613), // Addis Ababa, Bole
                  zoom: 14, // Adjust zoom level as needed
                ),
                myLocationEnabled: true,
                onMapCreated: mapProvider.setMapController,
                markers: markers,
                polylines: polylines,
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    _buildSearchField(
                      controller: _fromController,
                      hint: "From",
                      onSelected: (LatLng location) {
                        mapProvider.setFromLocation(location);
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildSearchField(
                      controller: _toController,
                      hint: "To",
                      onSelected: (LatLng location) {
                        mapProvider.setToLocation(location);
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        mapProvider.getDirections();
                      },
                      child: const Text("Go"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required Function(LatLng) onSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey:
            "AIzaSyC8W-m9uk5q_KnaFnkNta6lHgLvwFKu8bQ", // Replace with your API Key
        inputDecoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
        debounceTime: 600,
        countries: const ["US"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (placeData) {
          if (placeData.lat != null && placeData.lng != null) {
            onSelected(LatLng(
                double.parse(placeData.lat!), double.parse(placeData.lng!)));
          }
        },
      ),
    );
  }
}
