import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/form_button.dart';
import '../widgets/form_sizebox.dart';
import '../widgets/form_text_field.dart';
import '../services/auth/AuthService.dart';
import 'login.dart';
import 'phoneNumberLogin.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validPassword(String password) {
    if (password.length < 6 || RegExp(' ').hasMatch(password)) {
      return false;
    }
    return true;
  }

  bool _validConfirmPassword(String confirmPassword) {
    return confirmPassword == _passwordController.text;
  }

  bool _validForm() {
    return _validEmail(_emailController.text) &&
        _emailController.text.isNotEmpty &&
        _validPassword(_passwordController.text) &&
        _passwordController.text.isNotEmpty &&
        _validConfirmPassword(_confirmPasswordController.text) &&
        _confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final authService = AuthService();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 3,
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  "Sign up",
                  style: GoogleFonts.monoton(fontSize: 50, color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 380,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FormTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      onChanged: (value) => setState(() {}),
                      validator: _validEmail,
                    ),
                    formSizeBox(
                      controller: _emailController,
                      validFunc: _validEmail,
                      errorText: "Invalid email",
                    ),
                    FormTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onChanged: (value) => setState(() {}),
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    formSizeBox(
                      controller: _passwordController,
                      validFunc: _validPassword,
                      errorText: "Invalid password",
                    ),
                    FormTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (value) => setState(() {}),
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    formSizeBox(
                      controller: _confirmPasswordController,
                      validFunc: _validConfirmPassword,
                      errorText: "Passwords do not match",
                    ),
                    FormButton(
                      text: "Sign up",
                      isEnabled: _validForm,
                      onPressed: () {
                        authService.signUpWithEmailPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          context,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          AuthService().handleGoogleSignIn(context);
                        },
                        icon: Image.asset(
                          'assets/icons/google_logo.svg.ico',
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneNumberLoginPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.phone_android),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an email?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              duration: Duration(milliseconds: 500),
                              child: LoginPage(),
                            ),
                          );
                        },
                        child: Text("Log in"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
