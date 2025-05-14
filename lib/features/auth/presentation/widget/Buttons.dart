import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String text;
  final Function() onPressed;

  Buttons({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.30,
      height: screenHeight * 0.05,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFA48C60),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
