import 'package:flutter/material.dart';

class KeyboardAvoidingWrapper extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  const KeyboardAvoidingWrapper({
    Key? key,
    required this.child,
    required this.minHeight,
    required this.maxHeight
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: BoxConstraints(
        minHeight: keyboardVisible ? 300 : minHeight, // Fixed minimum height when keyboard shows
        maxHeight: maxHeight,
      ),
      child: child,
    );
  }
}