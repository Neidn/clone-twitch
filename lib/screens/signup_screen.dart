import 'package:clone_twitch/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

import '/resources/auth_methods.dart';

import '/widgets/custom_button.dart';
import '/widgets/custom_text_field.dart';

import '/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthMethods _authMethods = AuthMethods();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;

  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signUpUser(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    _authMethods
        .signUpUser(
      context: context,
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((bool result) {
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    // Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        controller: _emailController,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Username
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        controller: _usernameController,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        controller: _passwordController,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign up button
                    CustomButton(
                      onPressed: () => signUpUser(context),
                      text: 'Sign up',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
