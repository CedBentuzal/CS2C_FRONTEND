import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';
import 'package:myfrontend/features/auth/provider/cart_provider.dart';
import 'package:myfrontend/features/auth/presentation/widget/navigation_bar.dart';
import 'package:myfrontend/features/auth/presentation/screens/welcome_screen.dart';
import 'package:myfrontend/utils/navigator_key.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // <-- Make sure this is awaited!
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seenWelcome') ?? false;
  runApp(MyApp(seenWelcome: seenWelcome));
}

class MyApp extends StatelessWidget {
  final bool seenWelcome;
  const MyApp({super.key, required this.seenWelcome});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Add this line
        debugShowCheckedModeBanner: false,
        home: seenWelcome
            ? const MainScaffold(currentIndex: 0)
            : const WelcomeScreen(),
      ),
    );
  }
}