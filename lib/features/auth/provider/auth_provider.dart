import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfrontend/data/model/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _userData;
  bool _isLoading = false;

  // Getters
  bool get isLoggedIn => _token != null;
  String? get token => _token;
  User? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['token'];
        _userData = User.fromJson(data['user']);
        notifyListeners();
      } else {
        throw AuthException(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      _clearAuthState();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode != 200 || data['success'] != true) {
      throw AuthException(data['message'] ?? 'Login failed');
    }

    if (data['token'] == null || data['user'] == null) {
      throw AuthException('Missing authentication data');
    }

    return data;
  }

  Future<void> logout() async {
    _clearAuthState();
    // Optional: Call backend logout endpoint if exists
  }

  void _clearAuthState() {
    _token = null;
    _userData = null;
    notifyListeners();
  }

  // Add this for token persistence
  Future<void> init() async {
    // Load token/user from secure storage if needed
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message; // Cleaner error display
}