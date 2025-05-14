import 'package:flutter/material.dart';

class background extends StatelessWidget{
  final Widget child;
  const background ({Key? key,required this.child}): super(key: key);


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backG.png'),
          fit: BoxFit.cover
        ),
      ),
        child: child,
      ),
    );
  }
}
