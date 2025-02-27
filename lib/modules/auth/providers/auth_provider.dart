import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _countryCode = '+1';
  String _phoneEmail = '';
  bool _isLoading = false;
  String get countryCode => _countryCode;
  String get phoneEmail => _phoneEmail;
  bool get isLoading => _isLoading;

  void setCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  void updatePhoneEmail(String value) {
    _phoneEmail = value;
    notifyListeners();
  }

  Future<void> login(String value) async {
    if (_phoneEmail.isEmpty) {
      debugPrint('Please enter a valid email or phone number');
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('Login successful for $_phoneEmail');
    } catch (e) {
      debugPrint('Login failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
