import 'package:flutter/material.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/features/auth/provider/cart_provider.dart';
import 'package:myfrontend/features/auth/presentation/screens/sellers_store_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImage = 0;
  bool _readMore = false;
  String? _selectedSize;
  String? _selectedColor;
  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = [
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
    ];
    if (widget.product.sizes != null && widget.product.sizes!.isNotEmpty) {
      _selectedSize = widget.product.sizes!.first;
    }
    if (widget.product.colors != null && widget.product.colors!.isNotEmpty) {
      _selectedColor = widget.product.colors!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final isLoggedIn = authProvider.isLoggedIn;
    final isOwner = isLoggedIn && authProvider.userData?.id == product.userId;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: isLoggedIn
                ? () {
              // TODO: Implement favorite logic
            }
                : () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Login Required'),
                  content: const Text('Please log in to favorite products.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            tooltip: isLoggedIn ? 'Favorite' : 'Login to favorite',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Main Image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                _images[_selectedImage],
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
              ),
            ),
          ),
          // Thumbnails
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _selectedImage = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    border: _selectedImage == index
                        ? Border.all(color: Colors.brown, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _images[index],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 24),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Category and Rating Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  "${product.category}'s Style",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  (product.rating ?? 4.5).toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Product Details Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Product Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Product Description with Read More
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Builder(
              builder: (context) {
                final desc = product.description ?? 'No description available';
                if (desc.length < 80) {
                  return Text(desc);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _readMore ? desc : desc.substring(0, 80) + '...',
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _readMore = !_readMore),
                      child: Text(
                        _readMore ? 'Read less' : 'Read more',
                        style: const TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Size Selection (if available)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Available Sizes',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (product.sizes != null && product.sizes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: product.sizes!.map((size) {
                  final selected = _selectedSize == size;
                  return ChoiceChip(
                    label: Text(size),
                    selected: selected,
                    onSelected: (val) {
                      setState(() => _selectedSize = size);
                    },
                    selectedColor: Color(0xFFA48C60),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'No Size Specified',
                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
            ),

          const SizedBox(height: 16),

          // Color Selection (if available)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Available Colors',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (product.colors != null && product.colors!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: product.colors!.map((color) {
                  final selected = _selectedColor == color;
                  return ChoiceChip(
                    label: Text(color),
                    selected: selected,
                    onSelected: (val) {
                      setState(() => _selectedColor = color);
                    },
                    selectedColor: Color(0xFFA48C60),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'No Color Specified',
                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 24),

          // Seller Store Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellerStoreScreen(
                      sellerId: product.userId,
                      sellerName: product.sellerUsername ?? 'Seller', // TODO: Get seller name from API
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFA48C60),
                      radius: 24,
                      child: const Icon(Icons.store, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seller\'s Store',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'View all products from this seller',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Text(
              'Total Price\n\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  !isLoggedIn
                      ? 'Login to Add to Cart'
                      : isOwner
                      ? 'Cannot Add Own Product'
                      : 'Add to Cart',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: (!isLoggedIn || isOwner)
                    ? null
                    : () {
                  try {
                    cartProvider.addToCart(
                      product,
                      size: _selectedSize ?? '',
                      color: _selectedColor ?? '',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (!isLoggedIn || isOwner)
                      ? Colors.grey[400]
                      : Color(0xFFA48C60),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}