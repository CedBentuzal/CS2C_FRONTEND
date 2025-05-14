// Create this file as: lib/utils/error_handling.dart

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

// Custom exception types
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthException implements Exception {
  final String message;
  final int statusCode;
  AuthException(this.message, this.statusCode);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;
  ValidationException(this.message, {this.fieldErrors});
}

// Base service class with error handling
class BaseService {
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on SocketException {
      throw NetworkException("Network connection error");
    } on TimeoutException {
      throw NetworkException("Request timed out");
    } catch (e) {
      throw e;
    }
  }
}

// Error Handler class
class ErrorHandler {
  // Handle API errors in a consistent way
  static String handleApiError(dynamic error) {
    if (error is SocketException || error is TimeoutException) {
      return "Network connection error. Please check your internet connection.";
    } else if (error is AuthException) {
      return error.message;
    } else if (error is FormatException) {
      return "Invalid response format from server.";
    } else {
      return error.toString();
    }
  }

  // Show error in a snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Show success in a snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Log errors
  static void logError(String tag, dynamic error, StackTrace? stackTrace) {
    print("[$tag] Error: $error");
    if (stackTrace != null) {
      print("[$tag] StackTrace: $stackTrace");
    }
  }
}

// Loading dialog
class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Container(
            color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA48C60)),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
