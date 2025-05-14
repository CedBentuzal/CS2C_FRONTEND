import 'package:flutter/material.dart';

class DefaultBg extends StatelessWidget{
  final Widget child;
  const DefaultBg ({Key? key, required this.child}): super(key: key);


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/default.png'),
          fit:BoxFit.cover
          ),
       ),
          child: child,
      ),
    );
  }
}