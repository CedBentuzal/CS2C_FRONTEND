import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';

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
    final isOwner = context.read<AuthProvider>().userData?.id == product.userId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Category Badge and Favorite Button
            Stack(
              children: [
                // Fixed height image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5E9DA),
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48, color: Color(0xFF4A4A4A)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Category Badge
                if (showCategory && product.category != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        product.category!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B4F27),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Add to favorites functionality
                      },
                      color: const Color(0xFF7B4F27),
                      iconSize: 20,
                      splashRadius: 20,
                    ),
                  ),
                ),
              ],
            ),
            // Product Details
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF3E2723),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF7B4F27),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description
                    if (product.description != null)
                      Text(
                        product.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (showActions) ...[
                      const SizedBox(height: 8),
                      const Divider(height: 16),
                      Row(
                        children: [
                          // Seller Avatar
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFFE6D5C3),
                            child: Text(
                              product.userId.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Seller Name
                          Expanded(
                            child: Text(
                              'Seller ID: ${product.userId.substring(0, 6)}...',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Edit/Delete buttons for owner
                          if (isOwner) ...[
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                // Edit product
                              },
                              color: const Color(0xFF4A4A4A),
                              splashRadius: 18,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () {
                                // Delete product
                              },
                              color: Colors.red,
                              splashRadius: 18,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}