import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myfrontend/data/model/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _userData;

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  User? get userData => _userData;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Raw response: ${response.body}'); // Debug log

      final data = jsonDecode(response.body);

      // Add null checks for critical fields
      if (response.statusCode == 200 && data['success'] == true) {
        if (data['token'] == null || data['user'] == null) {
          throw AuthException('Missing token or user data in response');
        }

        _token = data['token'] as String;

        // Ensure user data is properly typed
        if (data['user'] is Map<String, dynamic>) {
          _userData = User.fromJson(data['user'] as Map<String, dynamic>);
        } else {
          throw AuthException('Invalid user data format');
        }

        notifyListeners();
      } else {
        throw AuthException(data['message'] ?? 'Login failed');
      }
    } on FormatException {
      throw AuthException('Invalid server response format');
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _token = null;
    _userData = null;
    notifyListeners();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}