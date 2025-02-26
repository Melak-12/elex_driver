import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  double? _currentLat;
  double? _currentLong;

  double? get currentLat => _currentLat;
  double? get currentLong => _currentLong;

  Future<void> updateLocation() async {
    // Implement location update logic
    notifyListeners();
  }
}
