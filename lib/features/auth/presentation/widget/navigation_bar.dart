import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/presentation/screens/catalog_screen.dart';
import 'package:myfrontend/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:myfrontend/features/auth/presentation/screens/default_screen.dart';
import 'package:myfrontend/features/auth/presentation/screens/cart_screen.dart';

class MainScaffold extends StatefulWidget {
  final int currentIndex;
  final Widget? body;

  const MainScaffold({
    super.key,
    this.currentIndex = 0,
    this.body,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    _initializeScreens();
  }

  void _initializeScreens() {
    final auth = context.read<AuthProvider>();
    _screens = [
      const CatalogScreen(),
      const Scaffold(body: Center(child: Text('Favorites'))),
      const CartScreen(),
      auth.isLoggedIn
          ? DashboardScreen(user: auth.userData!)
          : const Scaffold(body: Center(child: Text('Profile'))),
    ];
  }

  void _onBottomNavTap(int index) {
    final auth = context.read<AuthProvider>();
    // Restrict Cart (index 2) and Profile (index 3) to logged-in users
    if ((index == 2 || index == 3) && !auth.isLoggedIn) {
      showDialog(
        context: context,
        builder: (_) => const DefaultScreen(),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}