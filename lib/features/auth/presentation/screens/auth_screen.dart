import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/widget/default.dart';
import 'package:myfrontend/features/auth/presentation/screens/login_screens.dart';
import 'package:myfrontend/features/auth/presentation/screens/signup_screen.dart';
import 'package:myfrontend/features/auth/presentation/widget/Buttons.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultBg(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttons(
                  text: 'Sign in',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                SizedBox( width: screenWidth * 0.15),
                Buttons(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}