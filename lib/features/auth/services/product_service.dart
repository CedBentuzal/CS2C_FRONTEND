import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  String get _baseUrl {
    return dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:3000') + '/api';
  }

  Future<Map<String, String>> _getAuthHeaders(BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) throw Exception('Not authenticated');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // --- FIXED: Fetch all public products ---
  Future<List<Product>> fetchPublicProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('products')) {
          return (data['products'] as List).map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('data')) {
          return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
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

  // --- FIXED: Fetch latest products ---
  Future<List<Product>> fetchLatestProducts({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products?sort=newest&limit=$limit'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('products')) {
          return (data['products'] as List).map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('data')) {
          return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load latest products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Latest products fetch error: $e');
      rethrow;
    }
  }

  // --- FIXED: Fetch user's products ---
  Future<List<Product>> fetchUserProducts(BuildContext context) async {
    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).userData?.id;
      final response = await http.get(
        Uri.parse('$_baseUrl/products?user_id=$userId'),
        headers: await _getAuthHeaders(context),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('products')) {
          return (data['products'] as List).map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('data')) {
          return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load user products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('User product fetch error: $e');
      rethrow;
    }
  }

  // --- NEW: Fetch products by seller ID (public, no auth required) ---
  Future<List<Product>> fetchSellerProducts(String sellerId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products?seller_id=$sellerId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('products')) {
          return (data['products'] as List).map((json) => Product.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('data')) {
          return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load seller products (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Seller product fetch error: $e');
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