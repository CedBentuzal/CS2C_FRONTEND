import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/data/model/user.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/presentation/screens/my_product_screen.dart';
import 'package:myfrontend/features/auth/services/recent_activity_service.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';

Future<List<Product>> fetchRecentActivity(BuildContext context) async {
  final ids = await RecentActivityService.getRecentProductIds();
  if (ids.isEmpty) return [];
  final allProducts = await Provider.of<ProductService>(context, listen: false).fetchPublicProducts();
  final recentProducts = ids
      .map((id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  })
      .whereType<Product>()
      .toList();
  return recentProducts;
}

class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFFA48C60),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFFA48C60)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Edit profile logic
                    },
                  ),
                ],
              ),
            ),
            // Store/Purchase Tabs
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyProductScreen(userId: user.id),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.brown.shade300,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.store, color: Colors.brown),
                            SizedBox(height: 4),
                            Text('MyStore', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: const [
                          Icon(Icons.shopping_bag, color: Colors.grey),
                          SizedBox(height: 4),
                          Text('Purchase', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Purchase Status Row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _DashboardIcon(icon: Icons.local_shipping, label: 'To receive'),
                  _DashboardIcon(icon: Icons.local_mall, label: 'To Ship'),
                  _DashboardIcon(icon: Icons.assignment_turned_in, label: 'Completed'),
                  _DashboardIcon(icon: Icons.cancel, label: 'Cancelled'),
                ],
              ),
            ),
            // Activities
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _DashboardIcon(icon: Icons.mail, label: 'Message'),
                      _DashboardIcon(icon: Icons.settings, label: 'Settings'),
                      _DashboardIcon(icon: Icons.favorite_border, label: 'Favorites'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _DashboardIcon(icon: Icons.location_on, label: 'Location'),
                      _DashboardIcon(icon: Icons.notifications, label: 'Notification'),
                      _DashboardIcon(icon: Icons.receipt_long, label: 'Transaction'),
                    ],
                  ),
                ],
              ),
            ),
            // Recent Store
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Recent Store', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: FutureBuilder<List<Product>>(
                      future: fetchRecentActivity(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        final products = snapshot.data ?? [];
                        if (products.isEmpty) {
                          return const Center(child: Text('No Recent', style: TextStyle(color: Colors.grey, fontSize: 18)));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                // Optionally navigate to product detail
                              },
                              child: Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.imageUrl,
                                        width: 80,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[200],
                                          width: 80,
                                          height: 60,
                                          child: const Icon(Icons.broken_image, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Other Store
            Expanded(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Column(
                  children: [
                    const Text('Other Store', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      )),
                    ),
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

class _DashboardIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DashboardIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.brown),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}