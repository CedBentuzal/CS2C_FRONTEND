import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/presentation/screens/catalog_screen.dart';
import 'package:myfrontend/features/auth/presentation/screens/signup_screen.dart';
import 'package:myfrontend/features/auth/presentation/widget/keyboard_avoiding_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/features/auth/presentation/widget/navigation_bar.dart'; // <-- Import MainScaffold

class LoginForm extends StatefulWidget {
  final double? minHeight;  // Optional minimum height
  final double? maxHeight;  // Optional maximum height
  const LoginForm({Key? key, this.minHeight, this.maxHeight}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical:10),
          child: KeyboardAvoidingWrapper(
            minHeight: widget.minHeight ?? constraints.maxHeight * 0.5,
            maxHeight: widget.maxHeight ?? constraints.maxHeight * 0.9,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20,),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height:0),
                    const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA48C60),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
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
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final auth = Provider.of<AuthProvider>(context, listen: false);
                            await auth.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const MainScaffold(currentIndex: 0)),
                                  (route) => false,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));},
                          child: const Text('Sign Up',
                            style: TextStyle(
                              color: Color(0xFFA48C60),
                            ),
                          ),
                        ),
                      ],
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