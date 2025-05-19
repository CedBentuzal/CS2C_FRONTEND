import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  // Use environment variable with fallback to emulator address
  String get _baseUrl {
    return dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:3000') + '/api';
  }

  // Add authorization headers helper
  Future<Map<String, String>> _getAuthHeaders(BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) throw Exception('Not authenticated');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Fetch all public products (with optional filters)
  Future<List<Product>> fetchPublicProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle both array and object responses
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('products')) {
          return (data['products'] as List).map((json) => Product.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Public product fetch error: $e');
      rethrow;
    }
  }


  // Fetch latest products (for dashboard)
  Future<List<Product>> fetchLatestProducts({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products?sort=newest&limit=$limit'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load latest products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Latest products fetch error: $e');
      rethrow;
    }
  }

  // Fetch user's products
  Future<List<Product>> fetchUserProducts(BuildContext context) async {
    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).userData?.id;
      final response = await http.get(
        Uri.parse('$_baseUrl/products?user_id=$userId'),
        headers: await _getAuthHeaders(context),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load user products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('User product fetch error: $e');
      rethrow;
    }
  }

  // Add new product
  Future<Product> addProduct(Product product, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products'),
        headers: await _getAuthHeaders(context),
        body: jsonEncode(product.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add product (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Add product error: $e');
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String id, BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/products/$id'),
        headers: await _getAuthHeaders(context),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete product (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Delete product error: $e');
      rethrow;
    }
  }

  // Get all unique categories
  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/categories'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => item.toString())
            .toList();
      } else {
        throw Exception('Failed to load categories (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Categories fetch error: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/products/${product.id}'),
        headers: await _getAuthHeaders(context),
        body: jsonEncode(product.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      debugPrint('Update product error: $e');
      rethrow;
    }
  }
}