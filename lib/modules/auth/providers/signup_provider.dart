import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userId => _userId;

  // Base URL for your API
  final String _baseUrl = 'https://your-api-endpoint.com/api';

  // Sign up method
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required File idFile,
  }) async {
    try {
      // Create a multipart request for file upload
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/auth/signup'),
      );

      // Add text fields
      request.fields['fullName'] = fullName;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      // Add the ID file
      request.files.add(
        await http.MultipartFile.fromPath(
          'idFile',
          idFile.path,
          filename: idFile.path.split('/').last,
        ),
      );

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      // Check if the request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _token = data['token'];
        _userId = data['userId'];
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to sign up');
      }
    } catch (e) {
      throw Exception('Error during signup: ${e.toString()}');
    }
  }

  // Login method
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _token = data['token'];
        _userId = data['userId'];
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to login');
      }
    } catch (e) {
      throw Exception('Error during login: ${e.toString()}');
    }
  }

  // Logout method
  void logout() {
    _token = null;
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check if token is valid
  Future<bool> autoLogin() async {
    // Implement token validation or refresh logic here
    // This could involve checking a stored token and validating it with your backend

    // For now, we'll just return the current authentication state
    return _isAuthenticated;
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    if (!_isAuthenticated || _token == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Error getting user profile: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? fullName,
    String? phone,
    File? newIdFile,
  }) async {
    if (!_isAuthenticated || _token == null) {
      throw Exception('User is not authenticated');
    }

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl/user/profile'),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $_token';

      // Add text fields if provided
      if (fullName != null) request.fields['fullName'] = fullName;
      if (phone != null) request.fields['phone'] = phone;

      // Add the new ID file if provided
      if (newIdFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'idFile',
            newIdFile.path,
            filename: newIdFile.path.split('/').last,
          ),
        );
      }

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      // Check if the request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!_isAuthenticated || _token == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Error changing password: ${e.toString()}');
    }
  }

  // Request password reset
  Future<void> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/request-reset'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(data['message'] ?? 'Failed to request password reset');
      }
    } catch (e) {
      throw Exception('Error requesting password reset: ${e.toString()}');
    }
  }
}
