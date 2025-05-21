import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfrontend/features/auth/presentation/widget/navigation_bar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _onGetStarted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenWelcome', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScaffold(currentIndex: 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Main hero image with accent circle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      // Main clothing image
                      'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=facearea&w=600&q=80',
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Circular accent image
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1524253482453-3fed8d2fe12b?auto=format&fit=facearea&w=200&q=80',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // App title and subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: const [
                  Text(
                    'The Thrift App That\nMakes You Look Your Best',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Discover unique, affordable fashion and express your style. Shop the best thrift finds, only a tap away!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B4F27),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _onGetStarted(context),
                  child: const Text(
                    "Let's Get Started",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Sign In link
            TextButton(
              onPressed: () => _onGetStarted(context),
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(
                  color: Color(0xFF7B4F27),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}