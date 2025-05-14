import 'dart:async';
import 'package:myfrontend/data/model/product.dart';

class ProductService {
  // Simulate network delay
  final Duration _mockDelay = const Duration(milliseconds: 800);

  // Mock data
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Vintage Camera',
      price: 99.99,
      imageUrl: 'https://picsum.photos/300?random=1',
      description: 'Classic film camera from the 1980s',
    ),
    Product(
      id: '2',
      name: 'Wireless Headphones',
      price: 59.99,
      imageUrl: 'https://picsum.photos/300?random=2',
      description: 'Noise-cancelling Bluetooth headphones',
    ),
    Product(
      id: '3',
      name: 'Leather Notebook',
      price: 24.99,
      imageUrl: 'https://picsum.photos/300?random=3',
      description: 'Handmade leather-bound journal',
    ),
  ];

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(_mockDelay); // Simulate network call
    return _mockProducts;
  }

  Future<void> addProduct({
    required String name,
    required double price,
    String? description,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // Just pretend we saved it - in a real app, this would call your backend
    print('Mock product added: $name (\$$price)');
  }

  Future<void> deleteProduct(String id) async {
    await Future.delayed(_mockDelay);
    _mockProducts.removeWhere((product) => product.id == id);
  }


}