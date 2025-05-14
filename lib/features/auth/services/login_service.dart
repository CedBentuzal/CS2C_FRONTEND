import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myfrontend/core/errors/error_handling.dart';

class LoginService {
  static final BaseService _baseService = BaseService();

  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    await dotenv.load();
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://default-url.com';
    final Uri url = Uri.parse('$baseUrl/api/login');

    try {
      // Use the safeApiCall method to handle network errors
      return await _baseService.safeApiCall(() async {
        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email, 'password': password}),
            )
            .timeout(Duration(seconds: 15)); // Set timeout

        final data = jsonDecode(response.body);

        // Handle different HTTP status codes
        if (response.statusCode == 200 && data.containsKey('token')) {
          String token = data['token'];
          String username = data['username'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('username', username);

          ErrorHandler.logError('LoginService', 'Login successful', null);
          return "success";
        } else if (response.statusCode == 401) {
          throw AuthException(
            "Invalid email or password. Please try again.",
            401,
          );
        } else if (response.statusCode == 403) {
          throw AuthException(
            "Please verify your email before logging in.",
            403,
          );
        } else {
          throw AuthException(
            data['message'] ?? 'Login failed.',
            response.statusCode,
          );
        }
      });
    } catch (e) {
      ErrorHandler.logError('LoginService', e, StackTrace.current);
      return ErrorHandler.handleApiError(e);
    }
  }
}
