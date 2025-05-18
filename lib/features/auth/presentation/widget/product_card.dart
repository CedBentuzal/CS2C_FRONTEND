import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRefresh;
  final bool showActions;

  const ProductCard({
    super.key,
    required this.product,
    required this.onRefresh,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = context.read<AuthProvider>().userData?.id == product.userId;

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(context),
          _buildProductInfo(),
          if (showActions && isOwner) _buildOwnerActions(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
          progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('\$${product.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildOwnerActions(BuildContext context) {
    return ButtonBar(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () {}, // Implement edit functionality
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product?'),
        content: const Text('This action cannot be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<ProductService>(context, listen: false)
            .deleteProduct(product.id, context);
        onRefresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deletion failed: $e')),
        );
      }
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.pushNamed(context, '/product-detail', arguments: product);
  }
}