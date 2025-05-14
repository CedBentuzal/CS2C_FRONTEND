import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/widget/keyboard_avoiding_wrapper.dart';

class SignupForm extends StatefulWidget {
  final double? minHeight;
  final double? maxHeight;
  const SignupForm ({Key? key, this.minHeight,this.maxHeight}): super(key: key);

  @override
  State<SignupForm> createState()=> _SignupFormState();
  }

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>() ;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();

}
@override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints)
    {
      double height = constraints.maxHeight;
      if (widget.maxHeight != null && height > widget.maxHeight!) {
        height = widget.maxHeight!;
      }
      if (widget.minHeight != null && height < widget.minHeight!) {
        height = widget.minHeight!;
      }

      return Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            minHeight: widget.minHeight ?? constraints.minHeight * 0.6,
            maxHeight: widget.maxHeight ?? constraints.maxHeight * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: KeyboardAvoidingWrapper(
            minHeight: widget.minHeight ?? constraints.minHeight * 0.6,
            maxHeight: widget.maxHeight ?? constraints.maxHeight * 0.9,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom + 20, top: 20,),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 0),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA48C60),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.verified_user),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please enter username';
                      }
                        return null;
                      }
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ) ,
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                          ),
                          onPressed: (){
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please enter password';
                        }
                        if (value.length < 6){
                          return 'Password must be at least 6';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmpasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                           ? Icons.visibility
                           :Icons.visibility_off,
                          ),
                          onPressed: (){
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please confirm password';
                        }
                        if (value != _passwordController.text){
                          return 'Not match';
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color(0xFFA48C60),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: (){
                        if (_formKey.currentState!.validate()){

                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}