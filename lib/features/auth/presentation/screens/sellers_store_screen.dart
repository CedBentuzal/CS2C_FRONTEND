import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/features/auth/presentation/widget/product_card.dart';
import 'package:myfrontend/features/auth/presentation/screens/product_detail_screen.dart';

class SellerStoreScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;

  const SellerStoreScreen({
    super.key,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  State<SellerStoreScreen> createState() => _SellerStoreScreenState();
}

class _SellerStoreScreenState extends State<SellerStoreScreen> {
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedDemographic;

  final List<String> _categories = [
    'All', 'Jackets', 'Jeans', 'Shoes', 'Shirts', 'Accessories',
    'Dresses', 'Tops', 'Bottoms', 'Outerwear', 'Bags', 'Hats',
    'Sportswear', 'Vintage', 'Formal', 'Casual', 'Kids', 'Men', 'Women', 'Unisex', 'Others'
  ];

  final List<String> _demographics = [
    'All', 'Adult', 'Child', 'Teenage', 'Trend'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All';
    _selectedDemographic = 'All';
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = _productService.fetchSellerProducts(widget.sellerId);
    });
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.description ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      final matchesDemographic = _selectedDemographic == null ||
          _selectedDemographic == 'All' ||
          (product.description?.toLowerCase().contains(_selectedDemographic!.toLowerCase()) ?? false) ||
          (product.name.toLowerCase().contains(_selectedDemographic!.toLowerCase()));
      return matchesSearch && matchesCategory && matchesDemographic;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.sellerName}\'s Store',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Demographic Dropdown + Category Chips
          Row(
            children: [
              // Demographic Dropdown
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: DropdownButton<String>(
                  value: _selectedDemographic ?? 'All',
                  items: _demographics.map((demo) {
                    return DropdownMenuItem(
                      value: demo,
                      child: Text(demo),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDemographic = value;
                      _selectedCategory = 'All'; // Reset category to All when demographic changes
                    });
                  },
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Category Chips (skip "All" since it's now a dropdown)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: _categories.length - 1,
                    itemBuilder: (context, index) {
                      final category = _categories[index + 1]; // skip "All"
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFFA48C60),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // Products Grid
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final products = _filterProducts(snapshot.data ?? []);
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: products[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}