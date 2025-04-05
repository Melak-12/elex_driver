import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:elex_driver/modules/profile/models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;
  String? _error;
  bool _isLoggingOut = false;
  bool _isUpdating = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggingOut => _isLoggingOut;
  bool get isUpdating => _isUpdating;

  Future<void> fetchProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final String response =
          await rootBundle.loadString('assets/jsons/profile.json');
      final data = await json.decode(response);

      if (data['success'] == true && data['data'] != null) {
        _profile = Profile.fromJson(data['data']);
      } else {
        _error = 'Failed to load profile';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleOnlineStatus() async {
    try {
      _isUpdating = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (_profile != null) {
        _profile = Profile(
          id: _profile!.id,
          name: _profile!.name,
          email: _profile!.email,
          phone: _profile!.phone,
          profileImage: _profile!.profileImage,
          licenseNumber: _profile!.licenseNumber,
          vehicleType: _profile!.vehicleType,
          vehicleNumber: _profile!.vehicleNumber,
          isOnline: !_profile!.isOnline,
          rating: _profile!.rating,
          totalDeliveries: _profile!.totalDeliveries,
          completedDeliveries: _profile!.completedDeliveries,
          pendingDeliveries: _profile!.pendingDeliveries,
          status: _profile!.status,
          lastActive: _profile!.lastActive,
          notificationSettings: _profile!.notificationSettings,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotificationSetting(String key) async {
    try {
      _isUpdating = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (_profile != null) {
        final updatedSettings =
            Map<String, bool>.from(_profile!.notificationSettings);
        updatedSettings[key] = !(updatedSettings[key] ?? false);

        _profile = Profile(
          id: _profile!.id,
          name: _profile!.name,
          email: _profile!.email,
          phone: _profile!.phone,
          profileImage: _profile!.profileImage,
          licenseNumber: _profile!.licenseNumber,
          vehicleType: _profile!.vehicleType,
          vehicleNumber: _profile!.vehicleNumber,
          isOnline: _profile!.isOnline,
          rating: _profile!.rating,
          totalDeliveries: _profile!.totalDeliveries,
          completedDeliveries: _profile!.completedDeliveries,
          pendingDeliveries: _profile!.pendingDeliveries,
          status: _profile!.status,
          lastActive: _profile!.lastActive,
          notificationSettings: updatedSettings,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoggingOut = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _profile = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
