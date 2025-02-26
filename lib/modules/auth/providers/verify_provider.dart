import 'package:flutter/material.dart';

class VerifyProvider extends ChangeNotifier {
  final List<String> _verificationCode = List.filled(5, '');

  String getDigit(int index) {
    if (index >= 0 && index < 5) {
      return _verificationCode[index];
    }
    return '';
  }

  void updateCodeDigit(int index, String value) {
    if (index >= 0 && index < 5) {
      if (value.length > 1) {
        value = value.substring(value.length - 1);
      }

      _verificationCode[index] = value;
      notifyListeners();
    }
  }

  void clearCode() {
    for (int i = 0; i < 5; i++) {
      _verificationCode[i] = '';
    }
    notifyListeners();
  }

  bool isCodeComplete() {
    return !_verificationCode.contains('');
  }

  String getFullCode() {
    return _verificationCode.join();
  }
}
