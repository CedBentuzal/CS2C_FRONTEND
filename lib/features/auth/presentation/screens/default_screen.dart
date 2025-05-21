import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/screens/auth_screen.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.lock_outline, color: Colors.deepPurple, size: 28),
          SizedBox(width: 8),
          Text(
            'Login Required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'You need to login to access this feature.\nPlease login to continue.',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AuthScreen()),
            );
          },
          icon: const Icon(Icons.login, size: 20),
          label: const Text('Login Now'),
        ),
      ],
    );
  }
}