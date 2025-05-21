import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/presentation/widget/product_card.dart';
import 'package:myfrontend/features/auth/presentation/screens/product_detail_screen.dart';
import 'package:myfrontend/features/auth/presentation/widget/navigation_bar.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<Product>> _productsFuture;
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

  // Banner carousel
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  final List<Map<String, String>> _banners = [
    {
      'title': 'Shop wit us!',
      'subtitle': 'Get 40% Off for\nall iteams',
      'cta': 'Shop Now →',
      'image': 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=facearea&w=256&q=80',
    },
    {
      'title': 'Summer Sale!',
      'subtitle': 'Buy 1 Get 1 Free\non select items',
      'cta': 'Explore Deals →',
      'image': 'https://images.unsplash.com/photo-1524253482453-3fed8d2fe12b?auto=format&fit=facearea&w=256&q=80',
    },
    {
      'title': 'New Arrivals!',
      'subtitle': 'Check out the\nlatest trends',
      'cta': 'See What\'s New →',
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=facearea&w=256&q=80',
    },
  ];

  ProductService get _productService => Provider.of<ProductService>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProducts();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBanner + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
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
          (product.demographic != null && product.demographic == _selectedDemographic);
      return matchesSearch && matchesCategory && matchesDemographic;
    }).toList();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = _productService.fetchPublicProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().userData;
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome!', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(
                        user?.username ?? 'Guest',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScaffold(currentIndex: 2)),
                            (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'What are you looking for...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Promo Banner Carousel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _bannerController,
                    itemCount: _banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBanner = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0BB94),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Texts
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      banner['title']!,
                                      style: const TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      banner['subtitle']!,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner['cta']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Image
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  banner['image']!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Dots Indicator
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_banners.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentBanner == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentBanner == index ? Colors.white : Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Demographic Dropdown + Category Chips
          Row(
            children: [
              // Dropdown for "All" (Demographics)
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
                  underline: SizedBox(),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Horizontal category chips (skip "All" since it's now a dropdown)
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
                          selectedColor: Color(0xFFA48C60),
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
          // Product Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProducts,
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
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  final products = _filterProducts(snapshot.data ?? []);
                  if (products.isEmpty) {
                    return const Center(child: Text('No products available'));
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
          ),
        ],
      ),
    );
  }
}