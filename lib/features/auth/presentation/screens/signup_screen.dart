import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/widget/background.dart';
import 'package:myfrontend/features/auth/presentation/widget/signup_form.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen ({Key? key}):super(key: key);

  @override
  State<SignupScreen> createState ()=> _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(

      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: background(
          child: Stack(
            fit: StackFit.expand,
            children: [

              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isKeyboardVisible
                      ? screenHeight * 0.5
                      : screenHeight * 0.8,
                  child: SignupForm(

                    minHeight: null,
                    maxHeight: null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
