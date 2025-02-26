import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../core/keys/google_api_key.dart';

class MapProvider with ChangeNotifier {
  LatLng? _currentLocation;
  LatLng? _fromLocation;
  LatLng? _toLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  LatLng? get currentLocation => _currentLocation;
  LatLng? get fromLocation => _fromLocation;
  LatLng? get toLocation => _toLocation;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentLocation = LatLng(position.latitude, position.longitude);
    _markers.add(
      Marker(
        markerId: const MarkerId("current_location"),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 15));
    notifyListeners();
  }

  void setFromLocation(LatLng location) {
    _fromLocation = location;
    _markers.add(
      Marker(
        markerId: const MarkerId("from_location"),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    notifyListeners();
  }

  void setToLocation(LatLng location) {
    _toLocation = location;
    _markers.add(
      Marker(
        markerId: const MarkerId("to_location"),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    notifyListeners();
  }

  Future<void> getDirections() async {
    if (_fromLocation == null || _toLocation == null) return;
PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: const PointLatLng(32, 32),
        destination: const PointLatLng(32, 32),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    print(result.points);

    notifyListeners();
  }
}
