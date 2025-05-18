import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/screens/auth_screen.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Required'),
      content: const Text('You need to login to access your dashboard'),
      actions: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          ),
          child: const Text('->'),
        ),
      ],
    );
  }
}