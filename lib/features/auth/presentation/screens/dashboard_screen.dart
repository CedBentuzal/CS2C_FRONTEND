import 'package:flutter/material.dart';
import 'package:myfrontend/data/model/user.dart';
import 'package:myfrontend/features/auth/presentation/screens/add_product_screen.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.username}\'s Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard, size: 50),
            const SizedBox(height: 20),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddProductScreen(userId: user.id)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}