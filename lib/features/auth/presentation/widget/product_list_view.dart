import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/features/auth/presentation/widget/product_card.dart';
import 'package:myfrontend/features/auth/presentation/screens/add_product_screen.dart';
import 'package:myfrontend/features/auth/presentation/screens/product_detail_screen.dart'; // <-- Add this import

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => ProductListViewState();
}

class ProductListViewState extends State<ProductListView> {
  late Future<List<Product>> _productsFuture;
  final ProductService _service = ProductService();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      _productsFuture = _service.fetchPublicProducts();
    });
  }

  void _navigateToAddProduct(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).userData?.id ?? '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(userId: userId),
      ),
    ).then((_) => loadProducts());
  }

  void _viewProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadProducts,
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  TextButton(
                    onPressed: loadProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => ProductCard(
              product: products[index],
              onRefresh: loadProducts,
              onTap: () => _viewProduct(context, products[index]), // <-- Add this line
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory, size: 48),
          const SizedBox(height: 16),
          const Text('No products available'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _navigateToAddProduct(context),
            child: const Text('Add First Product'),
          ),
        ],
      ),
    );
  }
}