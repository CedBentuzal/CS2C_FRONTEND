import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/features/auth/presentation/screens/add_product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showActions;
  final VoidCallback? onRefresh;
  final VoidCallback? onTap;
  final double width;
  final bool showCategory;

  const ProductCard({
    super.key,
    required this.product,
    this.showActions = false,
    this.onRefresh,
    this.onTap,
    this.width = double.infinity,
    this.showCategory = true,
  });

  const ProductCard.small({
    super.key,
    required this.product,
    this.onTap,
  })  : showActions = false,
        onRefresh = null,
        width = 150,
        showCategory = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = context.read<AuthProvider>().userData?.id == product.userId;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with Category Badge
              Stack(
                children: [
                  _buildProductImage(),
                  if (showCategory && product.category != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildCategoryChip(theme),
                    ),
                ],
              ),

              // Product Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Description (condensed)
                    if (product.description?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          product.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Owner Actions
              if (showActions && isOwner) _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'product-${product.id}',
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
          progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    return Chip(
      label: Text(
        product.category!,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 20, color: Theme.of(context).colorScheme.primary),
            onPressed: () => _editProduct(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _editProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(
          product: product,
          userId: context.read<AuthProvider>().userData!.id,
        ),
      ),
    ).then((_) => onRefresh?.call());
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: const Text('This cannot be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<ProductService>(context, listen: false)
                    .deleteProduct(product.id, context);
                onRefresh?.call();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}