import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Product>> fetchPublicProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint('Public product fetch error: $e');
      rethrow;
    }
  }

  Future<List<Product>> fetchUserProducts(BuildContext context) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await http.get(
        Uri.parse('$_baseUrl/products?user_id=${Provider.of<AuthProvider>(context, listen: false).userData?.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load user products');
      }
    } catch (e) {
      debugPrint('User product fetch error: $e');
      rethrow;
    }
  }

  Future<Product> addProduct(Product product, BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add product');
  }

  Future<void> deleteProduct(String id, BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}