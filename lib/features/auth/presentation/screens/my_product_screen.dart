import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/features/auth/presentation/widget/product_card.dart';
import 'package:myfrontend/features/auth/presentation/screens/add_product_screen.dart';

class MyProductScreen extends StatefulWidget {
  final String userId;
  const MyProductScreen({super.key, required this.userId});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  late Future<List<Product>> _userProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _userProducts = Provider.of<ProductService>(context, listen: false).fetchUserProducts(context);
  }

  void _navigateToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(userId: widget.userId),
      ),
    );
    _loadProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _userProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) => ProductCard(
              product: products[index],
              showActions: true,
              onRefresh: _loadProducts,
            ),
          );
        },
      ),
    );
  }
}