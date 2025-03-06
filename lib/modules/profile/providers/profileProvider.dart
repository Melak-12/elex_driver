// profileProvider.dart
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  // Mock driver data
  final Map<String, dynamic> _driverData = {
    'name': 'Kirbu wesen',
    'email': 'abebe.kebede@gmail.com',
    'phone': '+251961234',
    'rating': 4.8,
    'totalTrips': 1248,
    'memberSince': 'March 2022',
    'profileImage': 'https://i.pravatar.cc/300',
    'vehicle': {
      'model': 'Motor hammer',
      'year': '2020',
      'color': 'Silver',
      'licensePlate': 'ABC 123',
    },
    'bankAccount': {
      'accountNumber': '**** **** **** 4321',
      'bankName': 'CBE Bank',
    },
  };

  // Settings toggles
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  bool _availableForWork = true;
  bool _autoAcceptOrders = false;

  // Getters
  Map<String, dynamic> get driverData => _driverData;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get locationEnabled => _locationEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get availableForWork => _availableForWork;
  bool get autoAcceptOrders => _autoAcceptOrders;

  // Methods to update driver data
  void updateDriverName(String name) {
    _driverData['name'] = name;
    notifyListeners();
  }

  void updateDriverEmail(String email) {
    _driverData['email'] = email;
    notifyListeners();
  }

  void updateDriverPhone(String phone) {
    _driverData['phone'] = phone;
    notifyListeners();
  }

  void updateProfileImage(String imageUrl) {
    _driverData['profileImage'] = imageUrl;
    notifyListeners();
  }

  void updateVehicleInfo(Map<String, String> vehicleInfo) {
    _driverData['vehicle'] = vehicleInfo;
    notifyListeners();
  }

  void updateBankInfo(Map<String, String> bankInfo) {
    _driverData['bankAccount'] = bankInfo;
    notifyListeners();
  }

  // Methods to toggle settings
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleLocation(bool value) {
    _locationEnabled = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkModeEnabled = value;
    notifyListeners();
  }

  void toggleAvailableForWork(bool value) {
    _availableForWork = value;
    notifyListeners();
  }

  void toggleAutoAcceptOrders(bool value) {
    _autoAcceptOrders = value;
    notifyListeners();
  }

  // Method to simulate profile editing
  void editProfile({String? name, String? email, String? phone}) {
    if (name != null) _driverData['name'] = name;
    if (email != null) _driverData['email'] = email;
    if (phone != null) _driverData['phone'] = phone;
    notifyListeners();
  }

  // Method to simulate logout
  Future<bool> logout() async {
    // Simulate API call or local storage clearing
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
